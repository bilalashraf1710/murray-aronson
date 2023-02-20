import { LightningElement } from 'lwc';
import { wire, api, track } from 'lwc';
import getBrokerTasksData from '@salesforce/apex/QueryTaskData.QueryBrokerTasks';
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
    // { label: 'Last Completed', fieldName: 'CompletedDateTime' },
    // { label: 'Priority', fieldName: 'Priority' },
    { label: 'Owner', fieldName: 'OwnerName' },
    { label: 'Comments', fieldName: 'Description' ,initialWidth: 250,},


];

export default class brokerTasks extends LightningElement {
    @api recordId;
    data = [];
    completedTasks = [];
    incompleteTasks = [];
    columns = columns;
    error;
    loaded = false;
    // connectedCallback(){
    //     console.log('broker idi: ', this.recordId);
    // }
    @track showIncompleteTasks = false;
    @track showCompletedTasks = false;

    @wire(getBrokerTasksData, {brokerId: '$recordId'})
    getBuildingTasksDataCallback(response){
        const {error, data} = response;
        if(response.data){
            this.loaded = true;
        }
        console.log('dara: ', data);
        this.data = data;
        if(this.data){
            this.incompleteTasks = data.filter((item)=>item.Status !== 'Completed');
            this.completedTasks = data.filter((item)=>item.Status === 'Completed');
        }
        
        // let copyOfData =[];
        // this.data?.map((item)=>{
        //     copyOfData.push({
        //         ...item,
        //         OwnerName: item.Owner.Name,
        //         RelatedToName: item?.What?.Name,
        //         RelatedToURL: (item.WhatId).startsWith('a0L8') ? '/lightning/r/Suites__c/' +item.WhatId +'/view' : '/lightning/r/Building__c/' +item.WhatId +'/view',
        //         TaskURL:'/lightning/r/Task/' +item['Id'] +'/view'
        //     });
        // })
        // this.data = copyOfData;
        // console.log('data: ', this.data);
        // if(this.)
        // this.loaded = true;
        // this.loaded = false;

        // if(this.IncompleteTaskdata.length > 0){
        //     this.showIncompleteTasks = true;
        // }else{
        //     this.showIncompleteTasks = false;
        // }

        this.showIncompleteTasks = this.incompleteTasks.length > 0 ? true : false;
        this.showCompletedTasks = this.completedTasks.length > 0 ? true : false;
        // if(this.completedTaskdata.length > 0){
        //     this.showCompleteTasks = true;
        // } else {
        //     this.showCompleteTasks = false;
        // }
        console.log('show takss: ', this.showIncompleteTasks);

        this.incompleteTasks = this.addRelatedURLsToItems(this.incompleteTasks);
        this.completedTasks = this.addRelatedURLsToItems(this.completedTasks);

        console.log('completed tasks ', this.completedTasks);
    }

    addRelatedURLsToItems(data1)
    {
        let copyOfData=[];
        data1?.forEach((item)=>{
            copyOfData.push({
                ...item,
                OwnerName: item?.Owner?.Name,
                RelatedToName: item?.What?.Name,
                RelatedToURL: (item?.WhatId)?.startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view'
            });
        })
        return copyOfData;
    }


}