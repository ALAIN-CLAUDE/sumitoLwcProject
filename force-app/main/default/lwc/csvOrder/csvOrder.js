import {LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {MessageContext, publish} from "lightning/messageService";
import lightning__commerce_cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";

import fillCartFromCSV from "@salesforce/apex/CsvOrderController.fillCartFromCSV";
import sendStorePricebook from "@salesforce/apex/CsvOrderController.sendStorePricebook";

import USER_ID from "@salesforce/user/Id";

import csvOrderStep1 from "@salesforce/label/c.csvOrderStep1";
import csvOrderStep2 from "@salesforce/label/c.csvOrderStep2";
import csvOrderStep3 from "@salesforce/label/c.csvOrderStep3";
import csvOrderStep4 from "@salesforce/label/c.csvOrderStep4";

export default class CsvOrder extends NavigationMixin(LightningElement) {

    @api effectiveAccountId;

    labels = {
        csvOrderStep1,
        //csvOrderStep2,
        csvOrderStep3,
        csvOrderStep4
    };

    result;
    cartId;

    showSpinner = false;
    successModal = false;
    errorModal = false;
    fileAvailable = false;
    CSVProcess = false;

    errorMessage = "";

    @api titleText;
    @api promptText;
    @api modalCloseLabel;
    @api successModalHeading;
    @api successModalUploadSuccessfulMessage;
    @api nonCSVModalUploadSuccessfulMessage;
    @api successModalCloseButtonText;
    @api successModalGoToCartButton;
    @api errorModalUploadFailedText;
    @api uploadButtonText;
    @api downloadButtonText;
    @api errorsInCSVException;
    @api errorModalResultsDownload;

    skuFieldName = 'ProductCode';

    @wire(MessageContext)
    messageContext;

    get acceptedFormats() {
        return [".csv"];
    }

    closeModal() {
        this.successModal = false;
        this.errorModal = false;
    }

    goToCart() {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.cartId,
                objectApiName: "WebCart",
                actionName: "view"
            }
        });
    }

    generateCSV(name, result) {
        let csvContent = "data:text/csv;charset=utf-8,";
        csvContent += result;
        const encodedUri = encodeURI(csvContent);
        const link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", name + ".csv");
        document.body.appendChild(link);

        link.click();
    }

    downloadTemplate() {
        this.generateCSV(this.templateCSVName, this.templateCSVContent);
        this.closeModal();
    }

    downloadErrorFile() {
        this.generateCSV("csvUpload" + Date.now(), this.result);
        this.closeModal();
    }

    handleDownloadPricebook() {
        this.showSpinner = true;

        console.log('account id: ', this.effectiveAccountId);
        console.log('user id: ', USER_ID);
        sendStorePricebook({
            accountId: this.effectiveAccountId,
            userId: USER_ID
        })
            .then((result) => {
                console.log(result);
            })
            .catch((error) => {
                console.error(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error",
                        message: "Something went wrong, please try again.",
                        variant: "Error"
                    })
                );
            })
            .finally(() => {
                this.showSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: "Please check your email for price book.",
                        variant: "success"
                    })
                );
            });
    }

    fillCart(csvContents, input) {
        this.showSpinner = true;
        this.closeModal();
        this.result = "";
        this.fileAvailable = false;
        let delimiter = ',';

        fillCartFromCSV({
            csvContents: csvContents,
            effectiveAccountId: this.effectiveAccountId,
            skuFieldName: this.skuFieldName,
            delimiter
        })
            .then((result) => {
                this.result = result.csv;
                this.cartId = result.cartId;
                this.fileAvailable = result.successes != undefined;

                if (result.errors > 0 || result.successes === 0)
                    throw new Error(this.errorsInCSVException);

                publish(this.messageContext, lightning__commerce_cartChanged);

                this.CSVProcess = true;
                this.successModal = true;
            })
            .catch((error) => {
                if (error) {
                    this.errorModal = true;
                    this.errorMessage = error.message
                        ? error.message
                        : error.body && error.body.message
                            ? error.body.message
                            : this.errorsInCSVException;
                } else {
                    console.error("CSV Error");
                }
            })
            .finally(() => {
                this.showSpinner = false;
                input ? (input.value = "") : null;
            });
    }

    processCSV() {
        const input = this.template.querySelector('[data-id="csv-file"]');
        const file = input.files[0];

        if (file === undefined) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error",
                    message: "Please upload a file",
                    variant: "error"
                })
            );
        } else {
            let reader = new FileReader();
            reader.readAsText(file);
            reader.onload = (event) => this.fillCart(event.target.result, input);
        }
    }

}