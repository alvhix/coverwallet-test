public with sharing class AccountService {
    public static Account get(String uuid) {
        return service().get(uuid);
    }

    public static List<Account> upsertAccounts(List<Account> accounts) {
        return service().upsertAccounts(accounts);
    }

    private static IAccountService service() {
        return (IAccountService) Application.Service.newInstance(IAccountService.class);
    }
}
