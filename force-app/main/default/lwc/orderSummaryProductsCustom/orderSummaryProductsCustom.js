/**
 * @author      Cihan Fethi Hizar
 * @createdDate 01 September 2022
 * @description This is created for the JIRA stories: SD-351 & SD-352
 */

import { LightningElement, api } from 'lwc';
import getOrderDetails from '@salesforce/apex/ProductOrderController.getOrderDetails';
import getOrderItemSummariesWithTracking from '@salesforce/apex/ProductOrderController.getOrderItemSummariesWithTracking';

export default class OrderSummaryProductsCustom extends LightningElement {
    @api recordId;
    orderShippingAddress = '';
    orderType = '';
    output = new Array();
    outputHistory;
    isHistoryEmpty;
    
    connectedCallback() {
        getOrderDetails({orderSummaryId:this.recordId})
        .then(result => {
            this.orderShippingAddress = 'Ship To: '+result.ShippingAddress.street+' '+result.ShippingAddress.city+' '+result.ShippingAddress.postalCode+' '+result.ShippingAddress.country;
            if(result.Type == 'ZSOR') this.orderType = 'Name: STANDARD ORDER DELIVERY';
            else if(result.Type == 'ZSDP') this.orderType = 'Name: QUICK ORDER DELIVERY';

            getOrderItemSummariesWithTracking({orderSummaryId:this.recordId})
            .then(result2 => {
                //for(let i=0; i<result2.length; i++)
                    //result2[i].Product_Image_Link__c_SF = result2[i].orgDomain+((result2[i].Product_Image_Link__c_SF.split(" "))[1].replace('src="','').slice(0,-1));
                this.output = result2;
            })
            .catch(error2 => {
                console.error('Error2: '+error2.body.message);
            });
        })
        .catch(error => {
            console.error('Error: '+error.body.message);
        });
    }
}