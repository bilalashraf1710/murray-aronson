import { LightningElement } from 'lwc';
import { wire, api, track } from 'lwc';
import getBrokerTasksData from '@salesforce/apex/QueryTaskData.QueryBrokerTasks';
import getBuildingFromSuites from '@salesforce/apex/QueryTaskData.getBuildingsRelatedToSuites';
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

    {
        label: 'Building', fieldName: 'BuildingId', type:'url',
            typeAttributes: {
                label: {
                    fieldName: 'BuildingName'
                }
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
    suiteIds = [];
    @track showIncompleteTasks = false;
    @track showCompletedTasks = false;
    buildingSuiteIdsMap = [];

   // @wire(getBrokerTasksData, {brokerId: '$recordId'})
   // getBuildingTasksDataCallback(response){
        //const {error, data} = response;
       // if(response.data){
           // this.loaded = true;
        //}
       // console.log('dara: ', data);
    async connectedCallback(){
        let data = await getBrokerTasksData({brokerId: this.recordId});
        if(data)
        {
        this.loaded = true;
        
      
        this.incompleteTasks = data.filter((item)=>item.Status !== 'Completed');
        this.completedTasks = data.filter((item)=>item.Status === 'Completed');
        
        
       

        this.showIncompleteTasks = this.incompleteTasks.length > 0 ? true : false;
        this.showCompletedTasks = this.completedTasks.length > 0 ? true : false;
        
       // console.log('show takss: ', this.showIncompleteTasks);
        this.suiteIds = this.getSuiteIdsFromTasksTable(data);
    }
        this.buildingSuiteIdsMap = await getBuildingFromSuites({suiteIds: this.suiteIds});
        this.incompleteTasks = this.addRelatedURLsToItems(this.incompleteTasks);
        this.completedTasks = this.addRelatedURLsToItems(this.completedTasks);

        console.log('completed tasks ', this.completedTasks);
    }

    addRelatedURLsToItems(data)
    {
        let dataWithRelatedURL=[];
        let dataWithBuildingsURL=[];
        data?.forEach((item)=>{
            if((item?.WhatId)?.startsWith('a0L')) {
                this.suiteIds.push(item.WhatId);
            } 
            dataWithRelatedURL.push({
                ...item,
                OwnerName: item?.Owner?.Name,
                RelatedToName: item?.What?.Name,
                RelatedToURL: (item?.WhatId) ? (item?.WhatId)?.startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view' : '',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view',
                BuildingId:(item?.WhatId) ? (item?.WhatId)?.startsWith('a0L8') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view' : '',
                BuildingName:item?.What?.Name
            });
        })
        dataWithRelatedURL?.forEach((item)=>{
            if((item?.WhatId)?.startsWith('a0L')){
                dataWithBuildingsURL.push({
                    ...item,
                    BuildingId:(this.buildingSuiteIdsMap[item?.WhatId])?'/lightning/r/Building__c/' + this.buildingSuiteIdsMap[item?.WhatId]?.Id + '/view':'',
                    BuildingName:this.buildingSuiteIdsMap[item?.WhatId]?.Name,
                })
            } else{
                dataWithBuildingsURL.push({
                    ...item,
                })
            }
            
        })
        return dataWithBuildingsURL;
    }

    getSuiteIdsFromTasksTable(data)
    {
        let suiteIds = [];
        data?.forEach((item)=>{
            if((item?.WhatId)?.startsWith('a0L')) {
                suiteIds.push(item.WhatId);
            } 
        })
        return suiteIds;
    }


}