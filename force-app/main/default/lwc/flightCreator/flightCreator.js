import { LightningElement, track } from 'lwc';
import getAllAirports from '@salesforce/apex/FlightCreatorController.getAllAirports';
import calculateAndSaveNewFlight from '@salesforce/apex/FlightCreatorController.calculateAndSaveNewFlight';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { labels } from 'c/labelUtilities'

export default class FlightCreator extends LightningElement {
    
    allAirportData =[];
    airportOptions = [];
    chosenDepartureAirport;
    chosenArrivalAirport;
    label = labels;
    @track createdFlight;


    get isResult() {
        if (this.createdFlight) {
            return true;
        }
        return false;
    }
    get name() {
        return this.createdFlight.name;
    }

    get departureAirportName() {
        return this.createdFlight.departureAirportName;
    }

    get arrivalAirportName() {
        return this.createdFlight.arrivalAirportName;
    }

    get distance() {
        return Math.round(this.createdFlight.distance * 100)/100;
    }
    handleChange(event) {
        if (event.target.name == "departureAirport") {
            this.chosenDepartureAirport = event.target.value;
        } else if (event.target.name == "arrivalAirport") {
            this.chosenArrivalAirport = event.target.value;
        }
    }
    handleFlightCreation() {
        if (this.chosenDepartureAirport && this.chosenArrivalAirport && this.chosenDepartureAirport.toUpperCase() === this.chosenArrivalAirport.toUpperCase()) {
            this.showToast(this.label.makeSureBeforeSave, 'error');
        } else if (this.validateInputs()) {
            calculateAndSaveNewFlight({departureAirportIATA :this.chosenDepartureAirport,arrivalAirportIATA :this.chosenArrivalAirport})
                .then((result)=>{
                    this.createdFlight = result;
                }).catch((error) => {
                    this.showToast(error.body.message, 'error');
                });
        }

    }
    validateInputs() {
        let isValid = true;
        this.template.querySelectorAll('lightning-combobox').forEach((field) => {
            if (!field.reportValidity()) {
                isValid = field.reportValidity();
            } 
        });
        return isValid;
    }
    showToast(mssage, variant) {
        this.dispatchEvent(new ShowToastEvent({
            message: mssage,
            variant: variant,
        }));
    }
}