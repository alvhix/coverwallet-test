@SuppressWarnings('PMD.FieldNamingConventions')
public class AccountDto {
    public List<Accounts> accounts;

    public class Accounts {
        public final String uuid;
        public final String company_name;
        public final Decimal annual_revenue;
        public final Integer number_employees;
        public List<Contacts> contacts;
    }

    public class Contacts {
        public final String first_name;
        public final String last_name;
        public final String email;
    }
}
