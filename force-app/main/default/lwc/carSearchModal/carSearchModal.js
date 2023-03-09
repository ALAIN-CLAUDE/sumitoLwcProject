import {
    LightningElement,
    track
}
from "lwc";
import getCarManufacturers from '@salesforce/apex/IBCarSearchModalCtrl.getManufacturers';
import getCarTypes from '@salesforce/apex/IBCarSearchModalCtrl.getTypes';
import getCarModelYears from '@salesforce/apex/IBCarSearchModalCtrl.getModelYears';
import getCarModels from '@salesforce/apex/IBCarSearchModalCtrl.getModels';
import getVehicleInfo from '@salesforce/apex/IBCarSearchModalCtrl.getVehicles';

import car_selector from '@salesforce/resourceUrl/Car_Selector_Icon';

export default class CarSearchModal extends LightningElement {

    icon_car = car_selector;
    
    selectedManufacturer;
    selectedType;
    selectedModelYear;
    selectedModel;
    isLoading;
    isSearchDisabled = true;
    @track isModalOpen = true;
    @track manufacturers;
    @track types;
    @track modelYears;
    @track models;

    openModal() {
        this.isModalOpen = true;
        this.isLoading = true;
        this.setCarManufacturers();
    }
    
    closeModal() {
        console.log('Close Modal');
        this.dispatchEvent(new CustomEvent('close'));
    }

    renderedCallback(){
        // this.setCarManufacturers();
    }

    connectedCallback(){
        this.setCarManufacturers();
    }

    setCarManufacturers() {
        getCarManufacturers()
        .then((response) => {
            console.log('response-', response);
            let manufacturers = [];
            if (response) {
                response.forEach(item => {
                    manufacturers.push({
                        label: item,
                        value: item,
                    });
                });
            }
            this.manufacturers = manufacturers;
            this.isLoading = false;
        })
        .catch((error) => {
            console.log(error);
            this.isLoading = false;
        });
    }

    setCarTypes() {
        getCarTypes({
            manufacturer: this.selectedManufacturer
        })
        .then((response) => {
            let types = [];
            if (response) {
                response.forEach(item => {
                    types.push({
                        label: item,
                        value: item,
                    });
                });
            }
            this.types = types;
            this.isLoading = false;
        })
        .catch((error) => {
            console.log(error);
            this.isLoading = false;
        });
    }

    setCarModelYears() {
        getCarModelYears({
            manufacturer: this.selectedManufacturer,
            type: this.selectedType
        })
        .then((response) => {
            let modelYears = [];
            if (response) {
                response.forEach(item => {
                    modelYears.push({
                        label: item,
                        value: item,
                    });
                });
            }
            this.modelYears = modelYears;
            this.isLoading = false;
        })
        .catch((error) => {
            console.log(error);
            this.isLoading = false;
        });
    }

    setCarModels() {
        getCarModels({
            manufacturer: this.selectedManufacturer,
            type: this.selectedType,
            modelYear: this.selectedModelYear
        })
        .then((response) => {
            let carModels = [];
            if (response) {
                response.forEach(item => {
                    carModels.push({
                        label: item,
                        value: item,
                    });
                });
            }
            this.models = carModels;
            this.isLoading = false;
        })
        .catch((error) => {
            console.log(error);
            this.isLoading = false;
        });
    }

    handleChange(event) {
        this.isLoading = true;
        let selectedPicklist = event.target.name;
        console.log('selectedPicklist-'+selectedPicklist);
        console.log('selectedPicklistValue-'+event.detail.value);
        if (selectedPicklist == 'Manufacturer') {
            this.selectedManufacturer = event.detail.value;
            this.setCarTypes();
        } else if(selectedPicklist == 'Type'){
            this.selectedType = event.detail.value;
            this.setCarModelYears();
        } else if(selectedPicklist == 'ModelYear'){
            this.selectedModelYear = event.detail.value;
            this.setCarModels();
        } else{
            this.selectedModel = event.detail.value;
            this.isSearchDisabled = false;
            this.isLoading = false;
        }
    }

    handleSearch(){
        console.log('selected car is: ', this.selectedModel);
        getVehicleInfo({
            manufacturer: this.selectedManufacturer,
            type: this.selectedType,
            modelYear: this.selectedModelYear,
            model: this.selectedModel
        })
        .then((response) => {
            console.log('vehicle info: ', response);

            if (response.length) {
                this.applyFilters(response[0]);
            }
        })
        .catch((error) => {
            console.log(error);
            this.isLoading = false;
        });
    }

    applyFilters(response){
        this.dispatchEvent(new CustomEvent('filters', {detail: response}));
        this.closeModal();
    }
}