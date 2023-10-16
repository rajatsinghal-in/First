import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';

import Id from '@salesforce/user/Id';
import getJobCardDetails from '@salesforce/apex/getJobCards.getJobCardDetails';
import updateJobCards from '@salesforce/apex/getJobCards.updateJobCards';

const COLS = [
    { label: 'Job Card',value:'bookingId', fieldName: 'bookingLink', type: 'url', sortable: "true", typeAttributes: { label: { fieldName: 'bookingId' }, target: '_blank' }, initialWidth: 210}, 
    { label: 'Booking',value:'bookingName', fieldName: 'bookingName', sortable: "true",  initialWidth: 300 }, 
    { label: 'Cleaning Date', value:'bookingDate', fieldName: 'bookingDate', type: 'date', sortable: "true", initialWidth: 120},
   { label: 'Address', value:'bookingAddress', fieldName: 'bookingAddress',  type: "text"}
];

export default class JobCards_Lwc extends LightningElement {

    @track assignedVfPage = false;
    @track columns = COLS;
    @track data = [];
    @track userId = Id;

    _pagesource;
    @api
    get pagesource() {
      return this._pagesource;
    }
    set pagesource(value) {
      this._pagesource = value;
      switch (value) {
        case "Assignedvf":
          this.assignedVfPage = true;
      }
    }

    connectedCallback() {  
        console.log('user id -=-=-='+this.userId);
        getJobCardDetails({userId : this.userId, assigned: this.assignedVfPage})
        .then(result => {
            this.data = result;
         })
        .catch(error => {
            alert('error'+Id);
        });
    }

    handleSave(event){
        var rows = this.template.querySelector('lightning-datatable');
        var selected = rows.getSelectedRows();
        if(selected.length>0){
            var Ids = [];
            selected.forEach(currentItem => {
                Ids.push(currentItem.bookingId);
            });
            updateJobCards({jobCardIdString: JSON.stringify(Ids)})
            .then(result => {
                alert('Updated successfully');
                location.reload();
            })
            .catch(error => {
                alert('error'+error);
            });
        }
        else{
            alert('No records selected');
        }
    }

}