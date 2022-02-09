public inherited sharing class ContactService {
    public static Database.UpsertResult[] upsertContactsByEmail(
        List<Account> insertedAccounts,
        List<AccountWrapper.Accounts> accountsWrapper
    ) {
        Map<String, Account> insertedAccountsMap = new Map<String, Account>();
        for (Account acct : insertedAccounts) {
            insertedAccountsMap.put(acct.Uuid__c, acct);
        }

        List<Contact> contacts = new List<Contact>();
        for (AccountWrapper.Accounts acct : accountsWrapper) {
            Account insertedAccount = insertedAccountsMap.get(acct.uuid);
            for (AccountWrapper.Contacts cont : acct.contacts) {
                Contact newCont = new Contact(
                    AccountId = insertedAccount.Id,
                    FirstName = cont.first_name,
                    LastName = cont.last_name,
                    Email = cont.email
                );
                contacts.add(newCont);
            }
        }

        return Database.upsert(contacts, Contact.Fields.Email, true);
    }

    public static Database.DeleteResult[] deleteLeftContacts(
        Set<Id> accountIds,
        Set<Id> contactIds
    ) {
        List<Contact> allContacts = [
            SELECT Id
            FROM Contact
            WHERE AccountId IN :accountIds
        ];
        List<Contact> contactsToDelete = new List<Contact>();

        for (Contact cont : allContacts) {
            if (!contactIds.contains(cont.Id)) {
                contactsToDelete.add(cont);
            }
        }

        return Database.delete(contactsToDelete);
    }

    public static void setAgentOwnership(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact cont : contacts) {
            if (cont.AccountId != null) {
                accountIds.add(cont.AccountId);
            }
        }

        Map<Id, Account> relatedAccounts = new Map<Id, Account>(
            [SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]
        );

        for (Contact cont : contacts) {
            Account relatedAccount = relatedAccounts.get(cont.AccountId);
            cont.OwnerId = relatedAccount.OwnerId;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(
        List<Id> accounts,
        Integer recordsPerPage,
        Integer page
    ) {
        Integer offset = recordsPerPage * (page - 1);
        return [
            SELECT FirstName, LastName, Email
            FROM Contact
            WHERE AccountId IN :accounts
            LIMIT :recordsPerPage
            OFFSET :offset
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNumberOfRecords(List<Id> accounts) {
        return [SELECT COUNT() FROM Contact WHERE AccountId IN :accounts];
    }
}
