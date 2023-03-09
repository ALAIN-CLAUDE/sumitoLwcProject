/**
 * @author      Cihan Fethi Hizar
 * @createdDate 22 August 2022
 * @description This is created for the JIRA story: SD-347
 */

import { LightningElement, api } from 'lwc';
import getProductOrderDetails from '@salesforce/apex/ProductOrderController.getProductOrderDetails';
//import getProductDetails from '@salesforce/apex/ProductOrderController.getProductDetails';

export default class OrderHistoryByProduct extends LightningElement {
    @api recordId;
    isEmpty;
    productName;
    productImageLink;
    productDescription;
    orderData;

    connectedCallback() {
        getProductOrderDetails({productId: this.recordId})
        .then(result => {
            this.isEmpty = true;
            if(result.length > 0) { 
                let dateSet = new Set();
                let dateMap = new Map();
                for(let k=0; k<6; k++) {
                    if(result[k].length > 0) {
                        this.isEmpty = false;
                        // We prepare the data for printing out
                        for(let i=0; i<result[k].length; i++)
                            dateSet.add(result[k][i].Order.EffectiveDate.slice(0, -3));
                        for(let d of dateSet.values())
                            dateMap.set(d,0);
                        for(let i=0; i<result[k].length; i++)
                            dateMap.set(result[k][i].Order.EffectiveDate.slice(0, -3), dateMap.get(result[k][i].Order.EffectiveDate.slice(0, -3)) + result[k][i].Quantity);
                        dateSet = new Set();
                    }
                    else {
                        if(k == 0)
                            dateMap.set('Current Month',0);
                        else
                            dateMap.set(this.nMonthAgo(k),0);
                    }
                }
                
                this.orderData = this.map2ListQuanDate(dateMap);
                this.orderData[0].key = 'Current Month';
            }
            /*
            else {
                getProductDetails({productId: this.recordId})
                .then(result2 => {
                    this.productName = result2.Product2.Name;
                    this.productImageLink = (result2.Product2.Product_Image_Link__c.split(" "))[1].replace('src="','').slice(0,-1);
                    this.productDescription = result2.Product2.Description;
                })
                .catch(error2 => {
                    console.error('Error2: '+error2.body.message);
                });
            }
            */
        })
        .catch(error => {
            console.error('Error: '+error.body.message);
        });
    }

    map2ListQuanDate(dateMap) {
        let orderHistory = new Object();
        let orderHistoryArray = new Array();
        let keys = dateMap.keys();
        for(let k of keys) {
            orderHistory.key = k;
            orderHistory.value = dateMap.get(k);
            orderHistoryArray.push(orderHistory);
            orderHistory = new Object();
        }
        let month = ''; let year = '';
        for(let i=0; i<orderHistoryArray.length; i++)
            if(parseInt(orderHistoryArray[i].value) != 0) {
                year = (orderHistoryArray[i].key.split('-'))[0];
                month = (orderHistoryArray[i].key.split('-'))[1];
                switch(month) {
                    case '01': month = 'January'; break;
                    case '02': month = 'February'; break;
                    case '03': month = 'March'; break;
                    case '04': month = 'April'; break;
                    case '05': month = 'May'; break;
                    case '06': month = 'June'; break;
                    case '07': month = 'July'; break;
                    case '08': month = 'August'; break;
                    case '09': month = 'September'; break;
                    case '10': month = 'October'; break;
                    case '11': month = 'November'; break;
                    case '12': month = 'December'; break;
                }
                orderHistoryArray[i].key =  month+' '+year;
                month = ''; year = '';
            }
        return orderHistoryArray;
    }

    nMonthAgo(beforeMonthCount) {
        const monthNames = ["August", "September", "October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        const d = new Date();
        let currentMonthNumber = parseInt(d.getMonth()) + 5;
        let currentYearNumber = parseInt(d.getFullYear());
        if(currentMonthNumber < 10)
            currentYearNumber = currentYearNumber - 1;
        let monthName = monthNames[currentMonthNumber - beforeMonthCount];
        return monthName+' '+currentYearNumber.toString();
    }
}