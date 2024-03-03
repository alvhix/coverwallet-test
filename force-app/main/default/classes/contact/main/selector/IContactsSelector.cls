public interface IContactsSelector extends fflib_ISObjectSelector {
    Contact selectById(Id id);
    Contact selectByUuid(String uuid);
    List<Contact> selectById(Set<Id> ids);
}
