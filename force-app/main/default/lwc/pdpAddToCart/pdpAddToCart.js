import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import stock_delivery from '@salesforce/resourceUrl/Stock_Delivery';
import stock_local from '@salesforce/resourceUrl/Stock_Local';
import stock_national from '@salesforce/resourceUrl/Stock_National';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';
import communityId from '@salesforce/community/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getStockAvailability from '@salesforce/apex/B2BSearchControllerSample.getStockAvailabilityPDP';

export default class PdpAddToCart extends NavigationMixin(LightningElement) {



    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;


    }

    _recordId;
    localStocks = 0;
    nationalStocks = 0;
    stockDeliveryDate;
    isStockAvailable = false;
    //quantity;
    SKU;
    @track actionDisabled = true;

    
    _effectiveAccountId;
    quantityValue=10;

    icon_local = stock_local;
    icon_national = stock_national;
    icon_stock_delivery = stock_delivery;

        /**
     * Gets the effective account - if any - of the user viewing the product.
     *
     * @type {string}
     */
         @api
         get effectiveAccountId() {
             console.log('acc: ', this._effectiveAccountId);
             return this._effectiveAccountId;
         }
     
         /**
          * Sets the effective account - if any - of the user viewing the product
          * and fetches updated cart information
          */
         set effectiveAccountId(newId) {
             this._effectiveAccountId = newId;
             this.calculateStocks();
         }

    handleDecrement() {
        this.quantityValue = parseInt(this.quantityValue) - 1;
        this.actionDisabled = (this.quantityValue == 0 ? true : false);
    }

    handleIncrement(){
        this.quantityValue = parseInt(this.quantityValue) + 1;
        this.actionDisabled = (this.quantityValue == 0 ? true : false);
    }

    handleIncrement2(){
        this.quantityValue = parseInt(this.quantityValue) + 2;
        this.actionDisabled = (this.quantityValue == 0 ? true : false);
    }

    handleIncrement4(){
        this.quantityValue = parseInt(this.quantityValue) + 4;
        this.actionDisabled = (this.quantityValue == 0 ? true : false);
    }

    handleChangeQuantityValue(event){
        this.quantityValue = event.target.value
        this.actionDisabled = (this.quantityValue == 0 ? true : false);
    }



    calculateStocks(){

        getStockAvailability({
            wrapper: {
                'id': this.recordId,
                'fields': {}
            },
            effectiveAccountId: this.effectiveAccountId
        }).then((response) => {
            console.log('r', response);
            this.localStocks = (response[0].fields.Local_Stock == null ? 0 : response[0].fields.Local_Stock);
            this.nationalStocks = (response[0].fields.National_Stock == null ? 0 : response[0].fields.National_Stock);
            this.stockDeliveryDate = response[0].fields.Stock_Delivery_Date;

            if(response[0].fields.Stock_Delivery_Date){
                this.isStockAvailable = true;
            }
        })
    }

    renderedCallback(){

        
    }

    handleAction() {

        addToCart({
            communityId: communityId,
            productId: this.recordId,
            quantity: this.quantityValue,
            effectiveAccountId: this.effectiveAccountId
        })
            .then(() => {
                this.dispatchEvent(
                    new CustomEvent('cartchanged', {
                        bubbles: true,
                        composed: true
                    })
                    
                );
                //his.quantityValue = quantity;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Your cart has been updated.',
                        variant: 'success',
                        mode: 'dismissable'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:
                            '{0} could not be added to your cart at this time. Please try again later.',
                        variant: 'error',
                        // mode: 'dismissable'
                        mode: 'sticky'
                    })
                );
                console.log(error);
            });
    }
}