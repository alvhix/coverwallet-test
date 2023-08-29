trigger ContactTrigger on Contact(before insert, before update) {
    fflib_SObjectDomain.triggerHandler(Contacts.class);
}
