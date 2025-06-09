trigger NewProjectForAccountTrigger on Proyecto__c (before update) {
    //Evitar que se pueda asociar un proyecto a una cuenta si se supera el límite máximo de proyectos activos definido en la cuenta, 
    //solo se deben de tener en cuenta los proyectos “En Proceso“.
    List<Proyecto__c> accountProjects = 
        [SELECT COUNT(Id)cantProyectos
         FROM Proyecto__c
         WHERE Estado__c = 'En Proceso'
         GROUP BY Account__c ];

    for(Proyecto__c p: Trigger.new){
        if(p.Account__c.Maximo_de_proyectos_activos__c <=  )
    }
}