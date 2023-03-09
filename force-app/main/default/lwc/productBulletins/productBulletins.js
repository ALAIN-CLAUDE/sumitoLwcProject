/**
 * @author          Bernie Oosthuizen
 * @createdDate     14 October 2022
 * @updatedDate     16 November 2022
 * @description     This is created for this JIRA story: SD-465
 *                  This is the JS controller for the "productBulletins" LWC.
 */

import { LightningElement } from 'lwc';
import getContents from '@salesforce/apex/ProductBulletinsController.getContents';
import getOrgUrl from '@salesforce/apex/ProductBulletinsController.getOrgUrl';

export default class ProductBulletins extends LightningElement {

    previewBulletins;
    baseUrl;

    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `.slds-carousel__content {
            display: none;
        }`;
        this.template.querySelector('lightning-carousel').appendChild(style);
    }

    connectedCallback() {
        getOrgUrl()
        .then((response) => {
            this.baseUrl = response;
        })
        .catch(error => {
            console.error(error);
        });


        getContents({contentWorkspaceName: 'Product Bulletins'})
        .then((response) => {
            this.previewBulletins = this.cleanData(response);
            console.log(response);
        })
        .catch(error => {
            console.error('Product Bulletins Error: ' + error);
        });
    }

    cleanData(dataObject) {
        var temp = [];

        if(!dataObject) {
            console.error(`The 'Preview Bulltins' cannot be found`)
        } else if(dataObject.length < 1) {
            console.error('No files found.')
        } else {
            for (var i = 0; i < dataObject.length; i++) {
                if(i > 4) {
                    break;
                }

                var a = {
                    id: dataObject[i].Id,
                    title: dataObject[i].Title,
                    url: this.baseUrl + `/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=` + dataObject[i].Id,
                }
                temp.push(a);
            }
            return temp;
        }
    }
}