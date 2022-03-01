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
        List<AccountWrapper.Accounts> accountsWrapper = obj.accounts;

        // Upsert accounts by uuid
        Database.UpsertResult[] accountsResult = AccountService.upsertAccountsByUuid(
            accountsWrapper
        );

        // Upsert contacts by email
        Database.UpsertResult[] contactsResult = ContactService.upsertContactsByEmail(
            accountsResult,
            accountsWrapper
        );

        // Delete the left contacts (Optional)
        Database.DeleteResult[] deletedContacts = ContactService.deleteLeftContacts(
            accountsResult,
            contactsResult
        );

        // Log the results
        System.debug(accountsResult);
        System.debug(contactsResult);
        System.debug(deletedContacts);
    }
}
