import { LightningElement } from 'lwc';
import { wire, api , track} from 'lwc';
import getBuildingTasksData from '@salesforce/apex/QueryTaskData.getBuildingTasksData';
// import getBuildingCompletedTasksData from '@salesforce/apex/QueryTaskData.getBuildingCompletedTasksData';
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

export default class QuintCarollTasks extends LightningElement {
    @api recordId;
    IncompleteTaskdata = [];
    completedTaskdata = [];
    columns = columns;
    error;
    @track showIncompleteTasks = false;
    @track showCompleteTasks = false;
    // @api mylist;

    @wire(getBuildingTasksData, {recordId: '$recordId'})
    getBuildingTasksDataCallback(response){
        const {error, data} = response;
        if(data){
            this.loaded = true;
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


    // @wire(getBuildingCompletedTasksData, {recordId: '$recordId'})
    // getBuildingCompletedTasksDataCallback(response){
    //     const {error, data} = response;
    //     if(data){
    //         this.loaded = true;
    //         this.completeTaskdata = data;
    //         if(this.completeTaskdata.length > 0){
    //             this.showCompleteTasks = true;
    //         } else {
    //             this.showCompleteTasks = false;
    //         }
    //         this.completeTaskdata = this.addRelatedURLsToItems(this.completeTaskdata);
    //     }
    // }
    addRelatedURLsToItems(data1)
    {
        let copyOfData=[];
        data1?.forEach((item)=>{
            copyOfData.push({
                ...item,
                OwnerName: item?.Owner?.Name,
                RelatedToName: item?.What?.Name,
                RelatedToURL: (item?.WhatId).startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view'
            });
        })
        return copyOfData;
    }
}