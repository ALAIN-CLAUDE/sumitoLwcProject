import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import userAccepted from '@salesforce/apex/termsConditionsController.userAccepted';
import getUserStatus from '@salesforce/apex/termsConditionsController.getUserStatus';
import getUserGroup from '@salesforce/apex/termsConditionsController.getUserGroup';
import modalTemplateInternational from './termsConditionsModalInternational.html';
import modalTemplateDomestic from './termsConditionsModalDomestic.html';

export default class TermsConditionsModal extends NavigationMixin(LightningElement) {
	
	userAccepted = false;
	domesticUser;

	//Get user group before render.
	//User group determines which T&Cs to display.
	connectedCallback() {
		console.log('Connected callback');
		getUserGroup().then((response)=> {
			console.log('User Group: ' + response)
			//Assign user group to enable correct rendering.
			if(response == 'DM') {
				this.domesticUser = true;
			} else {
				this.domesticUser = false;
			}
		})
	}


	//Check if user has previously accepted the T&Cs
	renderedCallback() {
		console.log('Rendered callback');
		getUserStatus().then((response)=> {
			console.log('User status: ', response);
			if(response){
				this.userAccepted = true;
			}
			else {
				this.openModal();
			}					
		})		       
	}

	//Render according to user group.
	render() {
        return this.domesticUser ? modalTemplateDomestic : modalTemplateInternational;
    }


	handleAccept(){
		//accept TaC
		userAccepted()
		.then(console.log('user info updated'))
		.catch ((error) =>{
			console.log(error);
		});
		this.closeModal();
	}

	handleDecline(){
		//decline TaC
		this.handlelogout();
		this.closeModal();
	}
	

	closeModal() {
		this.template.querySelector('.tac-modal').classList.remove('slds-fade-in-open');
		this.template.querySelector('.slds-backdrop').classList.remove('slds-backdrop_open');
		setTimeout(() => { this.showCookieConsentBanner = false }, 100);
	}

	openModal() {
		this.template.querySelector('.tac-modal').classList.add('slds-fade-in-open');
		this.template.querySelector('.slds-backdrop').classList.add('slds-backdrop_open');
	}

	handlelogout(){
		this[NavigationMixin.Navigate]({
		  type: 'comm__loginPage',
		  attributes: {
			actionName: 'logout'
		  },
		}); 
	  }
}