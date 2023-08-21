@isTest
public with sharing class AccountServiceTest {
    private static String accountName = 'Test';
    private static Account acct = new Account(
        Name = accountName,
        AnnualRevenue = null,
        NumberOfEmployees = 1,
        Uuid__c = '123123-123123'
    );
    private static Integer numberOfRecordsToInsert = 200;

    @TestSetup
    static void makeData() {
        insert acct;
        System.debug(acct);
    }

    @isTest
    static void insertNewAccount() {
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = accountName + '-2';
        acct.annual_revenue = 0;
        acct.number_employees = 1;
        acct.uuid = '123456-123456';
        accountsList.add(acct);

        Database.UpsertResult[] accountResult = AccountService.upsertAccountsByUuid(
            accountsList
        );

        System.debug(accountResult);
        System.assertEquals(
            1,
            accountResult.size(),
            'Account was not inserted'
        );
    }

    @isTest
    static void insertNewAccounts() {
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();
        for (Integer i = 0; i < numberOfRecordsToInsert; i++) {
            AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
            acct.company_name = accountName + '-' + i;
            acct.annual_revenue = 0;
            acct.number_employees = 1;
            acct.uuid = 'test-' + String.valueOf(i);
            accountsList.add(acct);
        }

        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accountsList
        );

        System.debug(accountsResult);
        System.assertEquals(
            numberOfRecordsToInsert,
            accountsResult.size(),
            'Not all accounts have been inserted'
        );
    }

    @isTest
    static void updateExistingAccount() {
        String accountNameTest = accountName + '-3';
        Account insertedAccount = [
            SELECT Id, Name, AnnualRevenue, NumberOfEmployees, Uuid__c
            FROM Account
            LIMIT 1
        ];
        List<AccountWrapper.accounts> accountsList = new List<AccountWrapper.Accounts>();
        AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
        acct.company_name = accountNameTest;
        acct.annual_revenue = insertedAccount.AnnualRevenue;
        acct.number_employees = insertedAccount.NumberOfEmployees;
        acct.uuid = insertedAccount.Uuid__c;
        accountsList.add(acct);

        Database.UpsertResult[] result = AccountService.upsertAccountsByUuid(
            accountsList
        );

        Account accountResult = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :result.get(0).getId()
        ];

        System.debug(accountResult);
        System.assertEquals(
            accountNameTest,
            accountResult.Name,
            'Account was not updated'
        );
    }

    @isTest
    static void testAccountHighPriority() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue) + 1;
        update acct;

        Account accResult = [
            SELECT CustomerPriority__c
            FROM Account
            WHERE Id = :acct.Id
        ];

        System.debug(accResult);
        System.assertEquals(
            'High',
            accResult.CustomerPriority__c,
            'Priority is not high'
        );
    }

    @isTest
    static void testAccountMediumPriority() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue);
        update acct;

        Account accResult = [
            SELECT CustomerPriority__c
            FROM Account
            WHERE Id = :acct.Id
        ];

        System.debug(accResult);
        System.assertEquals(
            'Medium',
            accResult.CustomerPriority__c,
            'Priority is not medium'
        );
    }

    @isTest
    static void testAccountLowPriority() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Low_Revenue);
        update acct;

        Account accResult = [
            SELECT CustomerPriority__c
            FROM Account
            WHERE Id = :acct.Id
        ];

        System.debug(accResult);
        System.assertEquals(
            'Low',
            accResult.CustomerPriority__c,
            'Priority is not low'
        );
    }

    @isTest
    static void testHighPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue) + 1;
        update acct;

        Account accResult = [SELECT OwnerId FROM Account WHERE Id = :acct.Id];

        System.debug(accResult);
        System.assertEquals(
            Label.Agent_High_Priority,
            accResult.OwnerId,
            'Agent owner is not specialised in high priority accounts'
        );
    }

    @isTest
    static void testMediumPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Medium_Revenue);
        update acct;

        Account accResult = [SELECT OwnerId FROM Account WHERE Id = :acct.Id];

        System.debug(accResult);
        System.assertEquals(
            Label.Agent_Medium_Priority,
            accResult.OwnerId,
            'Agent owner is not specialised in medium priority accounts'
        );
    }

    @isTest
    static void testLowPriorityAgentOwnership() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        acct.AnnualRevenue = Integer.valueOf(Label.Account_Low_Revenue);
        update acct;

        Account accResult = [SELECT OwnerId FROM Account WHERE Id = :acct.Id];

        System.debug(accResult);
        System.assertEquals(
            Label.Agent_Low_Priority,
            accResult.OwnerId,
            'Agent owner is not specialised in low priority accounts'
        );
    }

    @isTest
    static void testGetAccounts() {
        List<Account> accounts = AccountService.getAccounts(accountName, 10, 1);

        System.assert(
            accounts.size() > 0,
            'Inserted account was not retrieved'
        );
    }

    @isTest
    static void testNumberOfRecords() {
        Integer numberOfRecords = AccountService.getNumberOfRecords(
            accountName
        );

        System.assertEquals(
            1,
            numberOfRecords,
            'Inserted account was not retrieved'
        );
    }
}
