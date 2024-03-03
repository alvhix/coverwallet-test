public inherited sharing class AccountServiceImpl implements IAccountService {
    private IAccountsSelector accountSelector;
    public AccountServiceImpl() {
        this.accountSelector = (IAccountsSelector) Application.Selector.newInstance(
            Account.getSObjectType()
        );
    }

    public Account get(String uuid) {
        Account account = accountSelector.selectByUuid(uuid);
        if (account == null) {
            throw new AccountNotFoundException('Account with uuid ' + uuid + ' not found');
        }
        return account;
    }

    public List<Account> upsertAccounts(List<Account> accounts) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        AccountUpsertWork accountUpsertWork = new AccountUpsertWork();
        accountUpsertWork.registerAccountUpsert(accounts);

        uow.registerWork(accountUpsertWork);

        uow.commitWork();

        return accounts;
    }
}
