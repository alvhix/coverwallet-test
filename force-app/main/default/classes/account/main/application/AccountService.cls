public inherited sharing class AccountService implements TriggerService {
    private AccountRepository accountRepository;
    private AccountFinder accountFinder;

    public AccountService() {
    }

    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
        this.accountFinder = new AccountFinder(accountRepository);
    }

    public TriggerService init(Type accountRepository) {
        return new AccountService((AccountRepository) accountRepository.newInstance());
    }

    public Account get(Id salesforceId) {
        return accountRepository.get(salesforceId);
    }

    public Account get(String uuid) {
        return accountFinder.find(uuid);
    }

    public Id insertAccount(Account account) {
        return accountRepository.insertAccount(account);
    }

    public Id updateAccount(Account account) {
        Account existingAccount = accountFinder.find(account.uuid());

        return accountRepository.updateAccount(account, existingAccount);
    }

    public void beforeInsert(List<Object> records) {
        List<Account> accounts = castAccounts(records);
        for (Account account : accounts) {
            account.setAccountPriority();
            account.setAgentOwnership();
        }
    }

    public void afterInsert(List<Object> records) {
    }

    public void beforeUpdate(List<Object> records, Map<Id, Object> oldMap) {
        List<Account> accounts = castAccounts(records);
        for (Account account : accounts) {
            account.setAccountPriority();
            account.setAgentOwnership();
        }
    }

    public void afterUpdate(List<Object> records, List<Object> oldRecords) {
    }

    public void beforeDelete(Map<Id, Object> oldMap) {
    }

    public void afterDelete(List<Object> oldRecords) {
    }

    public void afterUndelete(List<Object> records) {
    }

    private List<Account> castAccounts(List<Object> accountRecords) {
        List<Account> accounts = new List<Account>();
        for (Object record : accountRecords) {
            accounts.add((Account) record);
        }
        return accounts;
    }
}
