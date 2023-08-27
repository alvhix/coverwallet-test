@isTest(IsParallel=true)
public class AccountServiceTest {
    private static Mock accountRepositoryMock = Mock.forType(AccountRepository.class);
    private static AccountService accountService = new AccountService(
        (AccountRepository) accountRepositoryMock.stub
    );

    @isTest
    static void testGetByUUID() {
        // arrange
        Account expectedAccount = AccountMother.random();

        accountRepositoryMock
            .spyOn('get')
            .whenCalledWith(Argument.equals('expectedUUID'))
            .thenReturn(expectedAccount);

        // act
        Account result = accountService.get('expectedUUID');

        // assert
        Assert.areEqual(expectedAccount, result);
    }

    @isTest
    static void testInsertAccount() {
        // arrange
        MethodSpy spy = accountRepositoryMock.spyOn('insertAccount');

        // act
        accountService.insertAccount(AccountMother.random());

        // assert
        Expect.that(spy).hasBeenCalledTimes(1);
    }

    @isTest
    static void testUpdateAccount() {
        // arrange
        Account existingAccount = AccountMother.random();

        MethodSpy getSpy = accountRepositoryMock.spyOn('get');
        getSpy.whenCalledWith(existingAccount.uuid()).thenReturn(existingAccount);
        MethodSpy updateSpy = accountRepositoryMock.spyOn('updateAccount');

        Account account = AccountMother.copyOf(existingAccount.uuid());

        // act
        accountService.updateAccount(account);

        // assert
        Expect.that(updateSpy).hasBeenCalledWith(account, existingAccount);
        Expect.that(updateSpy).hasBeenCalledTimes(1);
    }

    @isTest
    static void testLowPriorityAccount() {
        // arrange
        Account accountMother = AccountMother.lowPriorityAccount();

        // act
        accountService.beforeInsert(new List<Object>{ accountMother });

        // assert
        Assert.areEqual(Account.LOW_PRIORITY, accountMother.priority());
        Assert.areEqual(Label.Agent_Low_Priority, accountMother.ownerId());
    }

    @isTest
    static void testMediumPriorityAccount() {
        // arrange
        Account accountMother = AccountMother.mediumPriorityAccount();

        // act
        accountService.beforeInsert(new List<Object>{ accountMother });

        // assert
        Assert.areEqual(Account.MEDIUM_PRIORITY, accountMother.priority());
        Assert.areEqual(Label.Agent_Medium_Priority, accountMother.ownerId());
    }

    @isTest
    static void testHighPriorityAccount() {
        // arrange
        Account accountMother = AccountMother.highPriorityAccount();

        // act
        accountService.beforeInsert(new List<Object>{ accountMother });

        // assert
        Assert.areEqual(Account.HIGH_PRIORITY, accountMother.priority());
        Assert.areEqual(Label.Agent_High_Priority, accountMother.ownerId());
    }
}
