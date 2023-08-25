public class Mapper {
    private final static String SUFFIX = 'Mapper';

    public static List<Object> mapToDomain(List<SObject> records) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();
        return getDomainMapper(sObjectName).mapToDomain(records);
    }

    public static List<SObject> mapToEntity(List<Object> domainRecords, List<SObject> records) {
        String sObjectName = records[0].getSObjectType().getDescribe().getName();
        return getDomainMapper(sObjectName).mapToEntity(domainRecords, records);
    }

    public static List<SObject> mapToEntity(List<Object> domainRecords, String objectName) {
        return getDomainMapper(objectName).mapToEntity(domainRecords);
    }

    public static TriggerService getTriggerService(String objectName) {
        DomainMapping__mdt domainMapping = DomainMapping__mdt.getInstance(objectName);
        TriggerService triggerService = (TriggerService) Type.forName(domainMapping.ServiceClass__c)
            .newInstance();
        return triggerService.init(Type.forName(domainMapping.RepositoryClass__c));
    }

    private static DomainMapper getDomainMapper(String objectName) {
        return (DomainMapper) Type.forName(
                DomainMapping__mdt.getInstance(objectName).DomainClass__c + SUFFIX
            )
            .newInstance();
    }
}
