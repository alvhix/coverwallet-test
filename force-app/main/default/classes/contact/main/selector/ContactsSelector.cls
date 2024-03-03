public inherited sharing class ContactsSelector extends fflib_SObjectSelector implements IContactsSelector {
    /* 1. sObjectField list */
    private List<String> additionalSObjectFieldList = new List<String>{
        'Id',
        'Name',
        'ExternalId__c',
        'FirstName',
        'LastName',
        'AccountId'
    };

    public Schema.SObjectType getSObjectType() {
        return Contact.getSObjectType();
    }

    public fflib_QueryFactory getQueryFactory() {
        return new fflib_QueryFactory(getSObjectType());
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        Map<String, Schema.SObjectField> contactFields = Contact.SObjectType.getDescribe()
            .fields.getMap();
        return new List<Schema.SObjectField>(contactFields.values());
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

    public Contact selectById(Id id) {
        List<Contact> recordList = selectById(new Set<Id>{ id });
        return recordList.isEmpty() ? null : recordList[0];
    }

    public Contact selectByUuid(String uuid) {
        if (String.isBlank(uuid)) {
            return null;
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldList());
        qf.setCondition('UUID__c = :uuid');
        List<Contact> recordList = Database.query(qf.toSOQL());
        return recordList.isEmpty() ? null : recordList[0];
    }

    public List<Contact> selectById(Set<Id> ids) {
        if (ids.isEmpty()) {
            return new List<Contact>();
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldList());
        qf.setCondition('Id IN :ids');
        return Database.query(qf.toSOQL());
    }
}
