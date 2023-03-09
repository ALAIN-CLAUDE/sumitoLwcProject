import { LightningElement,wire,api } from 'lwc';
import UpdateQuoteStatus from '@salesforce/apex/UpdateB2BQuoteController.UpdateQuoteStatus';
export default class UpdateB2BQuote extends LightningElement {
    @api recordId;
    isLoading = false;
    @wire(UpdateQuoteStatus,{quoteId:'$recordId'})
    UpdatedQuote;
    connectedCallback(){
        console.log(this.recordId);
    }
}