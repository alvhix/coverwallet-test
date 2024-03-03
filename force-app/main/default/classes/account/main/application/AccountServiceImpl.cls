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

    
    public List<Account> getAccounts(
        String name,
        Integer recordsPerPage,
        Integer page
    ) {
        Integer offset = recordsPerPage * (page - 1);
        String search = '%' + name + '%';

        return [
            SELECT
                Name,
                AnnualRevenue,
                NumberOfEmployees,
                Priority__c,
                UUID__c
            FROM Account
            WHERE Name LIKE :search
            LIMIT :recordsPerPage
            OFFSET :offset
        ];
    }

    public Integer getNumberOfAccounts(String name) {
        String search = '%' + name + '%';

        return [SELECT COUNT() FROM Account WHERE Name LIKE :search];
    }

}
