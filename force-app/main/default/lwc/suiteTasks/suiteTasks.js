import { LightningElement } from 'lwc';
import { wire, api , track} from 'lwc';
import getSuiteTasks from '@salesforce/apex/QueryTaskData.getSuiteTasks';

const columns = [
    { label: 'Task', fieldName: 'TaskURL' ,   type:'url' ,
        typeAttributes: {
            label: {
                fieldName: 'Subject'
            } 
        }
    },
    { label: 'Due Date', fieldName: 'ActivityDate', 
        type: 'date', 
        typeAttributes: {
            timeZone:"UTC",
            day: "numeric",
            month: "numeric",
            year: "numeric"
        } 
    },
    { label: 'Relationship', fieldName: 'RelatedToURL' ,type:'url', 
        typeAttributes: {
            label: {
                fieldName: 'RelatedToName'
            } 
        }
    },
    { label: 'Owner', fieldName: 'OwnerName' },
    { label: 'Comments', fieldName: 'Description' ,initialWidth: 250,},
];
export default class SuiteTasks extends LightningElement {
    @api recordId;
    IncompleteTaskdata = [];
    completedTaskdata = [];
    columns = columns;
    error;
    @track showIncompleteTasks = false;
    @track showCompleteTasks = false;

    @wire(getSuiteTasks, {suiteId: '$recordId'})
    getSuiteTasksDataCallback(response){
        const {error, data} = response;
        console.log('callbackk called ', response);
        if(data){
            this.loaded = true;
            console.log('suite tasks:: ',data);
            // this.IncompleteTaskdata = data;
            this.IncompleteTaskdata = data.filter((item)=>item.Status !== 'Completed');
            this.completedTaskdata = data.filter((item)=>item.Status === 'Completed');
            if(this.IncompleteTaskdata.length > 0){
                this.showIncompleteTasks = true;
            }else{
                this.showIncompleteTasks = false;
            }

            if(this.completedTaskdata.length > 0){
                this.showCompleteTasks = true;
            } else {
                this.showCompleteTasks = false;
            }
            
            this.IncompleteTaskdata = this.addRelatedURLsToItems(this.IncompleteTaskdata);
            this.completedTaskdata = this.addRelatedURLsToItems(this.completedTaskdata);
        }
    }



    addRelatedURLsToItems(data)
    {
        let dataWithURL=[];
        data?.forEach((item)=>{
            dataWithURL.push({
                ...item,
                OwnerName: item?.Owner?.Name,
                RelatedToName: item?.What?.Name,
                RelatedToURL: (item?.WhatId).startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view'
            });
        })
        return dataWithURL;
    }
}