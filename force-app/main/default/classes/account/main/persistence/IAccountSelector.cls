public interface IAccountSelector extends fflib_ISObjectSelector {
    Account selectById(Id salesforceId);
    Account selectByUuid(String uuid);
    List<Account> selectById(Set<Id> salesforceId);
}
