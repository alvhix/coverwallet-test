@isTest
public with sharing class ContactServiceTest {
    private static String accountName = 'Test';
    private static Account account = new Account(
        Name = 'Test',
        AnnualRevenue = null,
        NumberOfEmployees = 1,
        Uuid__c = '123123-123123'
    );
    private static List<Contact> contacts = new List<Contact>{
        new Contact(
            FirstName = 'Pepito',
            LastName = 'Grillo',
            Email = 'pepito@gmail.com'
        ),
        new Contact(
            FirstName = 'Sarita',
            LastName = 'Teodoro',
            Email = 'sarita@gmail.com'
        )
    };
    private static Integer numberOfRecordsToInsert = 200;

    @TestSetup
    static void makeData() {
        insert account;
        for (Contact cont : contacts) {
            cont.AccountId = account.Id;
        }
        insert contacts;
        System.debug(account);
        System.debug(contacts);
    }

    @isTest
    static void insertNewContact() {
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();

        List<AccountWrapper.Contacts> contactsList = new List<AccountWrapper.Contacts>();
        AccountWrapper.Contacts cont = new AccountWrapper.Contacts();
        cont.email = 'pinocho@gmail.com';
        cont.first_name = 'Pinocho';
        cont.last_name = 'Pincho';

        contactsList.add(cont);

        Account insertedAcct = [
            SELECT Id, Name, AnnualRevenue, NumberOfEmployees, Uuid__c
            FROM Account
            LIMIT 1
        ];
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = insertedAcct.Name;
        acct.annual_revenue = insertedAcct.AnnualRevenue;
        acct.number_employees = insertedAcct.NumberOfEmployees;
        acct.uuid = insertedAcct.Uuid__c;
        acct.contacts = contactsList;

        accountsList.add(acct);

        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accountsList
        );
        Database.UpsertResult[] contactsResult = ContactService.upsertContactsByEmail(
            accountsResult,
            accountsList
        );

        System.debug(contactsResult);
        System.assert(
            contactsResult[0].getId() != null,
            'Contact was not inserted'
        );
    }

    @isTest
    static void insertNewContacts() {
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();

        List<AccountWrapper.Contacts> contactsList = new List<AccountWrapper.Contacts>();
        for (Integer i = 0; i < numberOfRecordsToInsert; i++) {
            AccountWrapper.Contacts cont = new AccountWrapper.Contacts();
            cont.email = 'pinocho' + i + '@gmail.com';
            cont.first_name = 'Pinocho';
            cont.last_name = 'Pincho';

            contactsList.add(cont);
        }

        Account insertedAcct = [
            SELECT Id, Name, AnnualRevenue, NumberOfEmployees, Uuid__c
            FROM Account
            LIMIT 1
        ];
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = insertedAcct.Name;
        acct.annual_revenue = Integer.valueOf(insertedAcct.AnnualRevenue);
        acct.number_employees = insertedAcct.NumberOfEmployees;
        acct.uuid = insertedAcct.Uuid__c;
        acct.contacts = contactsList;

        accountsList.add(acct);

        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accountsList
        );
        Database.UpsertResult[] contactsResult = ContactService.upsertContactsByEmail(
            accountsResult,
            accountsList
        );

        System.debug(contactsResult);
        System.assertEquals(
            numberOfRecordsToInsert,
            contactsResult.size(),
            'Not all contacts have been inserted'
        );
    }

    @isTest
    static void testHighPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue) + 1;
        update acct;

        List<Contact> contacts = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :acct.Id
        ];
        update contacts;

        Contact contResult = [
            SELECT OwnerId
            FROM Contact
            WHERE AccountId = :acct.Id
            LIMIT 1
        ];

        System.debug(contResult);
        System.assertEquals(
            Label.Agent_High_Priority,
            contResult.OwnerId,
            'Agent owner is not specialised in high priority contacts'
        );
    }

    @isTest
    static void testMediumPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue);
        update acct;

        List<Contact> contacts = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :acct.Id
        ];
        update contacts;

        Contact contResult = [
            SELECT Id, OwnerId
            FROM Contact
            WHERE AccountId = :acct.Id
            LIMIT 1
        ];

        System.debug(contResult);
        System.assertEquals(
            Label.Agent_Medium_Priority,
            contResult.OwnerId,
            'Agent owner is not specialised in medium priority contacts'
        );
    }

    @isTest
    static void testLowPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Low_Revenue);
        update acct;

        List<Contact> contacts = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :acct.Id
        ];
        update contacts;

        Contact contResult = [
            SELECT Id, OwnerId
            FROM Contact
            WHERE AccountId = :acct.Id
            LIMIT 1
        ];

        System.debug(contResult);
        System.assertEquals(
            Label.Agent_Low_Priority,
            contResult.OwnerId,
            'Agent owner is not specialised in low priority contacts'
        );
    }

    @isTest
    static void testDeleteLeftContacts() {
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();

        List<AccountWrapper.Contacts> contactsList = new List<AccountWrapper.Contacts>();
        AccountWrapper.Contacts cont = new AccountWrapper.Contacts();
        cont.email = 'pinocho@gmail.com';
        cont.first_name = 'Pinocho';
        cont.last_name = 'Pincho';
        contactsList.add(cont);

        Account insertedAcct = [
            SELECT Id, Name, AnnualRevenue, NumberOfEmployees, Uuid__c
            FROM Account
            LIMIT 1
        ];
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = insertedAcct.Name;
        acct.annual_revenue = insertedAcct.AnnualRevenue;
        acct.number_employees = insertedAcct.NumberOfEmployees;
        acct.uuid = insertedAcct.Uuid__c;
        acct.contacts = contactsList;

        accountsList.add(acct);
        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accountsList
        );

        Database.UpsertResult[] contactsResult = ContactService.upsertContactsByEmail(
            accountsResult,
            accountsList
        );

        Database.DeleteResult[] deletedContacts = ContactService.deleteLeftContacts(
            accountsResult,
            contactsResult
        );

        System.assertEquals(
            ContactServiceTest.contacts.size(),
            deletedContacts.size(),
            'Contacts were not deleted'
        );
    }

    @isTest
    static void testGetContacts() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        List<Contact> contacts = ContactService.getContacts(
            new List<Id>{ acct.Id },
            10,
            1
        );
        System.assert(
            contacts.size() > 0,
            'Inserted contacts were not retrieved'
        );
    }

    @isTest
    static void testGetNumberOfRecords() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Integer expected = [
            SELECT COUNT()
            FROM Contact
            WHERE AccountId = :acct.Id
        ];
        Integer numberOfRecords = ContactService.getNumberOfRecords(
            new List<Id>{ acct.Id }
        );
        System.assertEquals(
            expected,
            numberOfRecords,
            'Inserted contacts were not retrieved'
        );
    }
}
