public inherited sharing class AccountSelector extends fflib_SObjectSelector implements IAccountSelector {
    /* 1. sObjectField list */
    private List<String> additionalSObjectFieldList = new List<String>{
        'Id',
        'Name',
        'AnnualRevenue',
        'Priority__c'
    };

    /* 2. Boilerplate code */
    public static Accounts newInstance() {
        return (Accounts) Application.Selector.newInstance(Account.getSObjectType());
    }

    public Schema.SObjectType getSObjectType() {
        return Account.getSObjectType();
    }

    public fflib_QueryFactory getQueryFactory() {
        return new fflib_QueryFactory(getSObjectType());
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        Map<String, Schema.SObjectField> accountFields = Account.SObjectType.getDescribe()
            .fields.getMap();
        return new List<Schema.SObjectField>(accountFields.values());
    }

    public List<String> getSObjectFieldListWithRelatedFields() {
        return this.additionalSObjectFieldList;
    }

    public void setSObjectFieldListWithRelatedFields(String[] values) {
        this.additionalSObjectFieldList = values;
    }

    @TestVisible
    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField>{};
    }

    public Account selectById(Id salesforceId) {
        List<Account> recordList = selectById(new Set<Id>{ salesforceId });
        return recordList.isEmpty() ? null : recordList[0];
    }

    public Account selectByUuid(String uuid) {
        if (String.isBlank(uuid)) {
            return null;
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('UUID__c = :uuid');
        List<Account> recordList = Database.query(qf.toSOQL());
        return recordList.isEmpty() ? null : recordList[0];
    }

    public List<Account> selectById(Set<Id> salesforceId) {
        if (salesforceId.isEmpty()) {
            return new List<Account>();
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('Id IN :salesforceId');
        return Database.query(qf.toSOQL());
    }
}
