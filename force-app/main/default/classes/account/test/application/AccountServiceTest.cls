@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
@IsTest(isParallel=true)
private class AccountServiceTest {
    private static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private static fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(
        fflib_ISObjectUnitOfWork.class
    );
    private static IAccounts domainMock = (IAccounts) mocks.mock(IAccounts.class);
    private static IAccountsSelector selectorMock = (IAccountsSelector) mocks.mock(
        IAccountsSelector.class
    );

    private static void mockApplication() {
        Application.UnitOfWork.setMock(uowMock);
        Application.Domain.setMock(domainMock);
        Application.Selector.setMock(selectorMock);
    }

    @IsTest
    static void testGet() {
        // given
        String uuid = '2fc1f8b1-2ca1-4e5c-a942-d31adb9f7724';
        List<Account> accList = new List<Account>{ new Account(Name = 'Test', UUID__c = uuid) };

        mocks.startStubbing();
        mocks.when(domainMock.getType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectByUuid(uuid)).thenReturn(accList.get(0));
        mocks.stopStubbing();
        mockApplication();

        // When
        AccountService.get(uuid);

        // Then
        ((IAccountsSelector) mocks.verify(selectorMock)).selectByUuid(uuid);
    }

    @IsTest
    static void testInsertAccount() {
        // given
        Account acc = new Account(Name = 'Test');
        Contact cont = new Contact(FirstName = 'Test', LastName = 'Test');
        mockApplication();

        // When
        AccountService.insertAccount(acc, new List<Contact>{ cont });

        // Then
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).commitWork();
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock)).registerNew(acc);
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .registerNew(cont, Contact.AccountId, acc);
    }
}
