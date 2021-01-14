'use strict';

const fs = require('fs');
const mysql = require('mysql');

// get table mapping and settings
let settings = JSON.parse(fs.readFileSync('config.json'));
let mapping = settings.mapping;

// load the sql patch file
let sqlFunctions = fs.readFileSync('data/sql_functions.sql').toString();
let sqlPatch = fs.readFileSync('data/migration-patch.sql').toString();

// create database connection
const db = mysql.createConnection({
    host: settings.db.hostname,
    port: settings.db.port,
	user: settings.db.username,
	password: settings.db.password,
	database: settings.db.database,
	multipleStatements: true
});

// aaand go
patch();

/*
* functions section
*/

async function patch() {
    console.log('initialize SQL functions');
    const query = await db.query(sqlFunctions,  (err, result) => {
        if (err){
             throw err;
        }else{
            console.log("SQL functions successfully initialized");
            injectSqlPatch();
        }
    });
}

async function injectSqlPatch() {
    console.log('inject migration patch');
    const query = await db.query(sqlPatch,  (err, result) => {
        if (err){
             throw err;
        }else{
            console.log("Patch successfully injected.");
            refactorOneFileReferences();
        }
    });
}

async function refactorOneFileReferences() {
    console.log("Start refactoring one file references");
    Object.entries(mapping.oneFile).forEach(function(data) {
        let fields = data[1].split('|');
        fields.forEach(function(field) {
            updateOneFileReference(data[0], field);
        });
        
    });
}

async function updateOneFileReference(table, field) {
    let query = "ALTER TABLE " + table + " CHANGE " + field + " " + field + " char(36) DEFAULT NULL;\n";
    query += "UPDATE " + table + " SET " + field + "=(SELECT id FROM directus_files WHERE " + table + "." + field + "=directus_files.deprecated_id);\n";
    query += "INSERT INTO directus_relations (many_collection, many_field, many_primary, one_collection, one_primary) VALUES('" + table + "', '" + field + "', 'id', 'directus_files', 'id' );";
    
    const response = await db.query(query,  (err, result) => {
        if (err){
             throw err;
        }else{
            console.log("One File references restored successfully.");
            alterJunctionTables();
        }
    });
}

async function alterJunctionTables() {
    console.log("altering junction tables");
    Object.entries(mapping.junctionTables).forEach(function(data) {
        updateJunctionTables(data[0], data[1]);
    });

}

async function updateJunctionTables(table, field) {
    let query = "ALTER TABLE " + table + " CHANGE " + field + " " + field + " char(36) DEFAULT NULL;\n";
    query += "UPDATE " + table + " SET " + field + "=(SELECT id FROM directus_files WHERE " + table + "." + field + "=directus_files.deprecated_id);\n";

    const response = await db.query(query,  (err, result) => {
        if (err){
             throw err;
        }else{
            console.log("Junction tables altered.");
            done();
        }
    });
}

function done() {
    console.log('all done');
    process.exit();
}