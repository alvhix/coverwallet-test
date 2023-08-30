public class AccountMother {
    public static Account random() {
        return new Account(
            UUID__c = new Uuid().getValue(),
            Name = TestGenerator.randomString(8),
            AnnualRevenue = TestGenerator.randomDecimal(5000, 120000),
            NumberOfEmployees = TestGenerator.randomInteger(1, 150)
        );
    }

    public static Account lowPriorityAccount() {
        return new Account(
            UUID__c = new Uuid().getValue(),
            Name = TestGenerator.randomString(8),
            AnnualRevenue = TestGenerator.randomDecimal(
                0,
                Integer.valueOf(Label.Account_Low_Revenue)
            ),
            NumberOfEmployees = TestGenerator.randomInteger(1, 150)
        );
    }

    public static Account mediumPriorityAccount() {
        return new Account(
            UUID__c = new Uuid().getValue(),
            Name = TestGenerator.randomString(8),
            AnnualRevenue = TestGenerator.randomDecimal(
                Integer.valueOf(Label.Account_Low_Revenue),
                Integer.valueOf(Label.Account_Medium_Revenue)
            ),
            NumberOfEmployees = TestGenerator.randomInteger(1, 150)
        );
    }

    public static Account highPriorityAccount() {
        return new Account(
            UUID__c = new Uuid().getValue(),
            Name = TestGenerator.randomString(8),
            AnnualRevenue = TestGenerator.randomDecimal(
                Integer.valueOf(Label.Account_Medium_Revenue),
                Integer.valueOf(Label.Account_Medium_Revenue) +
                Integer.valueOf(Label.Account_Low_Revenue)
            ),
            NumberOfEmployees = TestGenerator.randomInteger(1, 150)
        );
    }
}
