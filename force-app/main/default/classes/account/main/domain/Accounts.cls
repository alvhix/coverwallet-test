public class Accounts extends fflib_SObjectDomain {
    public final static String LOW_PRIORITY = 'Low';
    public final static String MEDIUM_PRIORITY = 'Medium';
    public final static String HIGH_PRIORITY = 'High';

    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public override void onBeforeInsert() {
        List<Account> accounts = (List<Account>) super.Records;
        setAccountPriority(accounts);
        setAgentOwnership(accounts);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        List<Account> accounts = (List<Account>) super.Records;
        setAccountPriority(accounts);
        setAgentOwnership(accounts);
    }

    public void setAccountPriority(List<Account> accounts) {
        Integer lowRevenue = Integer.valueOf(Label.Account_Low_Revenue);
        Integer mediumRevenue = Integer.valueOf(Label.Account_Medium_Revenue);

        for (Account account : accounts) {
            if (account.AnnualRevenue <= lowRevenue) {
                account.Priority__c = LOW_PRIORITY;
            } else if (account.AnnualRevenue <= mediumRevenue) {
                account.Priority__c = MEDIUM_PRIORITY;
            } else if (account.AnnualRevenue > mediumRevenue) {
                account.Priority__c = HIGH_PRIORITY;
            }
        }
    }

    public void setAgentOwnership(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.Priority__c == LOW_PRIORITY) {
                account.OwnerId = Label.Agent_Low_Priority;
            } else if (account.Priority__c == MEDIUM_PRIORITY) {
                account.OwnerId = Label.Agent_Medium_Priority;
            } else if (account.Priority__c == HIGH_PRIORITY) {
                account.OwnerId = Label.Agent_High_Priority;
            }
        }
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
}
