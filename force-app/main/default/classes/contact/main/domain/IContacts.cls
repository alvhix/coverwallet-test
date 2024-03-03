public interface IContacts extends fflib_ISObjects {
    Set<String> getUuids();
    void setAccountId(List<Account> accounts);
}