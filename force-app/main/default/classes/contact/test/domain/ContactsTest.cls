@IsTest(isParallel=true)
private class ContactsTest {
    @IsTest
    static void newInstanceTest() {
        Accounts instanceByRecords = (Accounts) Application.Domain.newInstance(new List<Account>());
    }

    @IsTest
    static void insertAndUpdateOnRecords() {
        // Test insert, update and delete fires off triggers properly
        List<Account> accounts = new List<Account>{
            AccountMother.random(),
            AccountMother.random(),
            AccountMother.random()
        };
        insert accounts;
        update accounts;
        delete accounts;
    }

    @IsTest
    static void testSetAccountId() {
        // given
        String uuid = '89b42fe0-3fe6-46cb-b2a5-cc7640051748';
        Account acc = AccountMother.randomWithId(uuid);
        List<Contact> contacts = ContactMother.byUuid(uuid);

        // when
        Contacts domain = (Contacts) Application.Domain.newInstance(contacts);
        domain.setAccountId(new List<Account>{ acc });

        // then
        Assert.areEqual(acc.Id, contacts.get(0).AccountId);
    }
}
