public class ContactUpsertWork implements fflib_SObjectUnitOfWork.IDoWork {
    public Database.UpsertResult[] results { get; private set; }
    private List<Contact> contacts;

    public ContactUpsertWork() {
        contacts = new List<Contact>();
    }

    public void registerContactUpsert(Contact record) {
        contacts.add(record);
    }

    public void registerContactUpsert(List<Contact> records) {
        contacts.addAll(records);
    }

    public void doWork() {
        results = Database.upsert(contacts, Contact.ExternalId__c, false);
    }
}
