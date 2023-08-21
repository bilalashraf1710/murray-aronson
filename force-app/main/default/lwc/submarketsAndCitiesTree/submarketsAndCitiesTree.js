import { LightningElement, api, wire, track } from "lwc";
import getMarketName from "@salesforce/apex/MarketSubmarketCityController.getMarketName";
import getMarketRelatedSubmarkets from "@salesforce/apex/MarketSubmarketCityController.getMarketRelatedSubMarkets";
import getSubMarketRelatedCities from "@salesforce/apex/MarketSubmarketCityController.getSubMarketRelatedCities";

export default class SubmarketsAndCitiesTree extends LightningElement {
  @api recordId;
  @api marketName;
  @api items;
  @api showData = false;
  error;
  submarketList;
  citiesList;
  connectedCallback() {
    getMarketName({ recordId: this.recordId })
      .then((result) => {
        this.marketName = result;
        this.error = undefined;
        this.getSubMarketList(this.recordId);
      })
      .catch((error) => {
        this.error = error;
        this.marketName = undefined;
      });
  }

  async getSubMarketList(recordId) {
    try {
      const result = await getMarketRelatedSubmarkets({
        recordId: recordId
      });
      if (result.length > 0) {
        this.showData = true;
      }
      this.submarketList = result;
      let tempArr = [];
      tempArr = await this.submarketList.map(async (mapItem) => {
        return {
          label: mapItem.Name,
          name: mapItem.Id,
          href: "/lightning/r/Submarket__c/" + mapItem.Id + "/view",
          disabled: false,
          expanded: false,
          items: [...(await this.getCitiesList(mapItem.Id))]
        };
      });

      this.items = await Promise.all([...tempArr]);
    } catch (error) {
      this.error = error;
      this.submarketList = undefined;
    }
  }

  async getCitiesList(recordId) {
    let items;
    try {
      const result = await getSubMarketRelatedCities({
        recordId: recordId
      });
      this.citiesList = result;
      items = this.citiesList.map((mapItem) => {
        return {
          label: mapItem.Name,
          name: mapItem.Id,
          href: "/lightning/r/City__c/" + mapItem.Id + "/view",
          disabled: false,
          expanded: false,
          items: []
        };
      });
      return items;
    } catch (error) {
      this.error = error;
      this.citiesList = undefined;
    }
  }
}