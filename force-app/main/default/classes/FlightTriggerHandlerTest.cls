@isTest
public with sharing class FlightTriggerHandlerTest {
    
    @TestSetup
    static void setupData() {
        TestDataFactory.createTestAirports();
        FlightCreatorController.calculateAndSaveNewFlight('LCJ','RDO');
    }
    @isTest
    public static void updateTest(){
        Flight__c flight = [SELECT Id, ArrivalAirport__c, DepartureAirport__c, Distance__c FROM Flight__c LIMIT 1];
        Airport__c airport = [SELECT Id FROM Airport__c WHERE IATA_Code__c = :'LIZ'];

        Decimal initialDistance = flight.Distance__c;
        flight.ArrivalAirport__c = airport.Id;
        Test.startTest();
        update flight;
        Test.stopTest();

        Flight__c flightAfter = [SELECT Id, ArrivalAirport__c, DepartureAirport__c, Distance__c FROM Flight__c LIMIT 1];

        System.assertEquals(flightAfter.ArrivalAirport__c, airport.Id);
        System.assertNotEquals(initialDistance, flightAfter.Distance__c);
    }
}
