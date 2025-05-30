public with sharing class AccountController {
    @AuraEnabled(cacheable=true scope='global')
    public static Account[] getAllAccounts() {
        return [
            SELECT
                Id,
                Name,
                AccountNumber,
                Description,
                Maximo_de_proyectos_activos__c,
                Presupuesto_promedio__c
            FROM Account
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }

    public static Account[] searchAccount(String searchTerm){
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllAccounts();    //Si no hay nada que buscar, se devuelven todas las cuentas
        }

        searchTerm = '%'+searchTerm+'%';    //Preparar el termino de busqueda para la query

        return [
            SELECT
                Id,
                Name,
                AccountNumber,
                Description,
                Maximo_de_proyectos_activos__c,
                Presupuesto_promedio__c
            FROM Account
            WHERE Name LIKE :searchTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }
}