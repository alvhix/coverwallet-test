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

    public void insertAccount(Account account, List<Contact> contacts) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        uow.registerNew(account);

        for (Contact cnt : contacts) {
            uow.registerNew(cnt, Contact.AccountId, account);
        }

        uow.commitWork();
    }
}
