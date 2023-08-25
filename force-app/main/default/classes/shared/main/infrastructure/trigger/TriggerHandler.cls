public class TriggerHandler {
    public static void handle() {
        handleTriggers();
    }

    private static void handleTriggers() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handleBeforeInsert(Trigger.new);
            }
            when AFTER_INSERT {
                handleAfterInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                handleBeforeUpdate(Trigger.new, Trigger.oldMap);
            }
            when AFTER_UPDATE {
                handleAfterUpdate(Trigger.new, Trigger.old);
            }
            when BEFORE_DELETE {
                handleBeforeDelete(Trigger.oldMap);
            }
            when AFTER_DELETE {
                handleAfterDelete(Trigger.old);
            }
            when AFTER_UNDELETE {
                handleAfterUndelete(Trigger.new);
            }
            when else {
                System.debug('Something bad happened');
            }
        }
    }

    private static void handleBeforeInsert(List<SObject> records) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();

        // 1. map to domain
        List<Object> domainRecords = Mapper.mapToDomain(records);

        // 2. perform before insert
        Mapper.getTriggerService(sObjectName).beforeInsert(domainRecords);

        // 3. map to entity
        Mapper.mapToEntity(domainRecords, records);
    }

    private static void handleAfterInsert(List<SObject> records) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();

        // 1. map to domain
        List<Object> domainRecords = Mapper.mapToDomain(records);

        // 2. perform before insert
        Mapper.getTriggerService(sObjectName).afterInsert(domainRecords);

        // 3. map to entity
        Mapper.mapToEntity(domainRecords, records);
    }

    private static void handleBeforeUpdate(List<SObject> records, Map<Id, SObject> oldMap) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();

        // 1. map to domain
        List<Object> domainRecords = Mapper.mapToDomain(records);

        // 2. perform before insert
        Mapper.getTriggerService(sObjectName).beforeUpdate(domainRecords, oldMap);

        // 3. map to entity
        Mapper.mapToEntity(domainRecords, records);
    }

    private static void handleAfterUpdate(List<SObject> records, List<SObject> oldRecords) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();

        // 1. map to domain
        List<Object> domainRecords = Mapper.mapToDomain(records);

        // 2. perform before insert
        Mapper.getTriggerService(sObjectName).afterUpdate(domainRecords, oldRecords);

        // 3. map to entity
        Mapper.mapToEntity(domainRecords, records);
    }

    private static void handleBeforeDelete(Map<Id, SObject> oldMap) {
    }

    private static void handleAfterDelete(List<SObject> oldRecords) {
    }

    private static void handleAfterUndelete(List<SObject> records) {
    }
}
