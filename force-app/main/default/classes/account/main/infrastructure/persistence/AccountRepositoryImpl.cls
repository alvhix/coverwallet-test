public inherited sharing class AccountRepositoryImpl implements AccountRepository {
    private AccountMapper accountMapper;
    private ContactMapper contactMapper;

    public AccountRepositoryImpl() {
        this.accountMapper = new AccountMapper();
        this.contactMapper = new ContactMapper();
    }

    public Account get(Id salesforceId) {
        List<Schema.Account> account = [
            SELECT
                Id,
                Name,
                AnnualRevenue,
                NumberOfEmployees,
                Priority__c,
                UUID__c,
                OwnerId,
                (SELECT Id, FirstName, LastName, Email, AccountId, OwnerId FROM Contacts)
            FROM Account
            WHERE Id = :salesforceId
        ];

        if (account.isEmpty()) {
            return null;
        }

        return (Account) accountMapper.mapToDomain(account).get(0);
    }

    public Account get(String uuid) {
        List<Schema.Account> account = [
            SELECT
                Id,
                Name,
                AnnualRevenue,
                NumberOfEmployees,
                Priority__c,
                UUID__c,
                OwnerId,
                (SELECT Id, FirstName, LastName, Email, AccountId, OwnerId FROM Contacts)
            FROM Account
            WHERE UUID__c = :uuid
        ];

        if (account.isEmpty()) {
            return null;
        }

        return (Account) accountMapper.mapToDomain(account).get(0);
    }

    public List<Account> get(Set<Id> salesforceIds) {
        List<Schema.Account> accountEntities = [
            SELECT
                Id,
                Name,
                AnnualRevenue,
                NumberOfEmployees,
                Priority__c,
                UUID__c,
                OwnerId,
                (SELECT Id, FirstName, LastName, Email, AccountId, OwnerId FROM Contacts)
            FROM Account
            WHERE Id IN :salesforceIds
        ];

        return (List<Account>) accountMapper.mapToDomain(accountEntities);
    }

    public Id insertAccount(Account account) {
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Schema.Account.getSObjectType(),
                Schema.Contact.getSObjectType()
            }
        );

        Schema.Account accountEntity = (Schema.Account) accountMapper.mapToEntity(
                new List<Object>{ account }
            )
            .get(0);
        uow.registerNew(accountEntity);

        List<Schema.Contact> contacts = contactMapper.mapToEntity(
            account.contacts(),
            accountEntity.Id
        );
        for (Schema.Contact contact : contacts) {
            uow.registerNew(contact, Schema.Contact.AccountId, accountEntity);
        }

        uow.commitWork();

        return accountEntity.Id;
    }

    public Id updateAccount(Account account, Account existingAccount) {
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Schema.Account.getSObjectType(),
                Schema.Contact.getSObjectType()
            }
        );
        account.setSalesforceId(existingAccount.salesforceId());

        Schema.Account accountEntity = (Schema.Account) accountMapper.mapToEntity(
                new List<Object>{ account }
            )
            .get(0);
        uow.registerDirty(accountEntity);

        List<Schema.Contact> contacts = contactMapper.mapToEntity(
            account.contacts(),
            accountEntity.Id
        );
        for (Schema.Contact contact : contacts) {
            uow.registerNew(contact, Schema.Contact.AccountId, accountEntity);
        }

        uow.commitWork();

        return accountEntity.Id;
    }
}
