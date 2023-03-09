/**
 * @author      Cihan Fethi Hizar
 * @createdDate 26 August 2022
 * @description This is created for the JIRA story: SD-350
 */

import { LightningElement, api } from 'lwc';
import getOrderHistory from '@salesforce/apex/ProductOrderController.getOrderHistory';

export default class OrderHistoryTracking extends LightningElement {
    @api recordId;
    isEmpty;
    historyData;

    connectedCallback() {
        getOrderHistory({orderSummaryId:this.recordId})
        .then(result => {
            if(result.length > 0) {
                this.isEmpty = false;
                for(let i=0; i<result.length; i++) {
                    if(result[i].OldValue == '') result[i].OldValue = '-';
                    if(result[i].NewValue == '') result[i].NewValue = '-';
                }
                this.historyData = result;
            }
            else {
                this.isEmpty = true;
                console.log("No record found!");
            }
        })
        .catch(error => {
            console.error('Error: '+error.body.message);
        });
    }
    /*
    formatDate(dateString) {
        let temp = dateString.split('T');
        let timeArray = temp[1].split('.');
        let dateArray = temp[0].split('-');
        return dateArray[2]+'/'+dateArray[1]+'/'+dateArray[0]+' '+timeArray[0];
    }
    */
}