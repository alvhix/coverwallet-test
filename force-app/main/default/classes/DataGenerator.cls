public inherited sharing class DataGenerator implements HttpCalloutMock {
    private HttpRequest request;

    public DataGenerator() {
        this.request = new HttpRequest();
        this.request.setEndpoint(
            URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/apexrest/Account/'
        );
        this.request.setMethod('PUT');
        this.request.setHeader(
            'Content-Type',
            'application/json;charset=UTF-8'
        );
        this.request.setHeader(
            'Authorization',
            'Bearer ' + UserInfo.getSessionId()
        );
    }

    public HttpResponse generateAccounts(Integer recordsToInsert) {
        List<AccountWrapper.Accounts> accounts = new List<AccountWrapper.Accounts>();
        Integer records = recordsToInsert > 1000 ? 1000 : recordsToInsert;

        for (Integer i = 0; i < records; i++) {
            String name = getName();
            String uuid = getUuid();

            List<AccountWrapper.Contacts> contacts = new List<AccountWrapper.Contacts>();
            AccountWrapper.Accounts acct = new AccountWrapper.Accounts();
            acct.uuid = uuid;
            acct.company_name = name;
            acct.annual_revenue = getAnnualRevenue();
            acct.number_employees = getEmployees();

            AccountWrapper.Contacts cnt = new AccountWrapper.Contacts();
            cnt.first_name = uuid.substring(0, 6);
            cnt.last_name = uuid.substring(7, 13);
            cnt.email = uuid.substring(0, 6) + '@' + name + '.com';
            contacts.add(cnt);
            acct.contacts = contacts;

            accounts.add(acct);
        }

        Http http = new Http();
        this.request.setTimeout(120000);
        this.request.setBody('{ "accounts":' + JSON.serialize(accounts) + '}');

        return http.send(this.request);
    }

    private static Integer getEmployees() {
        return Integer.valueOf(Math.random() * 200 + 1);
    }

    private static Decimal getAnnualRevenue() {
        return Decimal.valueOf(Math.random() * 175000);
    }

    private static String getName() {
        Blob b = Crypto.GenerateAESKey(128);
        String result = 'Test-' + EncodingUtil.convertToHex(b);

        return result;
    }

    private static String getUuid() {
        String uuid1 = String.valueOf(Integer.valueOf(Math.random() * 123456))
            .leftPad(6, '0');
        String uuid2 = String.valueOf(Integer.valueOf(Math.random() * 123456))
            .leftPad(6, '0');

        return uuid1 + '-' + uuid2;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);
        return response;
    }
}
