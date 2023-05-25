import { NavigationMixin } from "lightning/navigation";
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllCentersForMap from "@salesforce/apex/AutomotiveCenterController.getAllCentersForMap";

export default class CentersMap extends NavigationMixin(LightningElement) {
    mapMarkers = [];
    @wire(getAllCentersForMap)
    loadCenters({ error, data }) {
        if (error) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: e,
                variant: 'error'
            });
            this.dispatchEvent(event);
        } else if (data) {
            this.mapMarkers = data.map(center => {
                const name =  center.Name;
                const Latitude = center.Location__Latitude__s;
                const Longitude = center.Location__Longitude__s;
                return {
                    value: center.Id,
                    location: { Latitude, Longitude },
                    title: name,
                };
            })

            if(data.length == 0) {
                const successToast = new ShowToastEvent({
                    title : "Error",
                    message : "No Conters Found!",
                    variant : 'success'
                });
                this.dispatchEvent(successToast);
            }
        }
    }

    selectedMarkerValue = '123';

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
        this.navigateToInternalPage(event.target.selectedMarkerValue)
    }
      
    navigateToInternalPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Center__c'
            },
            state: {
                recordId
            }
        });
    }
}