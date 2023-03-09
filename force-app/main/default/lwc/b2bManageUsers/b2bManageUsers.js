import { LightningElement } from 'lwc';	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRelatedUsers from '@salesforce/apex/B2BManageUsersCtrl.getRelatedUsers';

export default class B2bManageUsers extends LightningElement {
    usersExist = false;
    errorOccured = false;
    message = '';
    users;
    showSelectProfileModal = false;
    showUserAccessModal = false;
    userProfileName;
    userName;
    isCurrentUserActive;
    currentUserProfileId;
    isLoading = false;

    connectedCallback() {
        this.isLoading = true;
        getRelatedUsers({})
        .then((response) => {
            if (response) {
                let users = JSON.parse(JSON.stringify(response));
                let updateName = '';
                let resetName = '';
                let profileName = '';
console.log(JSON.stringify(response));
                for(let i=0; i<users.length; i++){
                    console.log('Kgops' + i + ': ' + users[i].IsActive);
                    updateName = 'update' + i;
                    resetName = 'reset' + i;
                    profileName = String(users[i].Profile.Name).replace('B2B Customer Community Plus Login - ', '');
                    profileName = String(profileName).replace('B2B Customer Community Plus - ', '');
                    profileName = String(profileName).replace('B2B Customer Community Plus', '');
                    users[i].updateName = updateName;
                    users[i].resetName = resetName;
                    users[i].profileName = profileName;
                }
                this.users = users;
                this.usersExist = true;
                this.isLoading = false;
            }
        })
        .catch((error) => {
            this.showToast('An error has occured', error.body.message, 'error');
        });
    }

    manageUserAccess(event){
        var buttonName = event.target.dataset.name;
        var userIndex = buttonName.replace('reset', '');
        console.log('Kgops manageUserAccess ' + this.users[userIndex].Name + ' - ' + this.users[userIndex].IsActive);
        this.isCurrentUserActive = this.users[userIndex].IsActive;
        this.userId = this.users[userIndex].Id;
        this.userName = this.users[userIndex].Name;
        this.showUserAccessModal = true;
    }

    changeProfile(event){
        var buttonName = event.target.dataset.name;
        var userIndex = buttonName.replace('update', '');
        this.userProfileName = this.users[userIndex].Profile.Name;
        console.log('Kgops2 ChangeProfile: ' + buttonName);
        console.log('Kgops2 ChangeProfile: ' + userIndex);
        console.log('Kgops1 ChangeProfile: ' + this.users[userIndex].Profile.Name);
        console.log('Kgops2 ChangeProfile: ' + this.userProfilename);
        this.userId = this.users[userIndex].Id;
        this.currentUserProfileId = this.users[userIndex].ProfileId;
        this.showSelectProfileModal = true;
    }

    handleClose() {
        this.showSelectProfileModal = false;
        this.showUserAccessModal = false;
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