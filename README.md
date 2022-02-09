# CoverWallet - Salesforce technical test

We have an external system that needs to send to our Salesforce org data with customers account info. The data will be sent in JSON format. The accounts are identified with an external unique id field called “uuid”. Here we have an example JSON input:

```
{
    "accounts":[
        {
            "uuid":"123456-123456",
            "company_name":"Acme Corp.",
            "annual_revenue":120000,
            "number_employees":8,
            "contacts":[
                {
                    "first_name":"John",
                    "last_name":"Smith",
                    "email":"john@acme.com"
                },
                {
                    "first_name":"Maria",
                    "last_name":"Doe",
                    "email":"maria@acme.com"
                }
            ]
        }
    ]
}

```

We need to develop a custom endpoint in Salesforce so this external system will consume it in order to create or update Accounts and their correspondent child Contact objects in Salesforce.

In Salesforce, we should have a Priority field in Account. This priority field can have these values: “High”, “Medium” and “Low”. This priority value depends basically on the annual revenue of the account. Follow this table:

|   Annual Revenue   | Account Priority |
| :----------------: | :--------------: |
|    $0 - $50,000    |       Low        |
| $50,001 - $100,000 |      Medium      |
| More than $100,000 |       High       |

Add the needed logic in Salesforce to populate the Account Priority field.

In this Salesforce org, we have three agents, three salesforce users, who manage the Accounts and the Contacts. The way they identify which accounts they have to manage is by the ownership of the record. Each of the agents is specialised managing accounts by their priority.

| Account Priority | Assigned to |
| :--------------: | :---------: |
|       Low        |  Agent Loo  |
|      Medium      |  Agent Med  |
|       High       |  Agent HIj  |

Add the needed logic to assign the accounts and their child objects (contacts) to the correspondent agent, by the ownership of the record.

## Additional Exercise

Create a Visualforce page or Lightning component in which you can find Accounts by Name. The page has to has pagination and the result size should be configured manually. Also, the contacts related to the account should be shown on the page/component.
