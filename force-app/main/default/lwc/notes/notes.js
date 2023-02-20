import { LightningElement, api, track } from 'lwc';
import getAllNotes from '@salesforce/apex/NotesController.getAllNotes';
import saveNote from '@salesforce/apex/NotesController.saveNote';

const columns = [
    { label: 'Note', fieldName: 'Note__c'},
    { label: 'Date', fieldName: 'Date__c', 
        type: 'date', 
        typeAttributes: {
            timeZone:"UTC",
            day: "numeric",
            month: "numeric",
            year: "numeric"
        } 
    },
];

export default class Notes extends LightningElement {

    @api recordId;
    data = [];
    @api text;
    columns = columns;
    async connectedCallback(){
        console.log('recordId: ', this.recordId);
        this.refreshNotesList();
    }
    async refreshNotesList(){

        let data = await getAllNotes({recordId: this.recordId});

        this.data = data;
        console.log('this.data: ', this.data);
        this.text = '';
    }

    onchange(event){
        console.log('text: ', event.target.value);
        this.text = event.target.value;
    }
    async saveNote(){
        console.log('note before saving:: ', this.text);
        await saveNote({
            recordId: this.recordId,
            note : this.text
        });
        this.refreshNotesList();
    }
}