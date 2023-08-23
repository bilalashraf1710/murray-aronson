import { LightningElement, api, wire, track } from 'lwc';
import getFloorsListBySuiteId from '@salesforce/apex/BuildingSuiteLookupController.getFloorsListBySuiteId';
import updateSuiteFloor from '@salesforce/apex/BuildingSuiteLookupController.updateSuiteFloor';

import { refreshApex } from '@salesforce/apex';

const SUITE_API_NAME = 'Suites__c';

export default class FloorsCustomPicklist extends LightningElement {
  
    @api recordId;

    @track floorOptions = [];
    @track selectedFloor;
    @track cache = {};
    
    isEdit;

    @wire(getFloorsListBySuiteId, {
        suiteId: '$recordId'
    }) getFloorsListBySuiteIdCallback(response) {
        this.cache.suite = response;
        let fetchedData = response.data;
        if (fetchedData && fetchedData != null) {
            this.floorOptions = fetchedData.pickList.split(';').reduce((floors, option) => {
                floors.push({ label: option, value: option });
                return floors;
            }, []);
            this.selectedFloor = fetchedData.selectedFloor;
            this.cache.selectedFloor = this.selectedFloor;
            this.cache.Id = fetchedData.Id;
        }
    }


    floorChange (event) {
        this.selectedFloor = event.detail.value;
    }

    editFloor () {
        this.isEdit = true;
    }

    cancel () {
        // bring previously selected floor back on display
        this.isEdit = false;
        this.selectedFloor = this.cache.selectedFloor
    }

    async save () {
        let suites = [
            {
                sobjectType: SUITE_API_NAME,
                Suite_Floor_Selected__c: this.selectedFloor,
                Id: this.cache.Id,
            },
        ]
        try {
            await updateSuiteFloor({
                suites
            })
        }  catch (e) {
            console.error(e.getMessage());
        }
        this.isEdit = false;
        this.refreshCache();
    }

    async refreshCache() {
        await refreshApex(this.cache.suite);
    }

}