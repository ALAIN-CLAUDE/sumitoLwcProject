import { LightningElement, wire } from 'lwc';
import getMarketingMaterial from '@salesforce/apex/getMarketingMaterial.getMarketingMaterial';

export default class MarketingMaterial extends LightningElement {
    dunlopDirectId = "07H3L0000008W5xUAE";
    independentId = "07H3L0000008W5iUAE";

    @wire (getMarketingMaterial) wiredMarketingMaterial({data,error}){
        if (data) {
            console.log(...data)
        } else if (error) {
            console.log(error);
        }
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
    }
}