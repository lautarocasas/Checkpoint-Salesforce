/**
    * @description Controlador dedicado a gestionar los datos del objeto Proyecto
*/
public with sharing class ProjectController {
    /**
     * @description Se obtienen el total de recursos de una cuenta especifica
     * @param accountId El id de la cuenta a obtener sus recursos
     * @return La cantidad total de recursos asociados a una cuenta
    */
    @AuraEnabled(cacheable=true scope='global')
    public static Integer getTotalResourcesForAccount(Id accountId){
        Integer totalResources = 0;
        List<AggregateResult> accountResources = [SELECT Account__r.Id,SUM(Numero_de_Recursos__c)totalResources FROM Proyecto__c WHERE Account__r.Id = :accountId WITH USER_MODE GROUP BY Account__r.Id];
        if(accountResources.size()>0){
            Decimal rawTotal = (Decimal)accountResources[0].get('totalResources');
            totalResources = rawTotal.intValue();
        }
        return totalResources;
    }

    /**
     * @description Se obtienen el total de proyectos de una cuenta especifica
     * @param accountId El id de la cuenta a obtener sus proyectos
     * @return La lista de proyectos asociados a una cuenta
    */
    @AuraEnabled(cacheable=true)
    public static List<Proyecto__c> getProjectsByAccount(Id accountId) {
        return [
            SELECT Id, Name, Contact__r.Name, Presupuesto__c, Estado__c
            FROM Proyecto__c
            WHERE Account__r.Id = :accountId
            WITH USER_MODE
        ];
    }
}