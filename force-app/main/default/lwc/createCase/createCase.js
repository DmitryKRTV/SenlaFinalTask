import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASE_OBJECT from '@salesforce/schema/Case';
import CASE_SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import CASE_DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import CASE_SUPPLIED_EMAIL_FIELD from '@salesforce/schema/Case.SuppliedEmail';
import Ask_a_Question from '@salesforce/label/c.Ask_a_Question';
import Subject from '@salesforce/label/c.Subject';
import Email from '@salesforce/label/c.Contact_Email';
import Send from '@salesforce/label/c.Send';
import Description from '@salesforce/label/c.Description';

export default class CreateCaseForExperienceSite extends LightningElement {
    subject;
    description;
    email;

    label = {
        Ask_a_Question,
        Subject,
        Email,
        Description,
        Send
    }

    get isDisabled() {
        return !this.subject || !this.email;
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleCreateCase() {
        const fields = {};
        fields[CASE_SUBJECT_FIELD.fieldApiName] = this.subject;
        fields[CASE_DESCRIPTION_FIELD.fieldApiName] = this.description;
        fields[CASE_SUPPLIED_EMAIL_FIELD.fieldApiName] = this.email;
        const recordInput = { apiName: CASE_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(data => {
                this.subject = '';
                this.description = '';
                this.email = '';
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: 'Case has been sent!',
                    variant: 'success',
                });
                this.dispatchEvent(toastEvent);
            })
            .catch(error => {
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'Error creating case record',
                    variant: 'error',
                });
                this.dispatchEvent(toastEvent);
            });
    }
}