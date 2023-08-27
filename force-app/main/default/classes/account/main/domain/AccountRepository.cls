public interface AccountRepository {
    Account get(Id salesforceId);
    Account get(String uuid);
    List<Account> get(Set<Id> salesforceIds);
    Id insertAccount(Account account);
    Id updateAccount(Account account, Account existingAccount);
}
