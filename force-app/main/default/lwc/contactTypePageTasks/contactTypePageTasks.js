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

export default class ContactTypePageTasks extends LightningElement {
    @api recordId;
    data = [];
    completedTasks = [];
    incompleteTasks = [];
    columns = columns;
    error;
    loaded = false;
  
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


        this.showIncompleteTasks = this.incompleteTasks.length > 0 ? true : false;
        this.showCompletedTasks = this.completedTasks.length > 0 ? true : false;
       

        this.incompleteTasks = this.addRelatedURLsToItems(this.incompleteTasks);
        this.completedTasks = this.addRelatedURLsToItems(this.completedTasks);

      
    }

    addRelatedURLsToItems(data1)
    {
        let copyOfData=[];
        data1?.forEach((item)=>{
            copyOfData.push({
                ...item,
                OwnerName: item?.Owner?.Name,
                RelatedToName: item?.What?.Name,
              //  RelatedToURL: (item?.WhatId)?.startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
              RelatedToURL: (item?.WhatId) ? (item?.WhatId)?.startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view' : '',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view'
            });
        })
        return copyOfData;
    }
}