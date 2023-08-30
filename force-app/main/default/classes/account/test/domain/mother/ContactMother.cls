public class ContactMother {
    public static Contact singleRandom() {
        return new Contact(
            FirstName = TestGenerator.randomString(10),
            LastName = TestGenerator.randomString(15),
            Email = TestGenerator.randomEmail()
        );
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
