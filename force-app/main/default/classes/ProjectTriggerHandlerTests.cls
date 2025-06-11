@IsTest
public with sharing class ProjectTriggerHandlerTests {
    @TestSetup
    static void makeData(){
        Account acct = new Account(Name = 'TestAccount', Maximo_de_proyectos_activos__c = 5);

        List<Profile> p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        User u = TestFactory.createUserWithProfile('standt', p[0]);
        insert u;
        insert acct;
    }

    @IsTest
    static void testAverageBudget(){

        List<User> u = [SELECT alias FROM User WHERE Alias = 'standt' LIMIT 1];
        System.runAs(u[0]) {
        // The following code runs as user 'u'
        List<Account> acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
        List<Proyecto__c> projects = TestFactory.generateProjectsForAccount(acct[0].id,5,'En Progreso');
        Test.startTest();
            insert projects;
        Test.stopTest();
        acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
        Assert.areEqual(123456,acct[0].Presupuesto_promedio__c,'El promedio:'+ acct[0].Presupuesto_promedio__c+' no coincide con el esperado.');
       }
    }

    @IsTest
    static void testDeletedProjectsHandler(){
        List<User> u = [SELECT alias FROM User WHERE Alias = 'standt' LIMIT 1];
        System.runAs(u[0]) {
        List<Account> acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
        List<Proyecto__c> projects = TestFactory.generateProjectsForAccount(acct[0].id,5,'Planeado');
        insert projects;
        try {
                Test.startTest();
                delete projects;
                Test.stopTest();
                Assert.fail('Los proyectos a eliminar deberian haber producido errores');
            } catch (Exception e) {
                Assert.isTrue(
                    e.getMessage().equalsIgnoreCase('Delete failed. First exception on row 0 with id '+projects[0].id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Solo se pueden eliminar proyectos que deberían haber iniciado hace más de un año y siguen en estado planeado.: []'),
                    'Los mensajes de error no coinciden. ' + e.getMessage()
                    );
            }
        }
    }

    @IsTest
    static void testMaxProjects(){
        List<User> u = [SELECT alias FROM User WHERE Alias = 'standt' LIMIT 1];
        System.runAs(u[0]) {
            List<Account> acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
            List<Proyecto__c> projects = TestFactory.generateProjectsForAccount(acct[0].id,10,'En Progreso');
            try {
                Test.startTest();
                insert projects;
                Test.stopTest();
                Assert.fail('Los proyectos a eliminar deberian haber producido errores');
            } catch (Exception e) {
                Assert.isTrue(
                    e.getMessage().equalsIgnoreCase('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, La cuenta a la que se intenta asociar este proyecto supera la cantidad maxima de proyectos "En Progreso" que puede tener.: []'),
                    'Los mensajes de error no coinciden. ' + e.getMessage()
                    );
            }
        }
    }
}