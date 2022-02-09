public inherited sharing class AccountService {
    public static Database.UpsertResult[] upsertAccountsByUuid(
        List<AccountWrapper.Accounts> accountsWrapper
    ) {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        for (AccountWrapper.Accounts acct : accountsWrapper) {
            Account newAcc = new Account(
                Name = acct.company_name,
                Uuid__c = acct.uuid,
                AnnualRevenue = acct.annual_revenue,
                NumberOfEmployees = acct.number_employees
            );
            accounts.add(newAcc);
        }

        // Upsert based on Uuid__c field
        return Database.upsert(accounts, Account.Fields.Uuid__c, true);
    }

    public static void setAccountPriority(List<Account> accounts) {
        for (Account acct : accounts) {
            if (
                acct.AnnualRevenue >= 0 &&
                acct.AnnualRevenue <= Integer.valueOf(Label.Account_Low_Revenue)
            ) {
                acct.CustomerPriority__c = 'Low';
            } else if (
                acct.AnnualRevenue >
                Integer.valueOf(Label.Account_Low_Revenue) &&
                acct.AnnualRevenue <=
                Integer.valueOf(Label.Account_Medium_Revenue)
            ) {
                acct.CustomerPriority__c = 'Medium';
            } else if (
                acct.AnnualRevenue >
                Integer.valueOf(Label.Account_Medium_Revenue)
            ) {
                acct.CustomerPriority__c = 'High';
            }
        }
    }

    public static void setAgentOwnership(List<Account> accounts) {
        for (Account acct : accounts) {
            switch on acct.CustomerPriority__c {
                when 'Low' {
                    acct.OwnerId = Label.Agent_Low_Priority;
                }
                when 'Medium' {
                    acct.OwnerId = Label.Agent_Medium_Priority;
                }
                when 'High' {
                    acct.OwnerId = Label.Agent_High_Priority;
                }
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(
        String name,
        Integer recordsPerPage,
        Integer page
    ) {
        Integer offset = recordsPerPage * (page - 1);
        String search = '%' + name + '%';

        return [
            SELECT
                Name,
                AnnualRevenue,
                NumberOfEmployees,
                CustomerPriority__c,
                Uuid__c
            FROM Account
            WHERE Name LIKE :search
            LIMIT :recordsPerPage
            OFFSET :offset
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNumberOfRecords(String name) {
        String search = '%' + name + '%';

        return [SELECT COUNT() FROM Account WHERE Name LIKE :search];
    }
}
