import { LightningElement, wire, api} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import makeCallout from '@salesforce/apex/WeatherController.makeCallout';
import CITY_FIELD from '@salesforce/schema/Account.ShippingCity';
import COUNTRY_COD_FIELD from '@salesforce/schema/Account.ShippingCountry';

import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const fields = [ CITY_FIELD, COUNTRY_COD_FIELD];

export default class WeatherLWC extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields }) account;

    cityName;
    countryCod;
    description;
    result = {};

    subscription = {};
    @api channelName = '/event/Update_Weather__e';

    connectedCallback(){
        makeCallout({cityName: 'London', countryCod: 'UK'}).then(data => {
            this.cityName = {cityName: data['cityName']};
            this.countryCod = {countryCod: data['countryCod']};
            this.description = {description: data['description']};
            this.result = data;

            this.registerErrorListener();
        }).catch(err => console.log(err));
    }

    renderedCallback(){
        makeCallout(getFieldValue(this.account.data, fields)).then(data => {
            this.cityName = {cityName: data['cityName']};
            this.countryCod = {countryCod: data['countryCod']};
            this.description = {description: data['description']};
            this.result = data;
        }).catch(err => console.log(err));
    }

    get getCityName() {
        if (this.result) {
            return this.result.name;
        } 
    }

    get getStateCod() {
        if (this.result) {
            return this.result.cod;
        } 
    }

    // get getWeather(){
    //     if (this.result) {
    //         return this.result.weather;
    //     } 
    // }

    handleChange(event) {
        console.log('handleChange:');
        this.value = event.detail.value;
        makeCallout(getFieldValue(this.account.data, CITY_FIELD)).then(result => {
            this.result = event.target.name;
        }).catch(err => console.log(err));
    }
    
    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}