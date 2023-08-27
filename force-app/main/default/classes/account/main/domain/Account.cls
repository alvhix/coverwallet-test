public class Account {
    public final static String LOW_PRIORITY = 'Low';
    public final static String MEDIUM_PRIORITY = 'Medium';
    public final static String HIGH_PRIORITY = 'High';

    private Id salesforceId;
    @TestVisible
    private String uuid;
    private String companyName;
    private Decimal annualRevenue;
    private Integer numberEmployees;
    private String priority;
    private Id ownerId;
    private List<Contact> contacts;

    public Account() {
    }

    public Account(
        Id salesforceId,
        String uuid,
        String companyName,
        Decimal annualRevenue,
        Integer numberEmployees,
        String priority,
        Id ownerId,
        List<Contact> contacts
    ) {
        this.salesforceId = salesforceId;
        this.uuid = uuid;
        this.companyName = companyName;
        this.annualRevenue = annualRevenue;
        this.numberEmployees = numberEmployees;
        this.priority = priority;
        this.ownerId = ownerId;
        this.contacts = contacts;
    }

    public static Account create(
        String uuid,
        String companyName,
        Decimal annualRevenue,
        Integer numberEmployees,
        List<Contact> contacts
    ) {
        return new Account(
            null,
            uuid,
            companyName,
            annualRevenue,
            numberEmployees,
            null,
            Label.Agent_Default,
            contacts
        );
    }

    public Id salesforceId() {
        return this.salesforceId;
    }

    public void setSalesforceId(Id salesforceId) {
        this.salesforceId = salesforceId;
    }

    public String uuid() {
        return this.uuid;
    }

    public String companyName() {
        return this.companyName;
    }

    public Decimal annualRevenue() {
        return this.annualRevenue;
    }

    public Integer numberEmployees() {
        return this.numberEmployees;
    }

    public String priority() {
        return this.priority;
    }

    public String ownerId() {
        return this.ownerId;
    }

    public List<Contact> contacts() {
        return this.contacts;
    }

    public void setAccountPriority() {
        Integer lowRevenue = Integer.valueOf(Label.Account_Low_Revenue);
        Integer mediumRevenue = Integer.valueOf(Label.Account_Medium_Revenue);

        if (this.annualRevenue <= lowRevenue) {
            this.priority = LOW_PRIORITY;
        } else if (this.annualRevenue <= mediumRevenue) {
            this.priority = MEDIUM_PRIORITY;
        } else if (this.annualRevenue > mediumRevenue) {
            this.priority = HIGH_PRIORITY;
        }
    }

    public void setAgentOwnership() {
        if (this.priority == LOW_PRIORITY) {
            this.ownerId = Label.Agent_Low_Priority;
        } else if (this.priority == MEDIUM_PRIORITY) {
            this.ownerId = Label.Agent_Medium_Priority;
        } else if (this.priority == HIGH_PRIORITY) {
            this.ownerId = Label.Agent_High_Priority;
        }
    }
}
