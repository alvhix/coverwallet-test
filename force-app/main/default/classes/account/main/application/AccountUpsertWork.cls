public class AccountUpsertWork implements fflib_SObjectUnitOfWork.IDoWork {
    public Database.UpsertResult[] results { get; private set; }
    private List<Account> accounts;

    public AccountUpsertWork() {
        accounts = new List<Account>();
    }

    public void registerAccountUpsert(Account record) {
        accounts.add(record);
    }

    public void registerAccountUpsert(List<Account> records) {
        accounts.addAll(records);
    }

    public void doWork() {
        results = Database.upsert(accounts, Account.UUID__c, false);
    }
}
