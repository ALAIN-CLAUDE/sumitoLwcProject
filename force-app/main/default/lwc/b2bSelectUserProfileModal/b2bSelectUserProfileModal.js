import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserProfiles from '@salesforce/apex/B2BSelectUserProfileModal.getUserProfiles';
import updateUserProfile from '@salesforce/apex/B2BSelectUserProfileModal.updateUserProfile';

export default class B2bSelectUserProfileModal extends LightningElement {
    userId;
    userProfileId;
    isLoading = false;
    newUserProfileName;
    @track isModalOpen = true;
    @track userProfiles;
    @api userProfileName;
    @api userId;

    connectedCallback() {
        this.isLoading = true;

        getUserProfiles({
            currentUserProfileName: String(this.userProfileName).split('-')[1].replace(' ', '')
        })
        .then((response) => {
            if (response) {
                let userProfiles = [];
                if (response) {
                    response.forEach(item => {
                        userProfiles.push({
                            label: item,
                            value: item,
                        });
                    });
                }
                this.userProfiles = userProfiles;
            }
        })
        .catch((error) => {
            this.showToast('An error has occured', error.body.message, 'error');
        });
        this.isLoading = false;
    }
    
    handlePicklistChange(event) {
        let selectedPicklist = event.target.name;
        this.newUserProfileName = event.detail.value;
    }

    handleSaveChanges(event){
        this.isLoading = true;
        if(this.newUserProfileName == null || this.newUserProfileName == ''){
            this.showToast('An error has occured', 'Please choose a profile from the list of profiles provided.', 'error');
            this.isLoading = false;
        } else {
            updateUserProfile({
                userId: this.userId,
                userProfileName: this.newUserProfileName})
            .then((response) => {
                if (response) {
                    this.showToast('Success', response, 'success');
                }
                
                setTimeout(function(){
                    window.location.reload();
                }, 3000);
            })
            .catch((error) => {
                this.showToast('An error has occured', error.body.message, 'error');
                this.isLoading = false;
            });
        }
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    showToast(varTitle, varMessage, varVariant) {
        const event = new ShowToastEvent({
            title: varTitle,
            message: varMessage,
            variant: varVariant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}