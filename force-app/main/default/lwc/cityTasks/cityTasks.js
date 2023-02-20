import { LightningElement } from 'lwc';
import { wire, api , track} from 'lwc';
import getCityTasksData from '@salesforce/apex/QueryTaskData.QueryCityTasks';
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
    { label: 'Owner', fieldName: 'OwnerName' },
    { label: 'Comments', fieldName: 'Description' ,initialWidth: 250,},
];

export default class CityTasks extends LightningElement {
    @api recordId;
    data;
    IncompleteTaskdata = [];
    completedTaskdata = [];
    columns = columns;
    error;
    suiteIds = [];
    @track showIncompleteTasks = false;
    @track showCompleteTasks = false;
    buildingSuiteIdsMap = [];

    async connectedCallback(){
        let data = await getCityTasksData({cityId: this.recordId});
        if(data){
            data.forEach((item)=>{
                if((item?.WhatId)?.startsWith('a0L')) {
                    this.suiteIds.push(item.WhatId);
                } 
            })
            this.loaded = true;
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

            this.suiteIds = this.getSuiteIdsFromTasksTable(data);
        }
        this.buildingSuiteIdsMap = await getBuildingFromSuites({suiteIds: this.suiteIds});

        this.IncompleteTaskdata = this.addRelatedURLsToItems(this.IncompleteTaskdata);
        this.completedTaskdata = this.addRelatedURLsToItems(this.completedTaskdata);
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
                RelatedToURL: (item?.WhatId)?.startsWith('a0L') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
                TaskURL:'/lightning/r/Task/' +item['Id'] +'/view',
                BuildingId:(item?.WhatId)?.startsWith('a0L') ? '/lightning/r/Suites__c/' +item?.WhatId +'/view' : '/lightning/r/Building__c/' +item?.WhatId +'/view',
                BuildingName:item?.What?.Name
            });
        })
        dataWithRelatedURL?.forEach((item)=>{
            if((item?.WhatId)?.startsWith('a0L')){
                dataWithBuildingsURL.push({
                    ...item,
                    BuildingId:'/lightning/r/Building__c/' + this.buildingSuiteIdsMap[item?.WhatId]?.Id + '/view',
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