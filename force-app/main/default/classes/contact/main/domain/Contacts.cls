public class Contacts extends fflib_SObjectDomain implements IContacts {
    private IAccountsSelector accountSelector;

    public Contacts(List<Contact> sObjectList) {
        super(sObjectList);
        this.accountSelector = (IAccountsSelector) Application.Selector.newInstance(
            Account.getSObjectType()
        );
    }

    public override void onBeforeInsert() {
        setAgentOwnership();
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        setAgentOwnership();
    }

    public void setAgentOwnership() {
        List<Contact> contacts = (List<Contact>) super.Records;
        Set<Id> accountIds = new Set<Id>();
        for (Contact contact : contacts) {
            accountIds.add(contact.AccountId);
        }

        Map<Id, Account> accounts = new Map<Id, Account>(
            accountSelector.selectById(accountIds)
        );
        System.debug(accounts);
        for (Contact contact : contacts) {
            Id ownerId = accounts.get(contact.AccountId).OwnerId;
            contact.OwnerId = ownerId;
        }
    }

    public void setAccountId(List<Account> accounts) {
        for (Account acc : accounts) {
            for (Contact cont : (List<Contact>) super.Records) {
                if (cont.ExternalId__c.substring(0, 36).equals(acc.UUID__c)) {
                    cont.AccountId = acc.Id;
                }
            }
        }
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Contacts(sObjectList);
        }
    }
}
