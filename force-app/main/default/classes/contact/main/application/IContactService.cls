public interface IContactService {
    void upsertContacts(List<Contact> contacts, List<Account> insertedAccounts);
}
