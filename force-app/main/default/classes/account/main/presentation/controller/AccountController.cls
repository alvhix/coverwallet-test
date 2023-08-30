@RestResource(urlMapping='/account/*')
global without sharing class AccountController {
    private static IAccountService accService = AccountService.newInstance();

    @HttpGet
    global static void getAccounts() {
        String uuid = RestContext.request.requestURI.substring(
            RestContext.request.requestURI.lastIndexOf('/') + 1
        );
        try {
            ok(accService.get(uuid));
        } catch (AccountNotFoundException ex) {
            notFound(ex.getMessage());
        }
    }

    @HttpPost
    global static void insertAccount() {
        String payload = RestContext.request.requestBody.toString();
        AccountDto accountDto = (AccountDto) JSON.deserializeStrict(payload, AccountDto.class);
        accService.insertAccount(
            new Account(
                UUID__c = accountDto.uuid,
                Name = accountDto.company_name,
                AnnualRevenue = accountDto.annual_revenue,
                NumberOfEmployees = accountDto.number_employees
            ),
            contacts(accountDto.contacts)
        );

        ok('Account was inserted successfully');
    }

    private static List<Contact> contacts(List<AccountDto.Contacts> contactsDto) {
        List<Contact> contacts = new List<Contact>();
        for (AccountDto.Contacts contactDto : contactsDto) {
            contacts.add(
                new Contact(
                    FirstName = contactDto.first_name,
                    LastName = contactDto.last_name,
                    Email = contactDto.email
                )
            );
        }
        return contacts;
    }

    @HttpPut
    global static void updateAccount() {
        String payload = RestContext.request.requestBody.toString();
        AccountDto accountDto = (AccountDto) JSON.deserializeStrict(payload, AccountDto.class);

        ok('Account was updated successfully');
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
}
