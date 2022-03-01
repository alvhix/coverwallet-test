// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// Generate new accounts
Integer numberOfAccounts = 1000;
DataGenerator generator = new DataGenerator();
generator.generateAccounts(numberOfAccounts);

// Delete created accounts
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];
delete accounts;
