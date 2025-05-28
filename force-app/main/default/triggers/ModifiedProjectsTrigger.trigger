trigger ModifiedProjectsTrigger on Proyecto__c (after insert,after update,after delete) {
    ModifiedProjectsTriggerHandler.updateAverageBudgets();
}