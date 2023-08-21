public inherited sharing class AccountWrapper {
    public List<Accounts> accounts;

    public class Contacts {
        public String first_name;
        public String last_name;
        public String email;
    }

    public class Accounts {
        public String uuid;
        public String company_name;
        public Decimal annual_revenue;
        public Integer number_employees;
        public List<Contacts> contacts;
    }

    public static AccountWrapper parse(String json) {
        return (AccountWrapper) System.JSON.deserialize(
            json,
            AccountWrapper.class
        );
    }
}
