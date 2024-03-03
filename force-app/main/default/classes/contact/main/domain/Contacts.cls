public class Contacts extends fflib_SObjectDomain implements IContacts {
    public Contacts(List<Account> sObjectList) {
        super(sObjectList);
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
