import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import resetUserPassword from '@salesforce/apex/B2bManageUserAccessModalCtrl.resetUserPassword';
import updateUserActiveStatus from '@salesforce/apex/B2bManageUserAccessModalCtrl.updateUserActiveStatus';

export default class B2bSelectUserProfileModal extends LightningElement {
    userId;
    userProfileId;
    isLoading = false;
    newUserProfileName;
    userActiveStatus = 'Not Active';
    @track isModalOpen = true;
    @api userName;
    @api isUserActive;
    @api userId;

    connectedCallback() {
        console.log('Hello Modal');
        console.log('Hello Modal1 ' + this.userActiveStatus);
        if(this.isUserActive){
            this.userActiveStatus = 'Active';
        }
        console.log('Hello Modal2 ' + this.userActiveStatus);
    }

    resetPassword(event){
        this.isLoading = true;

        resetUserPassword({
            userId: this.userId})
        .then((response) => {
            if (response) {
                this.isLoading = false;
                this.showToast('Success', 'Password reset successfully for ' + response + '.', 'success.');
            }
        })
        .catch((error) => {
            this.isLoading = false;
            this.showToast('An error has occured', error.body.message, 'error');
        });
    }
    
    activateUser() {
        console.log('Activate User');
        this.isLoading = true;
        updateUserActiveStatus({
            userId: this.userId,
            userActiveStatus: true
        })
        .then((response) => {
            if (response) {
                this.showToast('Success', 'User ' + response + ' has been activated successfully.', 'success');
                this.isUserActive = true;
                this.userActiveStatus = 'Active';
                
                setTimeout(function(){
                    window.location.reload();
                }, 3000);
            }
        })
        .catch((error) => {
            this.isLoading = false;
            this.showToast('An error has occured', error.body.message, 'error');
        });
    }
    
    deactivateUser() {
        console.log('Deactivate User');
        this.isLoading = true;
        updateUserActiveStatus({
            userId: this.userId,
            userActiveStatus: false
        })
        .then((response) => {
            if (response) {
                this.showToast('Success', 'User ' + response + ' has been deactivated successfully.', 'success');
                this.isUserActive = false;
                this.userActiveStatus = 'Not Active';
                
                setTimeout(function(){
                    window.location.reload();
                }, 3000);
            }
        })
        .catch((error) => {
            this.isLoading = false;
            this.showToast('An error has occured', error.body.message, 'error');
        });
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