public inherited sharing class ContactServiceImpl implements IContactService {
    private IAccountsSelector accountSelector;
    public ContactServiceImpl() {
        this.accountSelector = (IAccountsSelector) Application.Selector.newInstance(
            Account.getSObjectType()
        );
    }

    public void upsertContacts(List<Contact> contacts, List<Account> insertedAccounts) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        IContacts contactDomain = (IContacts) Application.Domain.newInstance(contacts);
        contactDomain.setAccountId(insertedAccounts);
        ContactUpsertWork contactUpsertWork = new ContactUpsertWork();
        contactUpsertWork.registerContactUpsert(contacts);

        uow.registerWork(contactUpsertWork);

        uow.commitWork();
    }

    public List<Contact> getContacts(
        List<Id> accounts,
        Integer recordsPerPage,
        Integer page
    ) {
        Integer offset = recordsPerPage * (page - 1);
        return [
            SELECT FirstName, LastName, Email
            FROM Contact
            WHERE AccountId IN :accounts
            LIMIT :recordsPerPage
            OFFSET :offset
        ];
    }

    public Integer getNumberOfContacts(List<Id> accounts) {
        return [SELECT COUNT() FROM Contact WHERE AccountId IN :accounts];
    }
}
