/**
 * Controller class for flightCreator component
 * 
 * @author Witold Przyżycki
 * @created 04.10.2022
 */
public with sharing class FlightCreatorController {
    /**
     * Controller method to fetch all available Airports
     * 
     * @author Witold Przyżycki
     * @created 04.10.2022
     * @return All Airport__c objects
     */
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> getAllAirports() {
        return Airport_Selector.getAllAirports();
    }
     /**
     * Service method to calculate and save Flight__c record 
     * 
     * @author Witold Przyżycki
     * @created 04.10.2022
     * @params Strings for IATA codes for Airports
     */
    @AuraEnabled
    public static Flight_Factory calculateAndSaveNewFlight(String departureAirportIATA, String arrivalAirportIATA) {
        try {
            Set<String> airports = New Set<String>();
            airports.add(departureAirportIATA);
            airports.add(arrivalAirportIATA);
            List<Airport__c> airportObjs = Airport_Selector.getAirportsByIATA(airports);
            Airport__c departureAirport;
            Airport__c arrivalAirport;
            for(Airport__c airport:airportObjs){
                if(airport.IATA_Code__c == departureAirportIATA){
                    departureAirport = airport;
                }else if(airport.IATA_Code__c == arrivalAirportIATA){
                    arrivalAirport = airport;
                }
            }
            if(departureAirport == null){
                throw new AuraHandledException(System.Label.NoDepartureAirport + ' ' +  departureAirportIATA);
            }else if(arrivalAirport == null){
                throw new AuraHandledException(System.Label.NoArrivalAirport +' ' + arrivalAirportIATA);
            }
            Flight__c newFlight = new Flight__c (
                DepartureAirport__c = departureAirport.Id,
                ArrivalAirport__c = arrivalAirport.Id,
                Distance__c = UtilityService.calculateDistance(
                    departureAirport.Location__Latitude__s,
                    departureAirport.Location__Longitude__s,
                    arrivalAirport.Location__Latitude__s,
                    arrivalAirport.Location__Longitude__s
                ),
                Name = departureAirport.Name + '-' + arrivalAirport.Name
            );
            insert newFlight;
            
            Flight_Factory flight = new Flight_Factory();
            return flight.cloneFlight(newFlight).withNames(departureAirport.Name, arrivalAirport.Name).getRecord();
        } catch(DmlException ex) {
            throw new AuraHandledException(System.Label.UnexpectedError + ' ' + ex.getMessage());
        }
    }
}
