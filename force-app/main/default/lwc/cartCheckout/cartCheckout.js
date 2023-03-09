import {LightningElement, api, wire, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

import getCartData from '@salesforce/apex/CartCheckoutController.getCartData';
import setFlowType from '@salesforce/apex/CartCheckoutController.setFlowType';

import Cart_Quick_Error_Description from "@salesforce/label/c.Cart_Quick_Error_Description";
import Cart_New_Error_Description from "@salesforce/label/c.Cart_New_Error_Description";
import Cart_Quick_Error_Title from "@salesforce/label/c.Cart_Quick_Error_Title";
import Cart_New_Error_Title from "@salesforce/label/c.Cart_New_Error_Title";
import Cart_Button_QuickOrder from "@salesforce/label/c.Cart_Button_QuickOrder";
import Cart_Button_NewOrder from "@salesforce/label/c.Cart_Button_NewOrder";
import Cart_Button_Quote from "@salesforce/label/c.Cart_Button_Quote";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import lightning__commerce_cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";

const FLOW_TYPE_QUICK_ORDER = 'Quick_Order';
const FLOW_TYPE_NEW_ORDER = 'New_Order';
const FLOW_TYPE_QUOTE = 'Quote';

export default class CartCheckout extends NavigationMixin(LightningElement) {

    @api recordId;
    @api effectiveAccountId;

    isLoading = true;

    subscription;

    @wire(MessageContext)
    messageContext;

    @track errorsQuick = [];
    @track errorsNew = [];
    @track errorsReqQuote = [];
    @track errorsLockout = [];

    quickOrderDisabled = true;
    newOrderDisabled = true;
    reqQuoteDisabled = true;
    reqQuoteButtonClass;

    labels = {
        Cart_New_Error_Title,
        Cart_Quick_Error_Title,
        Cart_Quick_Error_Description,
        Cart_New_Error_Description,
        Cart_Button_QuickOrder,
        Cart_Button_NewOrder,
        Cart_Button_Quote,
    }

    get hasQuickErrors() {
        return this.errorsQuick.length;
    }

    get hasNewErrors() {
        return this.errorsNew.length;
    }

    get hasReqQuoteErrors() {
        return this.errorsReqQuote.length;
    }

    get hasLockout(){
        return this.errorsLockout.length;
    }

    showErrorMessage(){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Order block',
                message:
                    'You are not allowed to order. Please contact us',
                variant: 'error',
                mode: 'dismissable'
            })
        );
    }

    connectedCallback() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                lightning__commerce_cartChanged,
                () => this.updateCartItems(),
                {scope: APPLICATION_SCOPE}
            );
        }

        this.getCartData();
    }

    getCartData() {
        this.isLoading = true;
        let lastErrorsQuick = this.errorsQuick;

        getCartData({
            cartId: this.recordId,
            effectiveAccountId: this.effectiveAccountId
        }).then(result => {
            this.errorsQuick = result.errorsQuick;
            this.errorsNew = result.errorsNew;
            this.errorsReqQuote = result.errorsReqQuote;
            this.errorsLockout = result.errorsLockout;

            if(lastErrorsQuick === 0 && result.errorsQuick > 0){
                this.showErrorMessage();
            }

            this.quickOrderDisabled = !!this.errorsQuick.length 
            this.newOrderDisabled = !!this.errorsNew.length
            this.reqQuoteDisabled = !!this.errorsReqQuote.length
            // this.quickOrderDisabled = !!this.errorsLockout.length
            // this.newOrderDisabled = !!this.errorsLockout.length

            if(this.reqQuoteDisabled == true){
                this.reqQuoteButtonClass = 'button-brand';
            } else {
                this. reqQuoteButtonClass = 'button-outline';
            }

            this.isLoading = false;
        })
    }

    setUserFlowType(type) {
        this.isLoading = true;

        setFlowType({
            type: type
        }).then(() => {
            this.isLoading = false;
            this.goToCheckout();
        });
    }

    updateCartItems() {
        this.getCartData();
    }

    navigateToQuickOrder() {
        this.setUserFlowType(FLOW_TYPE_QUICK_ORDER);
    }

    navigateToNewOrder() {
        this.setUserFlowType(FLOW_TYPE_NEW_ORDER);
    }

    navigateToQuote() {
        this.setUserFlowType(FLOW_TYPE_QUOTE);
    }

    /**
     * js native lightning navigation didn't work, audiences was not loaded properly.
     * we need to go with real redirect here
     */
    goToCheckout() {
        window.location.href = window.location.href.replace('cart', 'checkout');
    }

}