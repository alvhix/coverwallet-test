public inherited sharing class ContactService implements IContactService {
    private IAccountSelector accountSelector;
    public ContactService() {
        this.accountSelector = (IAccountSelector) Application.Selector.newInstance(
            Contact.getSObjectType()
        );
    }

    public void setAgentOwnership(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact contact : contacts) {
            accountIds.add(contact.AccountId);
        }

        Map<Id, Account> accounts = new Map<Id, Account>(
            this.accountSelector.selectById(accountIds)
        );

        for (Contact contact : contacts) {
            Id ownerId = accounts.get(contact.AccountId).OwnerId;
            contact.OwnerId = ownerId;
        }
    }
}
