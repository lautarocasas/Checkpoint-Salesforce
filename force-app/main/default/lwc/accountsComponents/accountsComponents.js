import { LightningElement,wire } from 'lwc';
import searchAccount from '@salesforce/apex/AccountController.searchAccount';

export default class AccountsComponents extends LightningElement {
    searchTerm = '';
    accounts;
    selectedAccountId;

    @wire(searchAccount, {searchTerm: '$searchTerm'})
    loadAccounts(result){
        this.accounts = result;
	}

    handleInputChange(event) {
        window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
    }

    handleAccountSelected(event) {
        this.selectedAccountId = event.detail;
    }
}
