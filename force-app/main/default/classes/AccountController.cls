@RestResource(urlMapping='/Account/*')
global without sharing class AccountController {
    @HttpPut
    global static void createAccount() {
        // Receive JSON request
        RestRequest req = RestContext.request;
        String json = req.requestBody.toString();
        System.debug(json);

        // Parse JSON to AccountWrapper object
        AccountWrapper obj = AccountWrapper.parse(json);
        List<AccountWrapper.Accounts> accounts = obj.accounts;

        // Upsert accounts by uuid
        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accounts
        );

        // Get the inserted accounts
        Set<Id> accountIds = new Set<Id>();
        for (Database.UpsertResult accountResult : accountsResult) {
            accountIds.add(accountResult.getId());
        }
        List<Account> insertedAccounts = [
            SELECT Id, Uuid__c
            FROM Account
            WHERE Id IN :accountIds
        ];

        // Upsert contacts by email
        Database.UpsertResult[] contactsResult = ContactService.upsertContactsByEmail(
            insertedAccounts,
            accounts
        );

        // Delete the left contacts (Optional)
        Set<Id> contactIds = new Set<Id>();
        for (Database.UpsertResult contactResult : contactsResult) {
            contactIds.add(contactResult.getId());
        }

        Database.DeleteResult[] deletedContacts = ContactService.deleteLeftContacts(
            accountIds,
            contactIds
        );

        // Log the results
        System.debug(accountsResult);
        System.debug(contactsResult);
        System.debug(deletedContacts);
    }
}
