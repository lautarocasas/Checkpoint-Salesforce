/**
    * @description Clase dedicada a manejar los eventos dentro del trigger ProjectTrigger
*/
public with sharing class ProjectTriggerHandler{
    /**
        * @description Metodo que actualiza los presupuestos promedio de cada cuenta
        * @param updatedProjects Los proyectos que fueron insertados, actualizados o eliminados
    */
    public static void updateAverageBudgets(List<Proyecto__c> updatedProjects){
        Set<Id> accountIds = new Set<Id>();     //Un set de los Ids de cuentas asociadas a los nuevos proyectos
        for(Proyecto__c p: updatedProjects){
            if (p.Estado__c == 'En Progreso'){
                accountIds.add(p.Account__c);
            }
        }
        List<AggregateResult> averageBudgetsForAccount = [SELECT AVG(Presupuesto__c)avgBudget,Account__r.Id acc FROM Proyecto__c WHERE Account__r.Id IN :accountIds WITH USER_MODE GROUP BY Account__r.Id];

        List<Account> accountsToUpdate = new List<Account>();
        for(AggregateResult ar: averageBudgetsForAccount){
            Account accToUpdate = new Account(
                id = (Id)ar.get('acc'),
                Presupuesto_promedio__c = (Decimal)ar.get('avgBudget')
            );
            accountsToUpdate.add(accToUpdate);
        }

        if (!Schema.sObjectType.Account.fields.Presupuesto_promedio__c.isUpdateable()){
            return;
        }

        update accountsToUpdate;
    }

    /**
     * @description Metodo que previene el borrado de proyectos que no cumplan con la condicion establecida
     * @param deletedProjects Los proyectos que van a borrarse
    */
    public static void handleBeforeDelete(List<Proyecto__c> deletedProjects){
        for(Proyecto__c p: deletedProjects){
            if(p.Fecha_de_Inicio__c >= Date.today().addYears(-1) || p.Estado__c != 'Planeado'){
                p.addError(new DmlException('Solo se pueden eliminar proyectos que deberían haber iniciado hace más de un año y siguen en estado planeado.'));
            }
        }
    }

    /**
        * @description Metodo que previene que se supere el maximo de proyectos activos por cuenta
        * @param newProjects Los proyectos que fueron insertados o actualizados
    */
    public static void handleMaxProjects(List<Proyecto__c> newProjects){
        Set<Id> accountIds = new Set<Id>();     //Un set de los Ids de cuentas asociadas a los nuevos proyectos
        Map<Id, Integer> newProjectsForAccount = new Map<Id, Integer>();    //Un mapa que asocia una cuenta con la cantidad de nuevos proyectos en estado "En Progreso"
        for(Proyecto__c p: newProjects){
            if (p.Estado__c == 'En Progreso'){
                accountIds.add(p.Account__c);
                newProjectsForAccount.put(p.Account__c, (newProjectsForAccount.get(p.Account__c) ?? 0 )+1);
            }
        }

        Map<Id, Integer> accountProjectLimit = new Map<Id, Integer>();
        for (Account a : [
            SELECT Id, Maximo_de_proyectos_activos__c
            FROM Account
            WHERE Id IN :accountIds
            WITH USER_MODE
        ]) {
            accountProjectLimit.put(a.Id, (Integer)a.Maximo_de_proyectos_activos__c);
        }

        Map<Id, Integer> activeProjectsForAccount = new Map<Id, Integer>();     //Obtener la cantidad de proyectos que se encuentran "En Progreso" por cada cuenta
        for (AggregateResult ar : [
            SELECT Account__c acc, COUNT(Id)cnt
            FROM Proyecto__c
            WHERE Account__c IN :accountIds AND Estado__c = 'En Progreso'
            WITH USER_MODE
            GROUP BY Account__c
        ]) {
            Id accId = (Id) ar.get('acc');
            Integer cnt  = (Integer) ar.get('cnt');
            activeProjectsForAccount.put(accId, cnt);
        }


        for(Proyecto__c p: newProjects){
            if (p.Estado__c == 'En Progreso'){
                Integer accountActiveProjects = activeProjectsForAccount.get(p.Account__c) ?? 0;
                Integer accountNewProjects = newProjectsForAccount.get(p.Account__c) ?? 0;
                Integer maxAccountProjects = accountProjectLimit.get(p.Account__c) ?? 0;

                if(accountActiveProjects + accountNewProjects > maxAccountProjects){
                    p.addError(new DmlException('La cuenta a la que se intenta asociar este proyecto supera la cantidad maxima de proyectos "En Progreso" que puede tener.'));
                }
            }
        }
    }
}