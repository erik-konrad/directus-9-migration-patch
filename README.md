# Directus 9 Migration Patch

This is a migration patch for upgrading Directus 8 databases to Directus 9. The patch refactores the database for the new structure, upgrades the file references and removes deprecated settings.

## Requirements
* node.js

## Installation
* clone the repository to your migration machine with the database to migrate
* run "npm install"
* configure the patch process in the config.json
* run "node patch.js" in the patch folder
* reset your password

## Table configuration

The table configuration in the config.json has two sections. The first section "oneFile" is for custom one file table relations. the key means the table and the value is the field with with the file relation. Same in "junctionTables". If you have multiple file relations in tables, split it with a pipe.

## Credits

[Zebra | Group](https://www.zebra.de)  
[Sebastian Laube](https://github.com/bitstarr)  
Danilo Woeschka


## Disclaimer

I am not responsible for any loss of data. You use the patch at your own risk. Never use this patch in productive systems!
