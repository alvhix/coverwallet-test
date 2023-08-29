public class Contacts extends fflib_SObjectDomain {
    private IContactService contactService;
    public Contacts(List<Contact> sObjectList) {
        super(sObjectList);
        this.contactService = (IContactService) Application.Service.newInstance(
            IContactService.class
        );
    }

    public override void onBeforeInsert() {
        List<Contact> contacts = (List<Contact>) super.Records;
        setAgentOwnership(contacts);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        List<Contact> contacts = (List<Contact>) super.Records;
        setAgentOwnership(contacts);
    }

    public void setAgentOwnership(List<Contact> contacts) {
        this.contactService.setAgentOwnership(contacts);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Contacts(sObjectList);
        }
    }
}
