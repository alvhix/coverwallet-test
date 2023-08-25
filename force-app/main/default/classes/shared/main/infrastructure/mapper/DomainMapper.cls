public interface DomainMapper {
    List<Object> mapToDomain(List<SObject> records);
    List<SObject> mapToEntity(List<Object> domainRecords);
    List<SObject> mapToEntity(List<Object> domainRecords, List<SObject> records);
}