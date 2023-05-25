import getAllCenters from '@salesforce/apex/AutomotiveCenterController.getAllCenters';
import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import 	Dealers from '@salesforce/label/c.Dealers';
import 	Services from '@salesforce/label/c.Services';
import 	Address from '@salesforce/label/c.Address';
import 	Phone from '@salesforce/label/c.Phone';
import 	WorkingDays from '@salesforce/label/c.Working_days';
import 	WorkingHours from '@salesforce/label/c.Working_hours';
import 	VisitCenterPage from '@salesforce/label/c.Visit_Center_Page';

export default class Centers extends NavigationMixin(LightningElement) {
    labelCenter = {
        Dealers,
        Services,
        Address,
        Phone,
        WorkingDays,
        WorkingHours,
        VisitCenterPage
    }

    @wire(getAllCenters, {centerType: 'Dealer'})
    dealers;

    @wire(getAllCenters, {centerType: 'Service'})
    services;

    handleClick(event) {
        const { target } = event;
        const { centerid } = target.dataset;
        this.navigateToInternalPage(centerid)
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