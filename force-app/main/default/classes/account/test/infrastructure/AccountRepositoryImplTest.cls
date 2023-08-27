@isTest
public class AccountRepositoryImplTest {
    private final static AccountRepository accountRepository = new AccountRepositoryImpl();

    @isTest
    static void testInsert() {
        // arrange
        Account account = AccountMother.random();

        // act
        Id accountId = accountRepository.insertAccount(account);

        // assert
        Assert.isTrue(String.isNotBlank(accountId));
    }

    @isTest
    static void testGetById() {
        // arrange
        Account account = AccountMother.random();
        Id accountId = accountRepository.insertAccount(account);

        // act
        Account result = accountRepository.get(accountId);

        // assert
        Assert.isNotNull(result);
    }

    @isTest
    static void testGetByUuid() {
        // arrange
        Account account = AccountMother.random();
        accountRepository.insertAccount(account);

        // act
        Account result = accountRepository.get(account.uuid());

        // assert
        Assert.isNotNull(result);
    }

    @isTest
    static void testUpdateAccount() {
        // arrange
        Account account = AccountMother.random();
        Id insertedAccount = accountRepository.insertAccount(account);
        account.setSalesforceId(insertedAccount);

        Account updatedAccount = AccountMother.copyOf(account.uuid());

        // act
        Id accountId = accountRepository.updateAccount(updatedAccount, account);

        // assert
        Assert.isTrue(String.isNotBlank(accountId));
    }
}
