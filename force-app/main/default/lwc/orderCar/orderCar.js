import { LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FirstName from '@salesforce/label/c.First_Name';
import LastName from '@salesforce/label/c.Last_Name';
import Phone from '@salesforce/label/c.Phone';
import Company from '@salesforce/label/c.Company';
import Model from '@salesforce/label/c.Model';
import Email from '@salesforce/label/c.Contact_Email';
import Description from '@salesforce/label/c.Description';
import Send from '@salesforce/label/c.Send';
import OrderTestDriveL from '@salesforce/label/c.Order_Test_Drive';
import getProductsNoAdv from '@salesforce/apex/ProductsController.getProductsNoAdv';
import createOrderRequest from '@salesforce/apex/CaseController.createOrderRequest';


export default class OrderCar extends LightningElement {
    firstName;
    lastName;
    email;
    phone;
    description;
    selectedProduct;
    company;
    options = [
        { label: 'Option 1', value: 'option1' },
    ];

    label = {
        FirstName, 
        LastName,
        Phone,
        Company,
        Model,
        Email,
        Description,
        Send,
        OrderTestDriveL
    }

    get isDisabled() {
        return !this.firstName || !this.lastName || !this.email || !this.phone || !this.selectedProduct || !this.company;
    }

    connectedCallback() {
        getProductsNoAdv()
          .then(result => {
            this.options = result.map(product => {
                return {
                    label: product.Name,
                    value: product.Id
                }
            })
          })
          .catch(error => {
            console.log(error);
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Error loading product',
                variant: 'error',
            });
            this.dispatchEvent(toastEvent);
          });
    }
    
    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleChange(event) {
        this.selectedProduct = event.target.value;
    }

    handleCompanyChange(event) {
        this.company = event.target.value;
    }

    handleOrderTestDrive() {
        const fields = {
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone,
            description: this.description,
            productId: this.selectedProduct,
            companyName: this.company
        }
    
        createOrderRequest(fields)
        .then(result => {
            const caseId = result;
            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Case has been sent!',
                variant: 'success',
            });
            this.dispatchEvent(toastEvent);

            this.firstName = '',
            this.lastName = '',
            this.email = '',
            this.phone = '',
            this.description = '',
            this.selectedProduct = '',
            this.company = ''
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'An error occurred while creating the case',
            variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
    }

}