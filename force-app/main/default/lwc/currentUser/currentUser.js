import { LightningElement } from 'lwc';
import getUserProfile from '@salesforce/apex/GetUserProfile.getUserProfile';
import methodName from '@salesforce/apex/GetUserProfile.methodName';

export default class CurrentUser extends LightningElement {
    async connectedCallback(){
        let data = await getUserProfile();
        console.log('data:: ', data);
        let data2 = await methodName();
        console.log('data2:: ', data2);
    }
}