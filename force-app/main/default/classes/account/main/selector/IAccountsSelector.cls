public interface IAccountsSelector extends fflib_ISObjectSelector {
    Account selectById(Id id);
    Account selectByUuid(String uuid);
    List<Account> selectById(Set<Id> ids);
    List<Account> selectByUuid(Set<String> uuids);
}
