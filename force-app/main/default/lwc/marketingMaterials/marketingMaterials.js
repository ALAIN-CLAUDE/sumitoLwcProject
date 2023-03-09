/**
 * @author      Cihan Fethi Hizar
 * @createdDate 22 September 2022
 * @description This is created for the JIRA story: SD-393
 */

import { LightningElement, api } from 'lwc';
import getFoldersAndFiles from '@salesforce/apex/MarketingMaterialsController.getFoldersAndFiles';
import getWorkSpaceId from '@salesforce/apex/MarketingMaterialsController.getWorkSpaceId';

export default class MarketingMaterials extends LightningElement {
    @api workspaceTitle;
    rowItems = [];
    itemTree;
    itemTemplate = {
        id: '0',
        parentContentFolderId: '0',
        label: '',
        isFolder: false,
        fileType: '',
        fileExtension: '',
        disabled: false,
        expanded: false,
        children: [],
        href: '',
        cover: ''
    };
    rootParentId;
    parentId;
    showBackButton = false;
    isEmpty = false;

    connectedCallback() {
        getWorkSpaceId({workspaceTitle:this.workspaceTitle})
        .then(wsId => {
            this.rootParentId = this.parentId = wsId;
            getFoldersAndFiles({workspaceId: wsId})
            .then(result => {
                if(result.length > 0) {
                    this.itemTree = this.buildTree(result,0,0);
                    this.createLayout(this.itemTree);
                }
                else 
                    this.isEmpty = true;                
            })
            .catch(error2 => {
                console.error('Error2: '+error2.body.message);
            });
        })
        .catch(error => {
            console.log('xyz');
            console.error('Error: '+error.body.message);
        });
    }

    handleNavigate(event) {
        this.parentId = event.detail.id;
        this.createLayout(JSON.parse(JSON.stringify(event.detail.children)));
    }

    toParentPage(event) {
        event.preventDefault();
        let item = this.getItem(this.itemTree, event.target.dataset.parentid);
        if(item.parentContentFolderId != this.rootParentId) {
            let parentItem = this.getItem(this.itemTree, item.parentContentFolderId);
            this.parentId = parentItem.id;
            this.createLayout(parentItem.children);
        }
        else {
            this.parentId = this.rootParentId;
            this.createLayout(this.itemTree);
        }
    }

    buildTree(result,i,k) {
        let tempObj = {};                
        let itemsArr = new Array();
        for(let j=0; j<result[i].length; j++) 
            if(i==0 || (i!=0 && result[i][j].ParentContentFolderId == result[i-1][k].Id))
            {
                tempObj.id = result[i][j].Id;
                tempObj.parentContentFolderId = result[i][j].ParentContentFolderId;
                tempObj.label = result[i][j].Title;
                tempObj.isFolder = result[i][j].IsFolder;
                tempObj.fileType = result[i][j].FileType;
                tempObj.fileExtension = result[i][j].FileExtension;
                tempObj.disabled = false;
                tempObj.expanded = true;
                if(i+1<result.length) tempObj.children = this.buildTree(result,i+1,j);
                else tempObj.children = new Array(); 
                if(result[i][j].IsFolder == true) tempObj.href = '';
                else tempObj.href = '/sumitomorubbersouthafrica/sfc/servlet.shepherd/document/download/' + result[i][j].Id;
                tempObj.cover = '';
                itemsArr.push(tempObj);
                tempObj = {};
            }
        return itemsArr;
    }

    createLayout(items) {
        this.rowItems = [];
        let result = []; let index = 0; let arr = [];
        for(let i=0; i<parseInt(items.length/2)+1; i++) { //number of rows
            for(let j=0; j<2; j++) {// 2 items per row
                if(index < items.length 
                    && items[index].label != 'default-document'
                    && items[index].label != 'default-folder'
                    && items[index].label != 'default-video'
                    && items[index].label != 'default-audio'
                    && !items[index].label.includes('cover')
                ) {
                    items[index].cover = this.getCover(items[index]);
                    arr.push(items[index]);
                }
                if(arr.length == 2) {
                    result.push(arr);
                    arr = [];
                }
                index++;
            }
        }
        if(arr.length == 1) result.push(arr);
        this.rowItems = result;
        if(items.length > 0)
            this.showBackButton = (this.rootParentId != this.parentId ? true : false);
    }

    getItem(items, id) {
        let item = {};
        for(let i=0; i<items.length; i++)
            if(items[i].id == id)
                return items[i];
        let temp = {};
        for(let i=0; i<items.length; i++)
            if(items[i].children.length > 0) {
                temp = this.getItem(items[i].children, id);
                if(temp.id == id) return temp;
            }
        return item;
    }

    getCover(item) {
        // if the item is already an image
        if(item.fileType == 'PNG' || item.fileType == 'JPG' || item.fileType == 'JPEG'
           || item.fileType == 'png' || item.fileType == 'jpg' || item.fileType == 'jpeg')
            if(!item.label.includes('cover'))
                return item.href;

        // checking whether a specific 'cover' is added for this item
        for(let i=0; i<item.children.length; i++)
            if(item.children[i].label.includes('cover'))
                return item.children[i].href;

        // returning default covers
        for(let i=0; i<this.itemTree.length; i++)
            if( (item.isFolder == true && this.itemTree[i].label == 'default-folder')
                || (item.fileType == 'PDF' && this.itemTree[i].label == 'default-document')
                || (item.fileType == 'MP4' && this.itemTree[i].label == 'default-video')
                || (item.fileType == 'MP3' && this.itemTree[i].label == 'default-audio')
            )
                return this.itemTree[i].href;
    }
}