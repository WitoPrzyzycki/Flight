@isTest
public with sharing class TestDataFactory {
    

    public static void createTestAirports() {
        Airport__c newAirport1 = new Airport__c(
            IATA_Code__c = 'LCJ',
            Location__Latitude__s = 19.4666700,
            Location__Longitude__s = 51.750000, 
            Name = 'Łódź'
        );
        Airport__c newAirport2 = new Airport__c(
            IATA_Code__c = 'RDO',
            Location__Latitude__s = 21.213611,
            Location__Longitude__s = 51.389167, 
            Name = 'Radom'
        );
        Airport__c newAirport3 = new Airport__c(
            IATA_Code__c = 'LIZ',
            Location__Latitude__s = 14.213611,
            Location__Longitude__s = 4.389167, 
            Name = 'Lizbon'
        );
        List<Airport__c> airports = new List<Airport__c>{ newAirport1, newAirport2, newAirport3 };
        insert airports;
    }
}
