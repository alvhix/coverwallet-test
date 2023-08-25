public interface TriggerService {
    TriggerService init(Type repository);

    void afterInsert(List<Object> records);

    void beforeInsert(List<Object> records);

    void beforeUpdate(List<Object> records, Map<Id, Object> oldMap);

    void afterUpdate(List<Object> records, List<Object> oldRecords);

    void beforeDelete(Map<Id, Object> oldMap);

    void afterDelete(List<Object> oldRecords);

    void afterUndelete(List<Object> records);
}
