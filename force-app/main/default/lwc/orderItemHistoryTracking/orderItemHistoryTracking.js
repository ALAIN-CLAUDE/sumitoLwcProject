/**
 * @author      Cihan Fethi Hizar
 * @createdDate 02 September 2022
 * @description This is created for the JIRA story: SD-351 & SD-352
 */

 import { LightningElement, api } from 'lwc';
 import getOrderItemHistory from '@salesforce/apex/ProductOrderController.getOrderItemHistory';
 
 export default class OrderItemHistoryTracking extends LightningElement {
     @api orderitemid;
     isEmpty;
     historyData = [];
 
     connectedCallback() {
         getOrderItemHistory({orderItemId:this.orderitemid})
         .then(result => {
             if(result.length > 0) {
                 this.isEmpty = false;
                 for(let i=0; i<result.length; i++) {
                    let doesExist = false;
                     //result[i].CreatedDate = this.formatDate(result[i].CreatedDate);
                     if(result[i].OldValue == '' || result[i].OldValue == null) result[i].OldValue = '-';
                     if(result[i].NewValue == '' || result[i].NewValue == null) result[i].NewValue = '-';
                     for(let j=0; j<this.historyData.length; j++) 
                        if(this.historyData[j].Id == result[i].Id)
                            doesExist = true;
                     if(!doesExist)
                        this.historyData.push(result[i]);
                     doesExist = false;
                 }
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