@IsTest
public with sharing class TestFactory {
    /**
        * @description Metodo que crea una nueva cuenta con un numero de proyectos maximos
        * @param accName El nombre que va a tener la cuenta a crear
        * @param maxProjects La cantidad de proyectos que va a tener la cuenta
        * @return La nueva cuenta creada
    */
    public static Account createAccount(String accName, Integer maxProjects){
        Account acct = new Account();
        acct.name = accName;
        acct.Maximo_de_proyectos_activos__c = maxProjects;
        return acct;
    }

    /**
        * @description Metodo que genera proyectos para una cuenta existente
        * @param accountId El Id de la cuenta a la cual van a generarse proyectos
        * @param projectsQuantity La cantidad de proyectos que va a tener la cuenta
        * @param state El estado en el que van a generarse los nuevos proyectos
        * @return La lista de proyectos generados
    */
    public static Proyecto__c[] generateProjectsForAccount(Id accountId, Integer projectsQuantity, String state){
        List<Proyecto__c> projects = new List<Proyecto__c>();
        for(Integer i = 0; i < projectsQuantity; i++){
            Proyecto__c project = new Proyecto__c();
            project.Name = 'Proyecto '+i;
            project.Fecha_de_Inicio__c = Date.today().addDays(5);
            project.Presupuesto__c = 123456;
            project.Estado__c = state;
            project.Numero_de_Recursos__c = 10;
            project.Descripcion__c = 'Test project';
            project.Account__c = accountId;

            projects.add(project);
        }
        return projects;
    }

    /**
        * @description Metodo que genera un usuario con un perfil proporcionado
        * @param alias El alias con el que va a crearse el usuario
        * @param profile El perfil con el que va a generarse el usuario
        * @return El usuario generado
    */
    public static User createUserWithProfile(String alias, Profile profile){
        User u = new User(
            Alias = alias,
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');
        return u;
    }
}