import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import createBookings from '@salesforce/apex/CreateBookingController.createBookings';
import getCoordinates from '@salesforce/apex/getAddressForMap.getCoordinates';
import { getRecord } from 'lightning/uiRecordApi';

export default class CreateBooking_LWC extends LightningElement {

    @track mapMarkers = []
    @track zoomLevel = 15;
    @track markersTitle = 'Address on Map';
    @track showFooter = false;
    @track listView = 'visible';
    @track StartDate = new Date();
    @track EndDate = new Date();
    @track enddateclass = 'slds-hide';
    @track accountId = '';
    @track account;
    @track address = '';

    accountSelected(event){
        this.accountId = event.target.value;
    }

    showenddate(event){
        if(event.target.value == ''){
            this.template.querySelector('lightning-input-field[data-name="discount"]').value  = 0;
            this.enddateclass = 'slds-hide';
        }
        else{
            this.template.querySelector('lightning-input-field[data-name="discount"]').value  = 10;
            this.enddateclass = '';
        }
    }

    datechange(event){
        if(event.target.fieldName === 'StartDate') {
            this.StartDate = event.target.value;
          } else if(event.target.fieldName === 'End_Date__c') {
            this.EndDate = event.target.value;
          }
    }

    submitevent(event){
        let today = new Date();
        var start = new Date(this.StartDate);
        if(today>=start){
            alert('Start Date must be in future');
        }
        else if(this.enddateclass == '' && this.StartDate>this.EndDate){
            alert('End date should be after start date');
        }
        else{
            this.template.querySelector('lightning-record-edit-form').submit();
        }
    }

    handleSuccess(event) {
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        createBookings({ contractId: updatedRecord})
         .then(result => {
            window.open("/" + updatedRecord, "_top");
         })
        .catch(error => {
            alert('error');
        });
    }

    @wire(getRecord, {
        recordId: '$accountId',
        fields: ['Account.Address__c']
    })
    wiredAccount({
        error,
        data
    }) {
        if (data) {
            this.account = data;
            this.address = data.fields['Address__c'].value;
            console.log('address'+this.address);
            if(this.address)
            this.showAddressOnMap();
        } else if (error) {
            console.log('error : '+error);
        }
    }

    showAddressOnMap(event){
            var addressString = this.address;
            addressString = addressString.replaceAll(' ','%20');
            getCoordinates({ Address: addressString })
            .then(response => {
                let geoCode = JSON.parse(response);
                if (geoCode && geoCode.status === "OK") {
                    let finalString = geoCode.results[0];
                    let geoCodeLocation = {};
                    geoCodeLocation.Latitude = finalString.geometry.location.lat;
                    geoCodeLocation.Longitude = finalString.geometry.location.lng;
                    this.mapMarkers = [{ location: geoCodeLocation }];
                    this.markersTitle = finalString.formatted_address;
                }
            })
            .catch(error => {
                alert('Error : '+error);
            })
    }

}