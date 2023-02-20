import { LightningElement, api } from 'lwc';

export default class ChildTest extends LightningElement {
    @api mylist;

    changeClick = () =>{
        if(this.mylist==='abc'){
            this.mylist = 'xyz';
        } else{
            this.mylist = 'abc';
        }
        console.log('value= ', this.mylist)
    }
}