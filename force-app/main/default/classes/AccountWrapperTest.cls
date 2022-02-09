@IsTest
public with sharing class AccountWrapperTest {
    @isTest
    static void testParse() {
        String json =
            '{' +
            '    \"accounts\": [{' +
            '        \"uuid\": \"123456-123456\",' +
            '        \"company_name\": \"Acme Corp.\",' +
            '        \"annual_revenue\": 120000,' +
            '        \"number_employees\": 8,' +
            '        \"contacts\": [{' +
            '            \"first_name\": \"John\",' +
            '            \"last_name\": \"Smith\",' +
            '            \"email\": \"john@acme.com\"' +
            '        }, {' +
            '            \"first_name\": \"Maria\",' +
            '            \"last_name\": \"Doe\",' +
            '            \"email\": \"maria@acme.com\"' +
            '        }]' +
            '    }]' +
            '}';
        AccountWrapper obj = AccountWrapper.parse(json);
        System.assert(
            obj != null,
            'Account JSON has not been parsed to object'
        );
    }
}
