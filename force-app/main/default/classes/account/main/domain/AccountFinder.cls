public class AccountFinder {
    private final AccountRepository accountRepository;

    public AccountFinder(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public List<Account> find(Set<Id> accountId) {
        if (accountId.size() == 0) {
            return new List<Account>();
        }
        return accountRepository.get(accountId);
    }

    public Account find(String uuid) {
        Account account = accountRepository.get(uuid);

        if (account == null) {
            throw new AccountNotFoundException(uuid);
        }

        return account;
    }
}
