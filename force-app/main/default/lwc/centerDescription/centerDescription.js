import { LightningElement, api, wire } from 'lwc';
import ProductDescriptionModal from 'c/productDescriptionModal';
import getProductsOfCenterAdv from '@salesforce/apex/AutomotiveCenterController.getProductsOfCenterAdv';
import productDescription from '@salesforce/label/c.ProductDescription'
import AutoInStock from '@salesforce/label/c.Auto_in_stock'
import AutomotiveLineup from '@salesforce/label/c.Automotive_Lineup'
import Haven_t_found_any_results from '@salesforce/label/c.Haven_t_found_any_results'

export default class CenterDescription extends LightningElement {
    @api recordId;
    products;

    label = {
        productDescription,
        AutoInStock,
        AutomotiveLineup,
        Haven_t_found_any_results
    }  
    
    @wire(getProductsOfCenterAdv, { centerId: '$recordId' })
    handle(data) {
        console.log(data);
        this.products = data;
    }

	get hasResults() {
		return (this.products.data.length > 0);
	}

    async handleShowModal(event) {
        const { target } = event;
        const { name, centerid, family } = target.dataset;
        const result = await ProductDescriptionModal.open({
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
            headerText: `${name}`,
            centerid: centerid,
            family: family,
        });
    }
}