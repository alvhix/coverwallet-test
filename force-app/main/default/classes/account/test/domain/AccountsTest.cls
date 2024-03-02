@IsTest(isParallel=true)
private class AccountsTest {
    @IsTest
    static void newInstanceTest() {
        Accounts instanceByRecords = (Accounts) Application.Domain.newInstance(new List<Account>());
    }

    @IsTest
    static void insertAndUpdateOnRecords() {
        // Test insert, update and delete fires off triggers properly
        List<Account> accounts = new List<Account>{
            AccountMother.random(),
            AccountMother.random(),
            AccountMother.random()
        };
        insert accounts;
        update accounts;
        delete accounts;
    }

    @IsTest
    static void validateLowPriorityAccount() {
        List<Account> records = new List<Account>{ AccountMother.lowPriorityAccount() };

        Accounts domain = (Accounts) Application.Domain.newInstance(records);
        domain.setAccountPriority();

        Assert.areEqual(Accounts.LOW_PRIORITY, records.get(0).Priority__c);
        Assert.areEqual(Label.Agent_Low_Priority, records.get(0).OwnerId);
    }

    @IsTest
    static void validateMediumPriorityAccount() {
        List<Account> records = new List<Account>{ AccountMother.mediumPriorityAccount() };

        Accounts domain = (Accounts) Application.Domain.newInstance(records);
        domain.setAccountPriority();

        Assert.areEqual(Accounts.MEDIUM_PRIORITY, records.get(0).Priority__c);
        Assert.areEqual(Label.Agent_Medium_Priority, records.get(0).OwnerId);
    }

    @IsTest
    static void validateHighPriorityAccount() {
        List<Account> records = new List<Account>{ AccountMother.highPriorityAccount() };

        Accounts domain = (Accounts) Application.Domain.newInstance(records);
        domain.setAccountPriority();

        Assert.areEqual(Accounts.HIGH_PRIORITY, records.get(0).Priority__c);
        Assert.areEqual(Label.Agent_High_Priority, records.get(0).OwnerId);
    }
}
