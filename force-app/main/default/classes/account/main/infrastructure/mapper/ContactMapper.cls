public class ContactMapper implements DomainMapper {
    private Contact mapToDomain(Schema.Contact contact) {
        return new Contact(
            contact.AccountId,
            contact.FirstName,
            contact.LastName,
            contact.Email,
            contact.OwnerId
        );
    }

    private Schema.Contact mapToEntity(Contact contact, Id accountId) {
        return new Schema.Contact(
            AccountId = accountId,
            FirstName = contact.firstName(),
            LastName = contact.lastName(),
            Email = contact.email(),
            OwnerId = contact.ownerId()
        );
    }

    private Schema.Contact mapToEntity(Contact contact, Schema.Contact contactEntity) {
        contactEntity.FirstName = contact.firstName();
        contactEntity.LastName = contact.lastName();
        contactEntity.Email = contact.email();
        contactEntity.AccountId = contact.accountId();
        contactEntity.OwnerId = contact.ownerId();

        return contactEntity;
    }

    public List<Object> mapToDomain(List<SObject> records) {
        List<Object> domainRecords = new List<Object>();

        for (SObject record : records) {
            domainRecords.add(mapToDomain((Schema.Contact) record));
        }

        return domainRecords;
    }

    public List<Contact> mapToDomain(List<Schema.Contact> contacts) {
        List<Contact> domainContacts = new List<Contact>();

        for (Schema.Contact contact : contacts) {
            domainContacts.add(mapToDomain(contact));
        }

        return domainContacts;
    }

    public List<SObject> mapToEntity(List<Object> domainRecords) {
        return null;
    }

    public List<SObject> mapToEntity(List<Object> domainRecords, Id accountId) {
        List<Schema.Contact> contacts = new List<Schema.Contact>();

        for (Object domainRecord : domainRecords) {
            contacts.add(mapToEntity((Contact) domainRecord, accountId));
        }

        return contacts;
    }

    public List<SObject> mapToEntity(List<Object> domainRecords, List<SObject> records) {
        List<Schema.Contact> contacts = new List<Schema.Contact>();

        for (Integer i = 0; i < domainRecords.size(); i++) {
            contacts.add(mapToEntity((Contact) domainRecords[i], (Schema.Contact) records[i]));
        }

        return contacts;
    }
}
