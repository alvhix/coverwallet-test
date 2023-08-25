trigger ContactTrigger on Contact(before insert, before update) {
    TriggerHandler.handle();
}
