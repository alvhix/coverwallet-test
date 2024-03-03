public interface IAccountService {
    Account get(String uuid);
    List<Account> upsertAccounts(List<Account> accounts);
}
