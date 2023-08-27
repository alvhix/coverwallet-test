public class AccountMapper implements DomainMapper {
    private ContactMapper contactMapper;

    public AccountMapper() {
        this.contactMapper = new ContactMapper();
    }

    private Account mapToDomain(Schema.Account account) {
        return new Account(
            account.Id,
            account.UUID__c,
            account.Name,
            account.AnnualRevenue,
            account.NumberOfEmployees,
            account.Priority__c,
            account.OwnerId,
            contactMapper.mapToDomain(account.Contacts)
        );
    }

    private Schema.Account mapToEntity(Account account) {
        return new Schema.Account(
            Id = account.salesforceId(),
            UUID__c = account.uuid(),
            Name = account.companyName(),
            AnnualRevenue = account.annualRevenue(),
            NumberOfEmployees = account.numberEmployees(),
            Priority__c = account.priority(),
            OwnerId = account.ownerId()
        );
    }

    private Schema.Account mapToEntity(Account account, Schema.Account accountEntity) {
        accountEntity.Id = account.salesforceId();
        accountEntity.UUID__c = account.uuid();
        accountEntity.Name = account.companyName();
        accountEntity.AnnualRevenue = account.annualRevenue();
        accountEntity.NumberOfEmployees = account.numberEmployees();
        accountEntity.Priority__c = account.priority();
        accountEntity.OwnerId = account.ownerId();
        return accountEntity;
    }

    public List<Object> mapToDomain(List<SObject> records) {
        List<Account> accounts = new List<Account>();

        for (SObject record : records) {
            accounts.add(mapToDomain((Schema.Account) record));
        }

        return accounts;
    }

    public List<SObject> mapToEntity(List<Object> domainRecords, List<SObject> records) {
        for (Integer i = 0; i < records.size(); i++) {
            Schema.Account accountEntity = (Schema.Account) records[i];

            mapToEntity((Account) domainRecords[i], accountEntity);
        }

        return records;
    }

    public List<SObject> mapToEntity(List<Object> domainRecords) {
        List<Schema.Account> accounts = new List<Schema.Account>();

        for (Object domainRecord : domainRecords) {
            accounts.add(mapToEntity((Account) domainRecord));
        }

        return accounts;
    }
}
