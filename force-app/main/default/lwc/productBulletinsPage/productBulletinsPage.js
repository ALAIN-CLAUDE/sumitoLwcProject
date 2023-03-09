/**
 * @author          Bernie Oosthuizen
 * @createdDate     17 October 2022
 * @description     This is created for this JIRA story: SD-465
 *                  This is the JS controller for the "productBulletinsPage" LWC.
 */

 import { LightningElement, api } from 'lwc';
 import getContents from '@salesforce/apex/ProductBulletinsController.getContents';
 import getOrgUrl from '@salesforce/apex/ProductBulletinsController.getOrgUrl';
 
 export default class ProductBulletinsPage extends LightningElement {
 
     bulletins;
     baseUrl;
 
     connectedCallback() {
        getOrgUrl()
        .then((response) => {
            this.baseUrl = response;
            console.log(`URL: ` + response)
        })
        .catch(error => {
            console.error(error);
        });

        getContents()
        .then((response) => {
            this.bulletins = this.cleanData(response);
            console.log(response)
             
        })
        .catch(error => {
            console.error(error);
        });
     }
 
    cleanData(dataObject) {
        var temp = [];

        if(!dataObject) {
            console.error(`The 'Bulltins' folder with ID: 07H3L0000008WINUA2 cannot be found`)
        } else if(dataObject.length < 1) {
            console.error('No files found.')
        } else {
            for (var i = 0; i < dataObject.length; i++) {
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