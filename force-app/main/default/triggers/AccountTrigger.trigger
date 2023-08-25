trigger AccountTrigger on Account(before insert, before update) {
    TriggerHandler.handle();
}
