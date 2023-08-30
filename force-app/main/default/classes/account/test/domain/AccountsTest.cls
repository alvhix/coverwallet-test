@IsTest(isParallel=true)
private class AccountsTest {
    @IsTest
    static void newInstanceTest() {
        Accounts instanceByRecords = Accounts.newInstance(new List<Account>());
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

        Accounts domain = Accounts.newInstance(records);
        domain.setAccountPriority(records);

        Assert.areEqual(records.get(0).Priority__c, Accounts.LOW_PRIORITY);
        Assert.areEqual(records.get(0).OwnerId, Label.Agent_Low_Priority);
    }

    @IsTest
    static void validateMediumPriorityAccount() {
        List<Account> records = new List<Account>{ AccountMother.mediumPriorityAccount() };

        Accounts domain = Accounts.newInstance(records);
        domain.setAccountPriority(records);

        Assert.areEqual(records.get(0).Priority__c, Accounts.MEDIUM_PRIORITY);
        Assert.areEqual(records.get(0).OwnerId, Label.Agent_Medium_Priority);
    }

    @IsTest
    static void validateHighPriorityAccount() {
        List<Account> records = new List<Account>{ AccountMother.highPriorityAccount() };

        Accounts domain = Accounts.newInstance(records);
        domain.setAccountPriority(records);

        Assert.areEqual(records.get(0).Priority__c, Accounts.HIGH_PRIORITY);
        Assert.areEqual(records.get(0).OwnerId, Label.Agent_High_Priority);
    }
}
