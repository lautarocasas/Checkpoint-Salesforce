@IsTest
public with sharing class TestFactoryTests {
    @TestSetup
    static void makeData(){
        Account acct = new Account(Name = 'TestAccount', Maximo_de_proyectos_activos__c = 5);
        insert acct;
    }

    @IsTest
    static void createProjectsTest(){
        Test.startTest();
            Account acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
            System.debug(acct);
            List<Proyecto__c> projects = TestFactory.generateProjectsForAccount(acct.id,123.456,5,'En Progreso');
        Test.stopTest();
        Assert.isTrue(projects.size()==5, 'Expected 5 projects');
    }
}