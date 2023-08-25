public inherited sharing class ContactService implements TriggerService {
    private AccountRepository accountRepository;
    private AccountFinder accountFinder;

    public ContactService() {
    }

    public ContactService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
        this.accountFinder = new AccountFinder(accountRepository);
    }

    public TriggerService init(Type accountRepository) {
        return new ContactService((AccountRepository) accountRepository.newInstance());
    }

    public void setAgentOwnership(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact contact : contacts) {
            accountIds.add(contact.accountId());
        }

        List<Account> accounts = accountFinder.find(accountIds);
        for (Contact contact : contacts) {
            for (Account account : accounts) {
                if (contact.accountId() == account.salesforceId()) {
                    contact.setAgentOwnership(account.ownerId());
                }
            }
        }
    }

    public void beforeInsert(List<Object> records) {
        List<Contact> contacts = castContacts(records);
        setAgentOwnership(contacts);
    }

    public void afterInsert(List<Object> records) {
    }

    public void beforeUpdate(List<Object> records, Map<Id, Object> oldMap) {
        List<Contact> contacts = castContacts(records);
        setAgentOwnership(contacts);
    }

    public void afterUpdate(List<Object> records, List<Object> oldRecords) {
    }

    public void beforeDelete(Map<Id, Object> oldMap) {
    }

    public void afterDelete(List<Object> oldRecords) {
    }

    public void afterUndelete(List<Object> records) {
    }

    private List<Contact> castContacts(List<Object> contactRecords) {
        List<Contact> contacts = new List<Contact>();
        for (Object record : contactRecords) {
            contacts.add((Contact) record);
        }
        return contacts;
    }
}
