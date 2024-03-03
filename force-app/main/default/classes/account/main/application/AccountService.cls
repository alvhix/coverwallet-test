public with sharing class AccountService {
    public static Account get(String uuid) {
        return service().get(uuid);
    }

    public static List<Account> upsertAccounts(List<Account> accounts) {
        return service().upsertAccounts(accounts);
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String name, Integer recordsPerPage, Integer page) {
        return service().getAccounts(name, recordsPerPage, page);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNumberOfAccounts(String name) {
        return service().getNumberOfAccounts(name);
    }

    private static IAccountService service() {
        return (IAccountService) Application.Service.newInstance(IAccountService.class);
    }
}
