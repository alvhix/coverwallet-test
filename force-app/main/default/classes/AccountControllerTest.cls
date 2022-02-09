@isTest
public with sharing class AccountControllerTest {
    private static final String ENDPOINT = '/services/apexrest/Account/';
    private static String accountName = 'Test';
    private static String uuid = '123456-123456';
    private static Integer numberOfRecordsToInsert = 200;

    @isTest
    static void testCallAccountControllerSimple() {
        AccountWrapper accounWrapper = new AccountWrapper();
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();
        List<AccountWrapper.Contacts> contactsList = new List<AccountWrapper.Contacts>();

        // Create contacts
        AccountWrapper.Contacts cont1 = new AccountWrapper.Contacts();
        cont1.first_name = 'Pepito';
        cont1.last_name = 'Grillo';
        cont1.email = 'pepitog@gmail.com';
        contactsList.add(cont1);

        AccountWrapper.Contacts cont2 = new AccountWrapper.Contacts();
        cont2.first_name = 'Pinocho';
        cont2.last_name = 'Pincho';
        cont2.email = 'pinocho@gmail.com';
        contactsList.add(cont2);

        // Create an account
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = accountName + '-1';
        acct.annual_revenue = 0;
        acct.number_employees = 1;
        acct.uuid = uuid;
        acct.contacts = contactsList;
        accountsList.add(acct);

        // Create the wrapper object
        accounWrapper.accounts = accountsList;

        // Parse to JSON and make the REST request
        String json = JSON.serialize(accounWrapper);
        RestRequest req = new RestRequest();
        req.requestURI = Url.getSalesforceBaseUrl().toExternalForm() + ENDPOINT;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);

        RestContext.request = req;
        AccountController.createAccount();

        // Retrieve and assert results
        List<Contact> contResult = [
            SELECT Id, AccountId
            FROM Contact
            WHERE Account.Uuid__c = :uuid
        ];

        System.debug(contResult);
        System.assert(contResult.size() > 0, 'Account was not created');
    }

    @isTest
    static void testCallAccountControllerMassive() {
        AccountWrapper accounWrapper = new AccountWrapper();
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();
        List<AccountWrapper.Contacts> contactsList = new List<AccountWrapper.Contacts>();

        for (Integer i = 0; i < numberOfRecordsToInsert; i++) {
            // Create an account
            AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
            acct.company_name = accountName + '-' + i;
            acct.annual_revenue = 0;
            acct.number_employees = 1;
            acct.uuid = 'test-' + String.valueOf(i);
            acct.contacts = contactsList;
            accountsList.add(acct);
        }
        // Create the wrapper object
        accounWrapper.accounts = accountsList;

        // Parse to JSON and make the REST request
        String json = JSON.serialize(accounWrapper);
        RestRequest req = new RestRequest();
        req.requestURI = Url.getSalesforceBaseUrl().toExternalForm() + ENDPOINT;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);

        RestContext.request = req;
        AccountController.createAccount();

        // Retrieve and assert results
        List<Account> accountsResult = [
            SELECT Id
            FROM Account
            WHERE Uuid__c LIKE '%test-%'
        ];

        System.debug(accountsResult);
        System.assertEquals(
            numberOfRecordsToInsert,
            accountsResult.size(),
            'Not all accounts were created'
        );
    }
}
