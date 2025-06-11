@IsTest
public with sharing class TestFactoryTests {
    @TestSetup
    static void makeData(){
        Account acct = new Account(Name = 'TestAccount', Maximo_de_proyectos_activos__c = 5);

        List<Profile> p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        User u = TestFactory.createUserWithProfile('standt', p[0]);
        insert u;
        insert acct;
    }

    @IsTest
    static void createProjectsTest(){
        Account acct = [SELECT Id,Presupuesto_promedio__c FROM Account WHERE Name = 'TestAccount' LIMIT 1];
        List<User> u = [SELECT alias FROM User WHERE Alias = 'standt' LIMIT 1];
        System.runAs(u[0]) {
        Test.startTest();
            List<Proyecto__c> projects = TestFactory.generateProjectsForAccount(acct.id,5,'En Progreso');
        Test.stopTest();
        Assert.isTrue(projects.size()==5, 'Expected 5 projects');
        }
    }
}