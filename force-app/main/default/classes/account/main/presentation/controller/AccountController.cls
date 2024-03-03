@RestResource(urlMapping='/account/*')
global without sharing class AccountController {
    @HttpGet
    global static void getAccount() {
        String uuid = RestContext.request.requestURI.substring(
            RestContext.request.requestURI.lastIndexOf('/') + 1
        );
        try {
            ok(AccountService.get(uuid));
        } catch (AccountNotFoundException ex) {
            notFound(ex.getMessage());
        }
    }

    @HttpPut
    global static void upsertAccountsAndRelatedContacts() {
        String payload = RestContext.request.requestBody.toString();
        AccountDto accountDto = (AccountDto) JSON.deserializeStrict(payload, AccountDto.class);

        try {
            List<Account> insertedAccounts = AccountService.upsertAccounts(accounts(accountDto.accounts));
            ContactService.upsertContacts(contacts(accountDto.accounts), insertedAccounts);

            ok('Request successfully processed');
        } catch (Exception ex) {
            internalServerError(ex.getMessage());
        }
    }

    private static List<Account> accounts(List<AccountDto.Accounts> accountsDto) {
        List<Account> accountsResult = new List<Account>();

        for (AccountDto.Accounts acc : accountsDto) {
            accountsResult.add(
                new Account(
                    UUID__c = acc.uuid,
                    Name = acc.company_name,
                    AnnualRevenue = acc.annual_revenue,
                    NumberOfEmployees = acc.number_employees
                )
            );
        }
        return accountsResult;
    }

    private static List<Contact> contacts(List<AccountDto.Accounts> accountsDto) {
        List<Contact> contacts = new List<Contact>();
        for (AccountDto.Accounts acc : accountsDto) {
            for (AccountDto.Contacts cont : acc.contacts) {
                contacts.add(
                    new Contact(
                        FirstName = cont.first_name,
                        LastName = cont.last_name,
                        Email = cont.email,
                        ExternalId__c = acc.uuid + cont.email
                    )
                );
            }
        }
        return contacts;
    }

    private static void ok(Object responseBody) {
        RestResponse res = RestContext.response;

        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
    }

    private static void ok(String message) {
        RestResponse res = RestContext.response;
        AccountResponseDto responseDto = new AccountResponseDto();
        responseDto.success = true;
        responseDto.message = message;

        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serializePretty(responseDto));
    }

    private static void notFound(String message) {
        RestResponse res = RestContext.response;
        AccountResponseDto responseDto = new AccountResponseDto();
        responseDto.success = false;
        responseDto.message = message;

        res.statusCode = 404;
        res.responseBody = Blob.valueOf(JSON.serializePretty(responseDto));
    }

    private static void internalServerError(String message) {
        RestResponse res = RestContext.response;
        AccountResponseDto responseDto = new AccountResponseDto();
        responseDto.success = false;
        responseDto.message = message;
    
        res.statusCode = 500;
        res.responseBody = Blob.valueOf(JSON.serializePretty(responseDto));
    }
}
