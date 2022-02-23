// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

System.debug(Integer.valueOf(Math.random() * 1000 + 1));
System.debug(Integer.valueOf(Math.random() * 175000));
Blob b = Crypto.GenerateAESKey(128);
String result = 'Test-' + EncodingUtil.convertToHex(b);
System.debug(result);

String uuid1 = String.valueOf(Integer.valueOf(Math.random() * 123456))
    .leftPad(6, '0');
String uuid2 = String.valueOf(Integer.valueOf(Math.random() * 123456))
    .leftPad(6, '0');
System.debug(uuid1 + '-' + uuid2);

System.debug(
    URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Account/'
);
