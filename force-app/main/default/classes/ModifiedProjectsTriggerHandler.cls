public with sharing class ModifiedProjectsTriggerHandler {
    public ModifiedProjectsTriggerHandler() {
        public static void updateAverageBudgets(){
            List<Proyecto__c> averageBudgetsForAccount =
                [SELECT AVG(Presupuesto__c)avgBudget,Account__r.id
                 FROM Proyecto__c
                 GROUP BY Account__r.id];
            
            List<Account> accountsToUpdate = new List<Account>();
            for(Proyecto__c p: averageBudgetsForAccount){
                Account accToUpdate = new Account(
                    id = p.Account__r.id,
                    Presupuesto_promedio__c = p.avgBudget);
            }

            update accountsToUpdate;
        }
    }
}