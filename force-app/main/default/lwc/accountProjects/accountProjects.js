import { LightningElement, api, wire } from 'lwc';
import getProjectsByAccount from '@salesforce/apex/ProjectController.getProjectsByAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import NAME_FIELD from '@salesforce/schema/Proyecto__c.Name';
import PRESUPUESTO_FIELD from '@salesforce/schema/Proyecto__c.Presupuesto__c';
import ESTADO_FIELD from '@salesforce/schema/Proyecto__c.Estado__c';
import CONTACTO_FIELD from '@salesforce/schema/Proyecto__c.Contact__c';

export default class AccountProjects extends LightningElement {
    @api accountId;

    @wire(getProjectsByAccount, { accountId: '$accountId' })
    projects;

    get projects() {
        return this.projects?.data;
    }

    columns = [
        { label: 'Nombre', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
        { label: 'Contacto relacionado', fieldName: CONTACTO_FIELD.fieldApiName, type: 'text' },
        { label: 'Presupuesto', fieldName: PRESUPUESTO_FIELD.fieldApiName, type: 'currency' },
        { label: 'Estado', fieldName: ESTADO_FIELD.fieldApiName, type: 'text' }
    ];

    // Campos para el formulario
    fields = [NAME_FIELD, CONTACTO_FIELD, PRESUPUESTO_FIELD, ESTADO_FIELD];

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Proyecto creado",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        refreshApex(this.projects);
    }

    handleError(event) {
        console.error('Error al crear proyecto:', event.detail);
    }
}
