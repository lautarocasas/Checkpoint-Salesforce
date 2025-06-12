/**
    * @description Controlador dedicado a gestionar los datos del objeto Account
*/
public with sharing class AccountController {
    /**
     * @description Se obtienen los datos asociados a proyectos de todas las cuentas
     * @return La lista de cuentas obtenida
    */
    @AuraEnabled(cacheable=true scope='global')
    public static Account[] getAllAccounts() {
        return [
            SELECT
                Id,
                Name,
                Maximo_de_proyectos_activos__c,
                Presupuesto_promedio__c,
                Total_Presupuestos__c
            FROM Account
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    /**
     * @description Se obtienen los datos asociados a proyectos de una cuenta
     * @param searchTerm el termino de busqueda para encontrar una cuenta
     * * @return La lista de cuentas obtenida
    */
    @AuraEnabled(cacheable=true scope='global')
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
                Maximo_de_proyectos_activos__c,
                Presupuesto_promedio__c,
                Total_Presupuestos__c
            FROM Account
            WHERE Name LIKE :searchTerm
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }
}