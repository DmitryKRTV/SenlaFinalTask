import { LightningElement, api, wire } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';

const NAME_FIELD = 'Automotive_Center__c.Name';
const LOCATION_LATITUDE_FIELD = 'Automotive_Center__c.Location__Latitude__s';
const LOCATION_LONGITUDE_FIELD = 'Automotive_Center__c.Location__Longitude__s';
const centerFields = [
	NAME_FIELD,
	LOCATION_LATITUDE_FIELD,
	LOCATION_LONGITUDE_FIELD
];

export default class CenterLocation extends LightningElement {
    @api recordId;
    name;
    mapMarkers = [];

    @wire(getRecord, { recordId: '$recordId', fields: centerFields })
    loadCenter({ error, data }) {
      if (error) {
      } else if (data) {
        this.name =  getFieldValue(data, NAME_FIELD);
        const Latitude = getFieldValue(data, LOCATION_LATITUDE_FIELD);
        const Longitude = getFieldValue(data, LOCATION_LONGITUDE_FIELD);
        this.mapMarkers = [{
          location: { Latitude, Longitude },
          title: this.name,
          description: `Координаты: ${Latitude}, ${Longitude}`
        }];
      }
    }
    get cardTitle() {
        return (this.name) ? `${this.name}` : 'Центр';
    }
}