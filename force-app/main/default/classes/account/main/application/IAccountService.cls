public interface IAccountService {
    Account get(String uuid);
    List<Account> upsertAccounts(List<Account> accounts);
    List<Account> getAccounts(
        String name,
        Integer recordsPerPage,
        Integer page
    );
    Integer getNumberOfAccounts(String name);
}
