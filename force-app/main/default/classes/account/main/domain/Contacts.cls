public class Contacts extends fflib_SObjectDomain {
    private IAccountsSelector accountSelector;

    public Contacts(List<Contact> sObjectList) {
        super(sObjectList);
        this.accountSelector = AccountsSelector.newInstance();
    }

    public override void onBeforeInsert() {
        List<Contact> contacts = (List<Contact>) super.Records;
        setAgentOwnership(contacts);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        List<Contact> contacts = (List<Contact>) super.Records;
        setAgentOwnership(contacts);
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

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Contacts(sObjectList);
        }
    }
}
