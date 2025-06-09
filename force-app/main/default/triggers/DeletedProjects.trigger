trigger DeletedProjects on SOBJECT (before delete) {
    for(Proyecto__c p: [SELECT Id
                        FROM Proyecto__c
                        WHERE (Fecha_de_Inicio__c < LAST_N_DAYS:365 AND Estado__c <> 'Planeado') OR
                        (Fecha_de_Inicio__c >= LAST_N_DAYS:365)
                        Id IN :Trigger.old]){
        Trigger.oldMap.get(p.Id).addError('Solo se pueden eliminar proyectos que deberían haber iniciado hace más de un año y siguen en estado planeado.');
    }
}