public class ContactMother {
    public static Contact singleRandom() {
        return new Contact(
            FirstName = TestGenerator.randomString(10),
            LastName = TestGenerator.randomString(15),
            Email = TestGenerator.randomEmail()
        );
    }

    public static Contact singleRandom(String uuid) {
        String email = TestGenerator.randomEmail();
        return new Contact(
            FirstName = TestGenerator.randomString(10),
            LastName = TestGenerator.randomString(15),
            Email = email,
            ExternalId__c = uuid + email
        );
    }

    public static List<Contact> byUuid(String uuid) {
        List<Contact> contacts = new List<Contact>();
        Integer random = TestGenerator.randomInteger(1, 6);
        for (Integer i = 0; i < random; i++) {
            contacts.add(singleRandom(uuid));
        }

        return contacts;
    }

    public static List<Contact> random() {
        List<Contact> contacts = new List<Contact>();
        Integer random = TestGenerator.randomInteger(1, 6);
        for (Integer i = 0; i < random; i++) {
            contacts.add(singleRandom());
        }

        return contacts;
    }
}
