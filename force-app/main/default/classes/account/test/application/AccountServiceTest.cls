@IsTest(isParallel=true)
private class AccountServiceTest {
    private static IAccountService accountService = (IAccountService) Application.Service.newInstance(
        IAccountService.class
    );

    @IsTest
    static void testGet() {
        //accountService.get(uuid);
    }
}
