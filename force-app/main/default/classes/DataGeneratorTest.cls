@isTest
public with sharing class DataGeneratorTest {
    @isTest
    static void insertAccount() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DataGenerator());
        DataGenerator dg = new DataGenerator();
        HttpResponse response = dg.generateAccounts(1);
        Test.stopTest();

        System.assertEquals('OK', response.getStatus(), 'Status is not OK');
    }

    @isTest
    static void insertAccounts() {
        Integer accountsToInsert = 200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DataGenerator());
        DataGenerator dg = new DataGenerator();
        HttpResponse response = dg.generateAccounts(accountsToInsert);
        Test.stopTest();

        System.assertEquals('OK', response.getStatus(), 'Status is not OK');
    }
}
