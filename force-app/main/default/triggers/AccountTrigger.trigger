trigger AccountTrigger on Account(before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountService.setAccountPriority(Trigger.new);
            AccountService.setAgentOwnership(Trigger.new);
        }
        if (Trigger.isUpdate) {
            AccountService.setAccountPriority(Trigger.new);
            AccountService.setAgentOwnership(Trigger.new);
        }
    }
}
