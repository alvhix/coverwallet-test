public with sharing class AccountService {
    public static Account get(String uuid) {
        return service().get(uuid);
    }

    public static void insertAccount(Account account, List<Contact> contacts) {
        service().insertAccount(account, contacts);
    }

    private static IAccountService service() {
        return (IAccountService) Application.Service.newInstance(IAccountService.class);
    }
}
