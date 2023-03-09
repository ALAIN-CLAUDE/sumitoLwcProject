import { LightningElement, api, wire, track } from 'lwc';
import getQuote from '@salesforce/apex/QuoteController.getQuote';

export default class QuoteThankYou extends LightningElement {

    @api recordId;
    @track recordName;

    connectedCallback() {      
        console.log(this.recordId);
        getQuote({id:this.recordId})
        .then(result => {
            console.log(result);
            this.recordName = result;
        })
        .catch(error => {console.error(error);}); 
    }
}