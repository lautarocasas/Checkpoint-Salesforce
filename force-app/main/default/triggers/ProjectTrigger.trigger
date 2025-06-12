trigger ProjectTrigger on Proyecto__c (after insert,after update,after delete,before insert,before update,before delete) {
    if(TriggerControl.skipTriggers) return;

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //Antes de actualizar o insertar registros de proyecto
            ProjectTriggerHandler.handleMaxProjects(Trigger.new);
        }
        else if(Trigger.isDelete){
            //Antes de borrar registros de proyecto
            ProjectTriggerHandler.handleBeforeDelete(Trigger.old);
        }
    }
    else if(Trigger.isAfter){
        //Luego de haber insertado, actualizado o eliminados registros de proyecto
        if(Trigger.isInsert || Trigger.isUpdate){
            ProjectTriggerHandler.updateAverageBudgets(Trigger.new);
            ProjectTriggerHandler.handleHighBudget(Trigger.new);
        }
        else{
            ProjectTriggerHandler.updateAverageBudgets(Trigger.old);
        }
    }
}