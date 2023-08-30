@IsTest(isParallel=true)
private class AccountServiceTest {
    private static IAccountService accountService = AccountService.newInstance();

    @IsTest
    static void testGet() {
        accountService.get(uuid);
    }
}
