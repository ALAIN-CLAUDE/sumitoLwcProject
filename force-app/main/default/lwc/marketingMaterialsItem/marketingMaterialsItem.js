import { api, LightningElement } from 'lwc';
import video from './video.html';
import audio from './audio.html';
import mmi from './marketingMaterialsItem.html';

export default class MarketingMaterialsItem extends LightningElement {
    @api cover;
    @api item;
    page = '';
    
    render() {
        if(this.page == '') return mmi;
        else if(this.page == 'video') return video;
        else if(this.page == 'audio') return audio;
    }

    handleClick(event) {
        event.preventDefault();
        if(this.item.isFolder == true) {
            this.dispatchEvent(new CustomEvent('navigate', {detail: this.item}));
        }
        else if(this.item.fileType == 'PNG' 
                || this.item.fileType == 'JPG' 
                || this.item.fileType == 'JPEG' 
                || this.item.fileType == 'PDF' ) {
            window.open(this.item.href, '_blank');
        }
        else if(this.item.fileType == 'MP4') {
            this.page = 'video';
            this.render();
        }
        else if(this.item.fileType == 'MP3') {
            this.page = 'audio';
            this.render();
        }
    }
}