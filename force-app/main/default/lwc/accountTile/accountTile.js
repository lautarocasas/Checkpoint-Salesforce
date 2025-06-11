import { LightningElement,api,wire } from 'lwc';
import getTotalResourcesForAccount from '@salesforce/apex/ProjectController.getTotalResourcesForAccount';

export default class AccountTile extends LightningElement {
    @api account;
    @wire(getTotalResourcesForAccount, {accountId: '$account.Id'})
    accountsResources;

    get presupuesto() {
        return this.account?.Presupuesto_promedio__c ?? 0;
    }

    get totalResources() {
        return this.accountsResources?.data ?? 0;
    }

    handleClick() {
        const selectedEvent = new CustomEvent('accountselected', {
            detail: this.account.Id
        });
        this.dispatchEvent(selectedEvent);
    }
}