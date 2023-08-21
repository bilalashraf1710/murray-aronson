import { LightningElement,api,wire } from 'lwc';
import getAccountList from "@salesforce/apex/currentPastLocationController.getAccountsList";


const columns = [
    {
      label: "Location",
      fieldName: "AccountURL",
      type: "url",
      typeAttributes: {
        label: {
          fieldName: "Name",
        },
        target: "_blank",
      },
    },
    { label: "Location Type", fieldName: "Location_Type__c" },
    { label: "Tenancy Type", fieldName: "Tenancy_Type__c" },
    { label: "RSF", fieldName: "RSF__c",type: 'number',cellAttributes: { alignment: 'left' }},
    { label: "LEXP", fieldName: "LEXP__c",type: 'date', 
    typeAttributes: {
        timeZone:"UTC",
        day: "numeric",
        month: "numeric",
        year: "numeric"},
    }
  ];

  const columnsOtherLoc = [
    {
      label: "Location",
      fieldName: "AccountURL",
      type: "url",
      typeAttributes: {
        label: {
          fieldName: "Name",
        },
        target: "_blank",
      },
    },
    { label: "Location Status", fieldName: "Location_Status__c" },
    { label: "Location Type", fieldName: "Location_Type__c" },
    { label: "Tenancy Type", fieldName: "Tenancy_Type__c" },
    { label: "RSF", fieldName: "RSF__c",type: 'number',cellAttributes: { alignment: 'left' }},
    { label: "LEXP", fieldName: "LEXP__c",type: 'date', 
    typeAttributes: {
        timeZone:"UTC",
        day: "numeric",
        month: "numeric",
        year: "numeric"},
    }
  ];



export default class CurrentPastLocationSection extends LightningElement {

    @api recordId;
    activeSections = 'Current Locations';
    activeSectionsPast = 'Past Locations';
    activeSectionsOther = 'Other Locations';
    columns = columns;
    columnsOtherLoc = columnsOtherLoc;
    currentLocation;
    pastLocation;
    otherLocation;
    error;
    showCurrentRecords=false;
    showPastRecords=false;
    showOtherRecords=false;

    @wire(getAccountList, { recordId: "$recordId" })
    wiredFunction({ error, data }) {
        console.log('recordId=>', this.recordId);
      if (data) {
        console.log('data=>', data);
       let currentLocationAcc= [];
       let pastLocationAcc = [];
       let otherLocationAcc = [];
        if (data.length > 0) {
          data?.forEach((item) => {
            if(item.Location_Status__c ==='Current')
            {
              this.showCurrentRecords = true;
            currentLocationAcc.push({
            ...item,
              AccountURL: "/lightning/r/Account/" + item?.Id + "/view"
            });
        }
        else if(item.Location_Status__c ==='Past')
        {
            this.showPastRecords = true;
            pastLocationAcc.push({
                ...item,
                  AccountURL: "/lightning/r/Account/" + item?.Id + "/view"
                });
        }
        else if(item.Location_Status__c ==='Future' || item.Location_Status__c === 'N/A' || item.Location_Status__c === undefined)
        {
            this.showOtherRecords = true;
            otherLocationAcc.push({
                ...item,
                  AccountURL: "/lightning/r/Account/" + item?.Id + "/view"
                });
        }
          });
          this.currentLocation = currentLocationAcc;
          this.pastLocation = pastLocationAcc;
          this.otherLocation = otherLocationAcc;
          this.error = undefined;
        } else if (error) {
          this.error = error;
          this.currentLocation = undefined;
          this.pastLocation = undefined;
        }
      }
    }
}