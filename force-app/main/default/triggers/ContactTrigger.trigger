trigger ContactTrigger on Contact(before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactService.setAgentOwnership(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ContactService.setAgentOwnership(Trigger.new);
        }
    }
}
