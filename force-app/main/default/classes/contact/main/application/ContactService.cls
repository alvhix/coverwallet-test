public with sharing class ContactService {
    public static void upsertContacts(List<Contact> contacts, List<Account> insertedAccounts) {
        service().upsertContacts(contacts, insertedAccounts);
    }

    private static IContactService service() {
        return (IContactService) Application.Service.newInstance(IContactService.class);
    }
}
