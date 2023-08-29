public interface IAccountService {
    Account get(String uuid);
    void insertAccount(Account account, List<Contact> contacts);
}
