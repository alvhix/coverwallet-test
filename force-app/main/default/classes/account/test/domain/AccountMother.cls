public class AccountMother {
    public static Account random() {
        return Account.create(
            new Uuid().getValue(),
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(5000, 120000),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );
    }

    public static Account copyOf(Id salesforceId) {
        Account result = Account.create(
            new Uuid().getValue(),
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(5000, 120000),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );
        result.setSalesforceId(salesforceId);

        return result;
    }

    public static Account copyOf(String uuid) {
        Account result = Account.create(
            uuid,
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(5000, 120000),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );

        return result;
    }

    public static Account lowPriorityAccount() {
        return Account.create(
            new Uuid().getValue(),
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(0, Integer.valueOf(Label.Account_Low_Revenue)),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );
    }

    public static Account mediumPriorityAccount() {
        return Account.create(
            new Uuid().getValue(),
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(
                Integer.valueOf(Label.Account_Low_Revenue),
                Integer.valueOf(Label.Account_Medium_Revenue)
            ),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );
    }

    public static Account highPriorityAccount() {
        return Account.create(
            new Uuid().getValue(),
            TestGenerator.randomString(8),
            TestGenerator.randomDecimal(
                Integer.valueOf(Label.Account_Medium_Revenue),
                Integer.valueOf(Label.Account_Medium_Revenue) +
                Integer.valueOf(Label.Account_Low_Revenue)
            ),
            TestGenerator.randomInteger(1, 150),
            ContactMother.random()
        );
    }
}
