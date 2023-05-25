import { api, wire } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductsOfCenter from '@salesforce/apex/AutomotiveCenterController.getProductsOfCenter';
import DriveUnit from '@salesforce/label/c.Drive_Unit';
import Price from '@salesforce/label/c.Price';
import Transmission from '@salesforce/label/c.Transmission';
import Currency from '@salesforce/label/c.Currency';
import Complectation from '@salesforce/label/c.Complectation';
import CarBodyType from '@salesforce/label/c.Car_Body_Type';
import Engine from '@salesforce/label/c.Engine';
import FuelType from '@salesforce/label/c.Fuel_Type';
import Color from '@salesforce/label/c.Color';
import DownloadPriceList from '@salesforce/label/c.Download_Price_List';
import getPDF from '@salesforce/apex/AutomotiveCenterController.getPDF';
import getRates from '@salesforce/apex/ExchangeRateController.getRates';


export default class ProductDescriptionModal extends LightningModal {
    @api content;
    @api headerText;
    @api centerid;
    @api family;
    products;
    boolShowSpinner = false;

    selectedCurrency = 'BYN'

    options = [
        { label: 'Option 1', value: 'option1' },
        { label: 'Option 2', value: 'option2' },
        { label: 'Option 3', value: 'option3' }
      ];
    
    labelModal = {
        Currency,
        DriveUnit,
        Price,
        Transmission,
        Complectation,
        CarBodyType,
        Engine,
        FuelType,
        Color,
        DownloadPriceList
    }

    @wire(getProductsOfCenter, {centerid: '$centerid', family: '$family', currencyCode: '$selectedCurrency'})
    loadProducts(data) {
        console.log(data);
        this.products = data;
    }

    connectedCallback() {
        getRates()
          .then(result => {
            this.options = result.map(rate => {
                if (rate.IsDefault__c) this.selectedCurrency = rate.Alphabetic_Currency_Code__c
                return {
                    label: rate.Alphabetic_Currency_Code__c,
                    value: rate.Alphabetic_Currency_Code__c
                }
            })
          })
          .catch(error => {
            console.error(error);
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Error loading prices',
                variant: 'error',
            });
            this.dispatchEvent(toastEvent);
          });
    }

    get hasResults() {
		return (this.products.data.length > 0);
	}

    handleOkay(event) {
        this.close(event);
    }

    createPDF() {
        getPDF({centerid: this.centerid, family: this.family, currencyCode: this.selectedCurrency})
        .then(data => {
            this.handleSaveFile(data)
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Error creating pdf',
                variant: 'error',
            });
            this.dispatchEvent(toastEvent);
        })
    }

    handleSaveFile(data) {
        const byteCharacters = atob(data);
        const byteNumbers = new Array(byteCharacters.length);

        for (let i = 0; i < byteCharacters.length; i++) {
            byteNumbers[i] = byteCharacters.charCodeAt(i);
        }

        const byteArray = new Uint8Array(byteNumbers);
        const blob = new Blob([byteArray], { type: 'application/pdf' });

        const url = URL.createObjectURL(blob);

        const link = document.createElement('a');
        link.href = url;
        link.download = 'Price-List.pdf'; 

        document.body.appendChild(link);

        link.click();

        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }


    handleChange(event) {
        this.selectedCurrency = event.target.value;
    }
}