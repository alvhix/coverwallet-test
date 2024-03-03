@IsTest
private class AccountSelectorTest {
    @IsTest
    private static void testSelectById() {
        // Test data
        Account account = new Account(Name = 'Test');
        insert account;

        // Query
        IAccountsSelector accountSelector = (IAccountsSelector) Application.Selector.newInstance(
            Account.getSObjectType()
        );
        Account acc = accountSelector.selectById(account.Id);

        // Assert
        Assert.isNotNull(acc);
        Assert.areEqual('Test', acc.Name);
    }

    @IsTest
    private static void testSelectByUuid() {
        // Test data
        String uuid = '2fc1f8b1-2ca1-4e5c-a942-d31adb9f7724';
        Account account = new Account(Name = 'Test', UUID__c = uuid);
        insert account;

        // Query
        IAccountsSelector accountSelector = (IAccountsSelector) Application.Selector.newInstance(
            Account.getSObjectType()
        );
        Account acc = accountSelector.selectByUuid(uuid);

        // Assert
        Assert.isNotNull(acc);
        Assert.areEqual('Test', acc.Name);
    }
}
