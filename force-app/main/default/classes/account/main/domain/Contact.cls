public class Contact {
    private Id accountId;
    private String firstName;
    private String lastName;
    private String email;
    private Id ownerId;

    public Contact(Id accountId, String firstName, String lastName, String email, Id ownerId) {
        this.accountId = accountId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.ownerId = ownerId;
    }

    public static Contact create(String firstName, String lastName, String email) {
        return new Contact(null, firstName, lastName, email, Label.Agent_Default);
    }

    public Id accountId() {
        return this.accountId;
    }

    public String firstName() {
        return this.firstName;
    }

    public String lastName() {
        return this.lastName;
    }

    public String email() {
        return this.email;
    }

    public Id ownerId() {
        return this.ownerId;
    }

    public void setAgentOwnership(Id ownerId) {
        this.ownerId = ownerId;
    }
}
