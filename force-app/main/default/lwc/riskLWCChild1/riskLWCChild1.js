import { LightningElement, api } from 'lwc';

export default class RiskLWCChild1 extends LightningElement {
    @api percentage;
    get getStyle() {
        return 'width:' + this.percentage + '%';
    }

    handleChange(event) {
        event.preventDefault();
        const name = event.target.value;
        const selectEvent = new CustomEvent('mycustomevent', {
            detail: name
        });
       this.dispatchEvent(selectEvent);
    }
}