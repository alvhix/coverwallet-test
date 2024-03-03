public interface IContactService {
    void upsertContacts(List<Contact> contacts, List<Account> insertedAccounts);
    List<Contact> getContacts(List<Id> accounts, Integer recordsPerPage, Integer page);
    Integer getNumberOfContacts(List<Id> accounts);
}
