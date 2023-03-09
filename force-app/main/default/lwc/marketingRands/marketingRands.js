import { LightningElement, api } from 'lwc';
import getAccountDetails from '@salesforce/apex/MarketingRandsController.getAccountDetails';
import sr_image_exp from '@salesforce/resourceUrl/MR_Exp';
import sr_image_rands from '@salesforce/resourceUrl/MR_Rands';

export default class MarketingRands extends LightningElement {

    MR_Rands;
    MR_Exp;
    exp_img = sr_image_exp;
    rands_img = sr_image_rands;

    renderedCallback(){
        getAccountDetails().then((result) => {
            if(result.Marketing_Rands_Balance__c){
            this.MR_Rands =  result.Marketing_Rands_Balance__c;
        }else {this.MR_Rands = false}
        if(result.Marketing_Rands_Expiring__c){    
            this.MR_Exp = result.Marketing_Rands_Expiring__c
        }else {this.MR_Exp = false}
        })
        .catch((error) => {
            console.log(error);
        });
    }
}