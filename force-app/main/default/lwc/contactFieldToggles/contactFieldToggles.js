import { LightningElement, api } from 'lwc';
import getAllContactFields from '@salesforce/apex/ContactFieldTogglesController.getAllContactFields'

export default class ContactFieldToggles extends LightningElement {
    @api recordId
    @api contactFields;
    async connectedCallback(){
        console.log('record id for current page: ', this.recordId);
        let data = await getAllContactFields();
        if(data){
            console.log('fields: ', data);
            this.contactFields = data;
        }

    }
}