## Directus 9 Migration Patch

This is a migration patch for upgrading Directus 8 databases to Directus 9. The patch refactores the database for the new structure, upgrades the file references and removes deprecated settings.

For full magration, there are some more manual steps:

* migrate all file reference fields - it is necessary that all fields for file references in custom tables are from the same type like the id from directus_files. Alter it from int(11) to char(36). The same steps are manually to do in the junction tables.

* reference definition in directus_references for the file reference fields - Directus 9 uses the directus_references table for single file fields. That entrys have to be defined manually. if you dont know, how the row has to look like, create a single file field in directus and check the entry in the directus_references table. 

* change passwords - Directus 9 uses a new password encryption (argon2). You have to set new passwords for the backend accounts.

## Disclaimer

I am not responsible for any loss of data. You use the patch at your own risk. Never use this patch in productive systems!
