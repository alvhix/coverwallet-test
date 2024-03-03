public with sharing class ContactService {
    public static void upsertContacts(List<Contact> contacts, List<Account> insertedAccounts) {
        service().upsertContacts(contacts, insertedAccounts);
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(
        List<Id> accounts,
        Integer recordsPerPage,
        Integer page
    ) {
        return service().getContacts(accounts, recordsPerPage, page);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNumberOfContacts(List<Id> accounts) {
        return service().getNumberOfContacts(accounts);
    }

    private static IContactService service() {
        return (IContactService) Application.Service.newInstance(IContactService.class);
    }
}
