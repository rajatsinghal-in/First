import { LightningElement, api, track } from "lwc";

export default class Child extends LightningElement {
  @api
  messageFromParent = "";

  @track value=100;
  @track msg;

  @api handleValueChange() {
    this.value=200;
  }

  constructor() {
    super();   
    //console.log('inside constructor');
    //this.template.addEventListener('mycustomevent', this.handleCustomEvent.bind(this));
    this.template.addEventListener("mycustomevent", this.handleCustomEvent);
}

  percentage = 10
  changeHandler(event) {
    this[event.target.name] = event.target.value <= 100 ? event.target.value : 100;
  }

  handleCustomEvent(event) {
    const textVal = event.detail;
    this.msg = textVal;
    }
}