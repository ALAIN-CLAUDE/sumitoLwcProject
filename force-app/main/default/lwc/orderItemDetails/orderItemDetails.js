/**
 * @author      Cihan Fethi Hizar
 * @createdDate 13 September 2022
 * @description This is created for the JIRA story: SD-417
 */

import { LightningElement, api } from 'lwc';
import getOrderItemDetails from '@salesforce/apex/ProductOrderController.getOrderItemDetails';

export default class OrderItemDetails extends LightningElement {
    @api orderitemid;
    deliveryNumbers = '';

    connectedCallback() {
        getOrderItemDetails({orderItemId:this.orderitemid})
        .then(result => {
            if(result.length > 0) {
                let temp = '';
                for(let i=0; i<result.length; i++) {
                    temp = temp + result[i] + ', ';
                }
                this.deliveryNumbers = temp.slice(0,-2);
            }
            else {
                this.deliveryNumbers = 'No delivery found.';
            }
        })
        .catch(error => {
            console.error('Error: '+error.body.message);
        });
    }
}