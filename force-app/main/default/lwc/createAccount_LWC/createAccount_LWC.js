import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';

import getCoordinates from '@salesforce/apex/getAddressForMap.getCoordinates';

export default class CreateAccount_LWC extends LightningElement {

    @track mapMarkers = []
    @track zoomLevel = 15;
    @track markersTitle = 'Address on Map';
    @track showFooter = false;
    @track listView = 'visible';
    @track street = '';
    @track zip = '';
    @track city = '';
    @track country = '';
    @track state = '';
    @track cleaningAddress = '';
    @track addressMapped = false;

    submitevent(event){
        if(!this.addressMapped){
            alert('Please check address on Map');
        }
        else{
            this.template.querySelector('lightning-record-edit-form').submit();
        }
    }

    showAddressOnMap(event){
        if(!this.street || !this.zip || !this.country || !this.city){
            alert('Please enter all address fields');
            this.addressMapped = false;
        }
        else{
            this.addressMapped = true;
            var addressString = this.street + ',' + this.zip + ',' + this.city + ',' + this.state + ','  +  this.country;
            this.template.querySelector('lightning-input-field[data-name="cleaningAddress"]').value  = addressString;
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

    addresschangeevent(event){
        this.street = this.template.querySelector('lightning-input[data-name="street"]').value;
        this.zip = this.template.querySelector('lightning-input[data-name="zip"]').value;
        this.city = this.template.querySelector('lightning-input[data-name="city"]').value;
        this.country = this.template.querySelector('lightning-input[data-name="country"]').value;
        this.state = this.template.querySelector('lightning-input[data-name="state"]').value;
    }

    handleSuccess(event) {
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        window.open("/" + updatedRecord, "_top");
    }

}