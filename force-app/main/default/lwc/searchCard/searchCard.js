import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api } from 'lwc';
import stock_delivery from '@salesforce/resourceUrl/Stock_Delivery';
import stock_local from '@salesforce/resourceUrl/Stock_Local';
import stock_national from '@salesforce/resourceUrl/Stock_National';

/**
 * An organized display of a single product card.
 *
 * @fires SearchCard#calltoaction
 * @fires SearchCard#showdetail
 */
export default class SearchCard extends LightningElement {
    /**
     * An event fired when the user clicked on the action button. Here in this
     *  this is an add to cart button.
     *
     * Properties:
     *   - Bubbles: true
     *   - Composed: true
     *   - Cancelable: false
     *
     * @event SearchLayout#calltoaction
     * @type {CustomEvent}
     *
     * @property {String} detail.productId
     *   The unique identifier of the product.
     *
     * @export
     * 
     * 
     */

    /**
     * An event fired when the user indicates a desire to view the details of a product.
     *
     * Properties:
     *   - Bubbles: true
     *   - Composed: true
     *   - Cancelable: false
     *
     * @event SearchLayout#showdetail
     * @type {CustomEvent}
     *
     * @property {String} detail.productId
     *   The unique identifier of the product.
     *
     * @export
     */

    /**
     * A result set to be displayed in a layout.
     * @typedef {object} Product
     *
     * @property {string} id
     *  The id of the product
     *
     * @property {string} name
     *  Product name
     *
     * @property {Image} image
     *  Product Image Representation
     *
     * @property {object.<string, object>} fields
     *  Map containing field name as the key and it's field value inside an object.
     *
     * @property {Prices} prices
     *  Negotiated and listed price info
     */

    /**
     * A product image.
     * @typedef {object} Image
     *
     * @property {string} url
     *  The URL of an image.
     *
     * @property {string} title
     *  The title of the image.
     *
     * @property {string} alternativeText
     *  The alternative display text of the image.
     */

    /**
     * Prices associated to a product.
     *
     * @typedef {Object} Pricing
     *
     * @property {string} listingPrice
     *  Original price for a product.
     *
     * @property {string} netPrice
     *  Discounted price for the product.
     * 
     * @property {string} negotiatedPrice
     *  Final price for a product after all discounts and/or entitlements are applied
     *  Format is a raw string without currency symbol
     *
     * @property {string} currencyIsoCode
     *  The ISO 4217 currency code for the product card prices listed
     */

    /**
     * Card layout configuration.
     * @typedef {object} CardConfig
     *
     * @property {Boolean} showImage
     *  Whether or not to show the product image.
     *
     * @property {string} resultsLayout
     *  Products layout. This is the same property available in it's parent
     *  {@see LayoutConfig}
     *
     * @property {Boolean} actionDisabled
     *  Whether or not to disable the action button.
     */

    /**
     * Gets or sets the display data for card.
     *
     * @type {Product}
     */
    @api
    displayData;

    /**
     * Gets or sets the card layout configurations.
     *
     * @type {CardConfig}
     */
    @api
    config;

    /**
     * Gets the product image.
     *
     * @type {Image}
     * @readonly
     * @private
     */
    get image() {
        return this.displayData.image || {};
    }

    /**
     * Gets the product fields.
     *
     * @type {object.<string, object>[]}
     * @readonly
     * @private
     */
    get fields() {
        let allfields= (this.displayData.fields || []).map(({ name, value }, id) => ({


            id: id + 1,
            tabIndex: id === 0 ? 0 : -1,
            // making the first field bit larger
            class: id
                ? 'slds-truncate slds-text-heading_small'
                : 'slds-truncate slds-text-heading_medium',
            // making Name and Description shows up without label
            // Note that these fields are showing with apiName. When builder
            // can save custom JSON, there we can save the display name.
            // value:               name === 'Name' || name === 'Description' ? value : `${name}: ${value}`
            value:               name === 'Name' || name === 'Description' ? value : ''
                
                
        }));

        return allfields.slice(0,1);
    }

    calculateStocksAndProDescAndProListPrice(){
        return (this.displayData.fields || []).map(({ name, value }) => {
          if(name === 'Local_Stocks'){
              this.localStocks = value;
          }

          if (name === 'National_Stocks'){
              this.nationalStocks = value;
          }

          if (name === 'Stock_Delivery_Dates'){
              this.stockDeliveryDate = value;
              this.isStockAvailable = true;
          }

          if(name === 'StockKeepingUnit'){
              this.SKU = value;
          }

          if(name === 'Description'){
            this.productDescription = value;
          }
            
          if(name === 'List_Price__c'){
            this.listingPrice = value;
          }

          if(name === 'Net_Price'){
            this.netPrice = value;
          }

        });
    }


    /**
     * Whether or not the product image to be shown on card.
     *
     * @type {Boolean}
     * @readonly
     * @private
     */
    get showImage() {
        return !!(this.config || {}).showImage;
    }

    /**
     * Whether or not disable the action button.
     *
     * @type {Boolean}
     * @readonly
     * @private
     */
    get actionDisabled() {
        return !!(this.config || {}).actionDisabled;
    }

    /**
     * Gets the product price.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get price() {
        const prices = this.displayData.prices;
        let minPrice = prices.negotiatedPrice;

        /* THIS IS COMMENTED OUT ACCORDING TO THE CR DEFINED UNDER SD-556 TICKET
        if(minPrice && this.netPrice && Number(this.netPrice) != 0 && Number(minPrice) > Number(this.netPrice))
            minPrice = this.netPrice;
        if(minPrice && this.listingPrice && Number(this.listingPrice) != 0 && Number(minPrice) > Number(this.listingPrice))
            minPrice = this.listingPrice;
        */

        return minPrice;
    }

    /**
     * Whether or not the product has price.
     *
     * @type {Boolean}
     * @readonly
     * @private
     */
    get hasPrice() {
        return !!this.price;
    }

    /**
     * Gets the original price for a product, before any discounts or entitlements are applied.
     *
     * @type {string}
     */
    get listingPrice() {
        // return this.displayData.prices.listingPrice || "R0.00";
        return this.listingPrice || "R0.00";
    }

    /**
     * Gets the net price for a product, before any discounts or entitlements are applied.
     *
     * @type {string}
     */
     get netPrice() {
        return this.netPrice || "R0.00";
    }

    /**
     * Gets the final negotiated price for a product, before any discounts or entitlements are applied.
     *
     * @type {string}
     */
     get negotiatedPrice() {
        return this.displayData.prices.negotiatedPrice || "R0.00";
    }

    /**
     * Gets whether or not the listing price can be shown
     * @returns {Boolean}
     * @private
     */
    get canShowListingPrice() {
        const prices = this.displayData.prices;

        if(Number(this.netPrice) == 0 || this.netPrice == null)
            return (
                /*
                prices.negotiatedPrice &&
                prices.listingPrice &&
                // don't show listing price if it's less than or equal to the negotiated price.
                Number(prices.listingPrice) > Number(prices.negotiatedPrice)
                */
                prices.negotiatedPrice && this.listingPrice && Number(this.listingPrice) != 0 &&
                // don't show listing price if it's less than or equal to the negotiated price.
                Number(this.listingPrice) > Number(prices.negotiatedPrice)
            );
        else
            return (
                prices.negotiatedPrice && this.listingPrice && Number(this.listingPrice) != 0 &&
                Number(this.listingPrice) > Number(prices.negotiatedPrice) &&
                Number(this.listingPrice) > Number(this.netPrice)
            );
    }

    /**
     * Gets whether or not the net price can be shown
     * @returns {Boolean}
     * @private
     */
     get canShowNetPrice() {
        const prices = this.displayData.prices;
        
        return Number(this.netPrice) < Number(prices.negotiatedPrice) // according to the CR SD-556

        /* THIS IS COMMENTED OUT ACCORDING TO THE CR DEFINED UNDER SD-556 TICKET
        if(Number(this.listingPrice) == 0 || this.listingPrice == null)
            return (
                prices.negotiatedPrice && this.netPrice && Number(this.netPrice) != 0 &&
                // don't show net price if it's less than or equal to the negotiated price.
                Number(this.netPrice) > Number(prices.negotiatedPrice)
            );
        else
            return (
                prices.negotiatedPrice && this.netPrice && Number(this.netPrice) != 0 &&
                // don't show net price if it's less than or equal to the negotiated price.
                Number(this.netPrice) > Number(prices.negotiatedPrice) && Number(this.netPrice) < Number(this.listingPrice)
            );
        */
    }
   
    renderedCallback(){
        this.calculateStocksAndProDescAndProListPrice();
    }

    /**
     * Gets the currency for the price to be displayed.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get currency() {
        return this.displayData.prices.currencyIsoCode;
    }

    /**
     * Gets the container class which decide the innter element styles.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get cardContainerClass() {
        return this.config.resultsLayout === 'grid'
            ? 'slds-box card-layout-grid'
            : 'card-layout-list';
    }

    /**
     * Emits a notification that the user wants to add the item to their cart.
     *
     * @fires SearchCard#calltoaction
     * @private
     */
    notifyAction() {
        console.log('adding to cart', this.quantityValue);
            this.dispatchEvent(
                new CustomEvent('calltoaction', {
                    bubbles: true,
                    composed: true,
                    detail: {
                        productId: this.displayData.id,
                        productName: this.displayData.name,
                        quantity: this.quantityValue
                    }
                })
            );
            this.quantityValue = 0;
            this.addToCartChangeStatus();
    }

    /**
     * Emits a notification that the user indicates a desire to view the details of a product.
     *
     * @fires SearchCard#showdetail
     * @private
     */
    notifyShowDetail(evt) {
        evt.preventDefault();

        this.dispatchEvent(
            new CustomEvent('showdetail', {
                bubbles: true,
                composed: true,
                detail: { productId: this.displayData.id }
            })
        );
    }

    quantityValue = 0;

    handleDecrement() {
        if(this.quantityValue > 0){
            this.quantityValue = parseInt(this.quantityValue) - 1;
            this.addToCartChangeStatus();
        }
    }

    handleIncrement(){
        this.quantityValue = parseInt(this.quantityValue) + 1;
        this.addToCartChangeStatus();
    }

    handleIncrement2(){
        this.quantityValue = parseInt(this.quantityValue) + 2;
        this.addToCartChangeStatus();
    }

    handleIncrement4(){
        this.quantityValue = parseInt(this.quantityValue) + 4;
        this.addToCartChangeStatus();
    }

    addToCartChangeStatus(){
        //console.log('menim status');
        if (this.quantityValue > 0) {
            //console.log('je to vetsi nez 0');
            this.addToCartDisabled = false;
        }
        else {
            this.addToCartDisabled = true;
        }
        this.dispatchEvent(
            new CustomEvent('cartchanged', { })
        );
    }

    handleQuantityInput(event){
        //console.log('meni se quantita 2');
        this.quantityValue = event.target.value
        //console.log('je to 2', this.quantityValue);
        this.addToCartChangeStatus();
    }

    localStocks = 0;
    nationalStocks = 0;
    stockDeliveryDate;
    isStockAvailable = false;
    SKU;
    productDescription;
    listingPrice = 0.00;
    netPrice = 0.00;

    icon_local = stock_local;
    icon_national = stock_national;
    icon_stock_delivery = stock_delivery;
    
    activeSectionMessage = '';
    addToCartDisabled = true;

    handleAccordion(event){
        this.activeSectionMessage = 'Open section name:  ' + event.detail.openSections;
    }

    @api
    addToCartAllAction(){
        if (this.quantityValue > 0){
           this.notifyAction();
           //this.handleAction();
        }        
    }

    @api
    getQuantityValue() {
        return this.quantityValue;
    }
}