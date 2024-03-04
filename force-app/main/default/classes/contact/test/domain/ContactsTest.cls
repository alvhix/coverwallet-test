@IsTest(isParallel=true)
private class ContactsTest {
    private static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private static fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(
        fflib_ISObjectUnitOfWork.class
    );
    private static IContacts domainMock = (IContacts) mocks.mock(IContacts.class);
    private static IAccountsSelector selectorMock = (IAccountsSelector) mocks.mock(
        IAccountsSelector.class
    );

    private static void mockApplication() {
        Application.UnitOfWork.setMock(uowMock);
        Application.Domain.setMock(domainMock);
        Application.Selector.setMock(selectorMock);
    }

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

    @isTest
    static void testSetAgentOwnership() {
        // given
        Account acc = AccountMother.randomWithId(null);
        acc.OwnerId = Label.Agent_Medium_Priority;
        List<Contact> contacts = ContactMother.byAccountId(acc.Id);

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectById((new Set<Id>{ acc.Id })))
            .thenReturn(new List<Account>{ acc });
        mocks.stopStubbing();
        mockApplication();

        // when
        IContacts domain = (IContacts) Application.Domain.newInstance(contacts);
        domain.setAgentOwnership();

        // then
        Assert.areEqual(acc.OwnerId, contacts.get(0).OwnerId);
    }

    @IsTest
    static void testSetAccountId() {
        // given
        String uuid = '89b42fe0-3fe6-46cb-b2a5-cc7640051748';
        Account acc = AccountMother.randomWithId(uuid);
        List<Contact> contacts = ContactMother.byUuid(uuid);

        // when
        Contacts domain = (Contacts) Application.Domain.newInstance(contacts);
        domain.setAccountId(new List<Account>{ acc });

        // then
        Assert.areEqual(acc.Id, contacts.get(0).AccountId);
    }
}
