@isTest
public with sharing class FlightCreatorControllerTest {
    
    @TestSetup
    static void setupData() {
        TestDataFactory.createTestAirports();
    }

    @isTest
    public static void calculateAndSaveNewFlightTest() {
        List<Airport__c> airports = [SELECT Id, Location__Latitude__s, Location__Longitude__s, Name,IATA_Code__c FROM Airport__c ORDER BY Name DESC];

        Test.startTest();
        Flight_Factory resultFlight = FlightCreatorController.calculateAndSaveNewFlight(airports[0].IATA_Code__c, airports[1].IATA_Code__c);
        Test.stopTest();

        System.assert(resultFlight.Name == 'Łódź-Radom');
        System.assert(resultFlight.departureAirportName == airports[0].Name);
        System.assert(resultFlight.arrivalAirportName == airports[1].Name);
    }
    @isTest
    public static void calculateAndSaveFlightAirportNullErrorTest() {
        List<Airport__c> airports = [SELECT Id, IATA_Code__c FROM Airport__c ORDER BY Name DESC LIMIT 1];
        Flight_Factory resultFlight;
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            resultFlight = FlightCreatorController.calculateAndSaveNewFlight(airports[0].IATA_Code__c, airports[1].IATA_Code__c);
        } catch(Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown);
    }
    @isTest
    public static void getAllAirportsTest(){
        
        Test.startTest();
        List<Airport__c> allAirports = FlightCreatorController.getAllAirports();
        Test.stopTest();

        System.assertEquals(3, allAirports.size());
    }
}