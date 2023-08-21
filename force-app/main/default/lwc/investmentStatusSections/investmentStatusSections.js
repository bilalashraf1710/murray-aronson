import { LightningElement, api, wire } from 'lwc';
import getPortfolioRelationshipList from "@salesforce/apex/currentPastLocationController.getPortfolioRelationRecords";


const Currentcolumns = [
  {
    label: "Company",
    fieldName: "AccountURL",
    type: "url",
    hideDefaultActions: true,
    //   fixedWidth : 292,
    typeAttributes: {
      label: {
        fieldName: "Company_lookup_Name__c",
      },
      target: "_blank",
    },
  },
  {
    label: "Stake", fieldName: "Stake__c", hideDefaultActions: true,
    // fixedWidth : 292, 
  },
  {
    label: "Acquisition Date", fieldName: "PE_Acquisition_Date__c", type: 'date', hideDefaultActions: true,
    // fixedWidth : 292,
    typeAttributes: {
      timeZone: "UTC",
      day: "numeric",
      month: "numeric",
      year: "numeric"
    },
  },
  {
    label: "Portfolio Relationships Name",
    fieldName: "PRURL",
    type: "url",
    hideDefaultActions: true,
    // fixedWidth : 292,
    typeAttributes: {
      label: {
        fieldName: "Name",
      },
      target: "_blank",
    },
  },
];

const PastColumns = [
  {
    label: "Company",
    fieldName: "AccountURL",
    type: "url",
    hideDefaultActions: true,
    typeAttributes: {
      label: {
        fieldName: "Company_lookup_Name__c",
      },
      target: "_blank",
    },
  },
  { label: "Stake", fieldName: "Stake__c", hideDefaultActions: true, },
  {
    label: "Acquisition Date", fieldName: "PE_Acquisition_Date__c", type: 'date', hideDefaultActions: true,
    typeAttributes: {
      timeZone: "UTC",
      day: "numeric",
      month: "numeric",
      year: "numeric"
    },
  },
  {
    label: "Disposition Date", fieldName: "PE_Disposition_Date__c", type: 'date', hideDefaultActions: true,
    typeAttributes: {
      timeZone: "UTC",
      day: "numeric",
      month: "numeric",
      year: "numeric"
    },
  },
  {
    label: "Portfolio Relationships Name",
    fieldName: "PRURL",
    type: "url",
    hideDefaultActions: true,
    // fixedWidth : 292,
    typeAttributes: {
      label: {
        fieldName: "Name",
      },
      target: "_blank",
    },
  },
];

const dueDelligenceColumns = [
  {
    label: "Company",
    fieldName: "AccountURL",
    type: "url",
    hideDefaultActions: true,
    typeAttributes: {
      label: {
        fieldName: "Company_lookup_Name__c",
      },
      target: "_blank",
    },
  },
  //   { label: "Stake", fieldName: "Stake__c" ,hideDefaultActions : true,},
  {
    label: "Portfolio Relationships Name",
    fieldName: "PRURL",
    type: "url",
    hideDefaultActions: true,
    // fixedWidth : 292,
    typeAttributes: {
      label: {
        fieldName: "Name",
      },
      target: "_blank",
    },
  },
];

export default class InvestmentStatusSections extends LightningElement {

  @api recordId;
  activeSectionCurrent = 'Current Investments';
  activeSectionDueDiligence = 'Due Diligence Investments';
  activeSectionPast = 'Past Investments';
  Currentcolumns = Currentcolumns;
  PastColumns = PastColumns;
  dueDelligenceColumns = dueDelligenceColumns;
  currentInvestments;
  pastInvestments;
  dueDiligenceInvestments;
  error;
  showCurrentRecords = false;
  showPastRecords = false;
  showDueDiligenceRecords = false;

  @wire(getPortfolioRelationshipList, { recordId: "$recordId" })
  wiredFunction({ error, data }) {
    console.log('recordId=>', this.recordId);
    if (data) {
      console.log('data=>', data);
      let currentPr = [];
      let pastPr = [];
      let dueDiligencePr = [];
      if (data.length > 0) {
        data?.forEach((item) => {
          if (item.Investment_Status__c === 'Current') {
            this.showCurrentRecords = true;
            currentPr.push({
              ...item,
              AccountURL: "/lightning/r/Account/" + item?.Company__c + "/view",
              PRURL: "/lightning/r/Portfolio_Relationships__c/" + item?.Id + "/view"
            });
          }
          else if (item.Investment_Status__c === 'Past') {
            this.showPastRecords = true;
            pastPr.push({
              ...item,
              AccountURL: "/lightning/r/Account/" + item?.Company__c + "/view",
              PRURL: "/lightning/r/Portfolio_Relationships__c/" + item?.Id + "/view"
            });
          }
          else if (item.Investment_Status__c === 'Due Diligence') {
            this.showDueDiligenceRecords = true;
            dueDiligencePr.push({
              ...item,
              AccountURL: "/lightning/r/Account/" + item?.Company__c + "/view",
              PRURL: "/lightning/r/Portfolio_Relationships__c/" + item?.Id + "/view"
            });
          }
        });
        this.currentInvestments = currentPr.sort(function (a, b) {
          if (a.Company_lookup_Name__c.toLowerCase() < b.Company_lookup_Name__c.toLowerCase()) {
            return -1;
          }
          if (a.Company_lookup_Name__c.toLowerCase() > b.Company_lookup_Name__c.toLowerCase()) {
            return 1;
          }
          return 0;
        });;
        this.pastInvestments = pastPr.sort(function (a, b) {
          if (a.Company_lookup_Name__c.toLowerCase() < b.Company_lookup_Name__c.toLowerCase()) {
            return -1;
          }
          if (a.Company_lookup_Name__c.toLowerCase() > b.Company_lookup_Name__c.toLowerCase()) {
            return 1;
          }
          return 0;
        });;
        this.dueDiligenceInvestments = dueDiligencePr.sort(function (a, b) {
          if (a.Company_lookup_Name__c.toLowerCase() < b.Company_lookup_Name__c.toLowerCase()) {
            return -1;
          }
          if (a.Company_lookup_Name__c.toLowerCase() > b.Company_lookup_Name__c.toLowerCase()) {
            return 1;
          }
          return 0;
        });;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.currentInvestments = undefined;
        this.pastInvestments = undefined;
        this.dueDiligenceInvestments = undefined;
      }
    }
  }













}