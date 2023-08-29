trigger AccountTrigger on Account(before insert, before update) {
    fflib_SObjectDomain.triggerHandler(Accounts.class);
}
