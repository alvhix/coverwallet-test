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
}
