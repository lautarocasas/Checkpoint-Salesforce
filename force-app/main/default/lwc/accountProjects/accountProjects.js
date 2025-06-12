import { LightningElement, api, wire } from 'lwc';
import getProjectsByAccount from '@salesforce/apex/ProjectController.getProjectsByAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';

import NAME_FIELD from '@salesforce/schema/Proyecto__c.Name';
import PRESUPUESTO_FIELD from '@salesforce/schema/Proyecto__c.Presupuesto__c';
import ESTADO_FIELD from '@salesforce/schema/Proyecto__c.Estado__c';
import CONTACTO_FIELD from '@salesforce/schema/Proyecto__c.Contact__c';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'Nombre', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Contacto relacionado', fieldName: CONTACTO_FIELD.fieldApiName, type: 'text' },
    { label: 'Presupuesto', fieldName: PRESUPUESTO_FIELD.fieldApiName, type: 'currency' },
    { label: 'Estado', fieldName: ESTADO_FIELD.fieldApiName, type: 'text' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

export default class AccountProjects extends LightningElement {
    @api account;
    columns = columns;

    @wire(getProjectsByAccount, { accountId: '$account.Id' })
    projects;

    get projects() {
        return this.projects?.data;
    }

    get accountId(){
        return this.account?.Id;
    }

    get cardTitle() {
        return `Proyectos asociados a la cuenta ${this.account?.Name || ''}`;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'delete') {
            deleteRecord(row.Id).
            then(()=>{
                const toastEvent = new ShowToastEvent({
                title: "Registro borrado",
                message: "Record ID: " + event.detail.id,
                variant: "success"
                });
                this.dispatchEvent(toastEvent);
                refreshApex(this.projects);
            })
            .catch(error => {
                const toastEvent = new ShowToastEvent({
                    title: 'Error al eliminar',
                    message: error.body.message,
                    variant: 'error'
                });
                this.dispatchEvent(toastEvent);
            });
        }
    }

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
