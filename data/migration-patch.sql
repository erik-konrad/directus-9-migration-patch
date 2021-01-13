#####################################################
# Directus 9 Migration Script
#####################################################

#
# Table directus_activity
#
ALTER TABLE directus_activity
    CHANGE id id int(10) AUTO_INCREMENT,
    ADD user char(36) DEFAULT null AFTER action,
    ADD timestamp timestamp DEFAULT current_timestamp() AFTER user,
    CHANGE action_by deprecated_action_by int(11) DEFAULT 0 AFTER comment,
    CHANGE action_on deprecated_action_on datetime AFTER comment,
    CHANGE edited_on deprecated_edited_on datetime AFTER comment,
    CHANGE comment_deleted_on deprecated_comment_deleted_on text AFTER comment;
CREATE INDEX directus_activity_collection_foreign ON directus_activity (collection);

#
# Table directus_collections
#
ALTER TABLE directus_collections
    CHANGE icon icon varchar(30) AFTER collection,
    CHANGE note note varchar(255) AFTER icon,
    ADD display_template varchar(255) DEFAULT NULL AFTER note,
    CHANGE hidden  hidden tinyint(1) DEFAULT 0 NOT NULL AFTER display_template,
    CHANGE single singleton tinyint(1) DEFAULT 0 NOT NULL after hidden,
    CHANGE translation translations text AFTER singleton,
    ADD archive_field varchar(64) AFTER translations,
    ADD archive_app_filter tinyint(1) DEFAULT 1 NOT NULL AFTER archive_field,
    ADD archive_value varchar(255) AFTER archive_app_filter,
    ADD unarchive_value varchar(255) AFTER archive_value,
    ADD sort_field varchar(64) AFTER unarchive_value,
    CHANGE managed deprecated_managed tinyint(1) DEFAULT 1 AFTER sort_field;

#
# Table directus_fields
#
ALTER TABLE directus_fields
    CHANGE id id int(10) AUTO_INCREMENT,
    CHANGE type special varchar(64),
    CHANGE options options longtext,
    ADD display varchar(64) DEFAULT NULL AFTER options,
    ADD display_options longtext DEFAULT NULL AFTER display,
    CHANGE validation deprecated_validation varchar(500) AFTER note,
    CHANGE required deprecated_required tinyint(1) AFTER note,
    CHANGE hidden_detail hidden tinyint(1),
    CHANGE hidden_browse deprecated_hidden_browse tinyint(1) AFTER note,
    CHANGE sort sort int(10),
    CHANGE width width varchar(30),
    CHANGE `group` `group` int(10) DEFAULT NULL,
    CHANGE translation translations longtext AFTER `group`;
# CREATE INDEX directus_fields_group_foreign ON directus_fields (`group`);

CREATE INDEX directus_fields_collection_foreign	 on directus_fields (collection);
DROP INDEX idx_collection_field ON directus_fields;

SET FOREIGN_KEY_CHECKS=0;

#
# Table directus_files
#
ALTER TABLE directus_files
    CHANGE id id char(36),
    CHANGE filename_disk filename_disk varchar(255) DEFAULT NULL,
    CHANGE storage storage varchar(255),
    CHANGE private_hash deprecated_private_hash varchar(16) AFTER metadata,
    CHANGE folder folder char(36) after type,
    CHANGE uploaded_by uploaded_by char(36),
    CHANGE uploaded_on uploaded_on timestamp DEFAULT current_timestamp(),
    ADD modified_by char(36) DEFAULT NULL AFTER uploaded_on,
    ADD modified_on timestamp DEFAULT current_timestamp() AFTER modified_by,
    CHANGE filesize filesize int(10),
    CHANGE width width int(10),
    CHANGE height height int(10),
    CHANGE duration duration int(10),
    CHANGE location location text,
    CHANGE tags tags text,
    CHANGE metadata metadata longtext,
    CHANGE checksum deprecated_checksum varchar(32) AFTER metadata;

# CREATE INDEX directus_files_folder_foreign ON directus_files(folder);
# CREATE INDEX directus_files_uploaded_by_foreign	ON directus_files(uploaded_by);
# CREATE INDEX directus_files_modified_by_foreign	ON directus_files(modified_by);

#
# TABLE directus_folders
#
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE directus_folders
    CHANGE id id char(36),
    CHANGE name name varchar(255) NOT NULL,
    CHANGE parent_folder parent char(36);
DROP INDEX idx_name_parent_folder ON directus_folders;
CREATE INDEX directus_folders_parent_foreign on directus_folders(parent);
SET FOREIGN_KEY_CHECKS=1;

#
# TABLE directus_migrations
#
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE directus_migrations
    CHANGE version version varchar(255) NOT NULL,
    CHANGE migration_name name varchar(255) NOT NULL,
    CHANGE start_time `timestamp` timestamp DEFAULT current_timestamp(),
    CHANGE end_time deprecated_end_time timestamp DEFAULT current_timestamp AFTER timestamp,
    CHANGE breakpoint deprecated_breakpoint tinyint(1) DEFAULT 0 NOT NULL AFTER deprecated_end_time;
SET FOREIGN_KEY_CHECKS=1;

#
# TABLE directus_permissions
#
ALTER TABLE directus_permissions
    CHANGE role role char(36) DEFAULT NULL AFTER id,
    CHANGE collection collection varchar(64),
    ADD action varchar(10) NOT NULL AFTER collection,
    ADD permissions longtext DEFAULT NULL AFTER action,
    ADD validation longtext DEFAULT NULL AFTER permissions,
    ADD presets longtext DEFAULT NULL AFTER validation,
    ADD fields text DEFAULT NULL AFTER presets,
    ADD `limit` int(10) DEFAULT NULL AFTER fields,
    CHANGE status deprecated_status varchar(64) AFTER `limit`,
    CHANGE `create` deprecated_create varchar(16) AFTER `limit`,
    CHANGE `read` deprecated_read varchar(16) AFTER `limit`,
    CHANGE `update` deprecated_update varchar(16) AFTER `limit`,
    CHANGE `delete` deprecated_delete varchar(16) AFTER `limit`,
    CHANGE `comment` deprecated_comment varchar(8) AFTER `limit`,
    CHANGE `explain` deprecated_explain varchar(8) AFTER `limit`,
    CHANGE read_field_blacklist deprecated_read_field_blacklist varchar(1000) AFTER `limit`,
    CHANGE write_field_blacklist deprecated_write_field_blacklist varchar(1000) AFTER `limit`,
    CHANGE status_blacklist deprecated_status_blacklist varchar(1000) AFTER `limit`;
CREATE INDEX directus_permissions_collection_foreign ON directus_permissions(collection);
CREATE INDEX directus_permissions_role_foreign ON directus_permissions(role);

#
# TABLE directus_presets
#
RENAME TABLE directus_collection_presets TO directus_presets;
ALTER TABLE directus_presets
    CHANGE id id int(10) AUTO_INCREMENT,
    CHANGE title bookmark varchar(255),
    CHANGE user user char(36),
    CHANGE role role char(36),
    CHANGE search_query search varchar(100),
    CHANGE filters filters longtext,
    CHANGE view_type layout varchar(100),
    CHANGE view_query layout_query longtext,
    CHANGE view_options layout_options longtext,
    CHANGE translation deprecated_translation text;
DROP INDEX idx_user_collection_title ON directus_presets;
CREATE INDEX directus_presets_collection_foreign ON directus_presets(collection);
CREATE INDEX directus_presets_user_foreign ON directus_presets(user);
CREATE INDEX directus_presets_role_foreign ON directus_presets(role);

#
# TABLE directus_relations
#
ALTER TABLE directus_relations
    CHANGE id id int(10) AUTO_INCREMENT,
    CHANGE collection_many many_collection varchar(64),
    CHANGE field_many many_field varchar(64),
    ADD many_primary varchar(64) DEFAULT 'id' AFTER many_field,
    CHANGE collection_one one_collection varchar(64),
    CHANGE field_one one_field varchar(64),
    ADD one_primary varchar(64) DEFAULT 'id' AFTER one_field,
    ADD one_collection_field varchar(64) DEFAULT NULL AFTER one_primary,
    ADD one_allowed_collections text DEFAULT NULL AFTER one_collection_field,
    CHANGE junction_field junction_field varchar(64) AFTER one_allowed_collections;
CREATE INDEX directus_relations_many_collection_foreign ON directus_relations(many_collection);
CREATE INDEX directus_relations_one_collection_foreign ON directus_relations(one_collection);

#
# TABLE directus_revisions
#
ALTER TABLE directus_revisions
    CHANGE id id int(10) AUTO_INCREMENT,
    CHANGE activity activity int(10),
    ADD parent int(10) DEFAULT NULL AFTER delta,
    CHANGE parent_collection deprecated_parent_collection varchar(64),
    CHANGE parent_item deprecated_parent_item varchar(255),
    CHANGE parent_changed deprecated_parent_changed tinyint(1);
CREATE INDEX directus_revisions_collection_foreign ON directus_revisions(collection);
CREATE INDEX directus_revisions_activity_foreign ON directus_revisions(activity);
CREATE INDEX directus_revisions_parent_foreign	ON directus_revisions(parent);

#
# TABLE directus_roles
#
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE directus_roles
    CHANGE id id char(36),
    ADD icon varchar(30) DEFAULT 'supervised_user_circle' AFTER name,
    CHANGE description description text,
    CHANGE ip_whitelist ip_access text,
    CHANGE enforce_2fa enforce_tfa tinyint(1) DEFAULT 0 NOT NULL AFTER ip_access,
    CHANGE module_listing module_list longtext,
    CHANGE collection_listing collection_list longtext,
    ADD admin_access tinyint(1) DEFAULT 1 NOT NULL,
    ADD app_access tinyint(1) DEFAULT 1 NOT NULL,
    CHANGE external_id deprecated_external_id varchar(255) AFTER app_access;
DROP INDEX idx_group_name ON directus_roles;
DROP INDEX idx_roles_external_id ON directus_roles;
SET FOREIGN_KEY_CHECKS=1;

#
# TABLE directus_sessions
#
RENAME TABLE directus_user_sessions TO directus_sessions;
ALTER TABLE directus_sessions
    CHANGE token token varchar(64) NOT NULL FIRST,
    DROP COLUMN id,
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`token`) USING BTREE,
    CHANGE user user char(36) NOT NULL,
    CHANGE token_expired_at expires timestamp DEFAULT current_timestamp() AFTER user,
    CHANGE ip_address ip varchar(255),
    CHANGE user_agent user_agent varchar(255),
    CHANGE token_type deprecated_token_type varchar(255) AFTER user_agent,
    CHANGE created_on deprecated_created_on datetime DEFAULT NULL;
CREATE INDEX directus_sessions_user_foreign ON directus_sessions(user);

#
# TABLE directus_settings
#
ALTER TABLE directus_settings
    CHANGE id id int(10) AUTO_INCREMENT,
    ADD project_name varchar(100) DEFAULT 'Directus',
    ADD project_url varchar(255) DEFAULT NULL,
    ADD project_color varchar(10) DEFAULT NULL,
    ADD project_logo char(36) DEFAULT NULL,
    ADD public_foreground char(36) DEFAULT NULL,
    ADD public_background char(36) DEFAULT NULL,
    ADD public_note text DEFAULT NULL,
    ADD auth_login_attempts int(10) UNSIGNED DEFAULT 25,
    ADD auth_password_policy varchar(100) DEFAULT NULL,
    ADD storage_asset_transform varchar(7) DEFAULT 'all',
    ADD storage_asset_presets longtext DEFAULT NULL,
    ADD custom_css text DEFAULT NULL;
# CREATE INDEX directus_settings_project_logo_foreign ON directus_settings(project_logo);
# CREATE INDEX directus_settings_public_foreground_foreign ON directus_settings(public_foreground);
# CREATE INDEX directus_settings_public_background_foreign ON directus_settings(public_background);

SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_name';
UPDATE directus_settings SET project_name = @val WHERE id = 1;

SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_url';
UPDATE directus_settings SET project_url = @val WHERE id = 1;

SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_color';
UPDATE directus_settings SET project_color = @val WHERE id = 1;

#SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_logo';
#UPDATE directus_settings SET project_logo = @val WHERE id = 1;

#SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_foreground';
#UPDATE directus_settings SET public_foreground = @val WHERE id = 1;

#SELECT @val:=value FROM `directus_settings` WHERE `key` = 'project_background';
#UPDATE directus_settings SET public_background = @val WHERE id = 1;

SELECT @val:=value FROM `directus_settings` WHERE `key` = 'login_attempts_allowed';
UPDATE directus_settings SET auth_login_attempts = @val WHERE id = 1;

SELECT @val:=value FROM `directus_settings` WHERE `key` = 'password_policy';
UPDATE directus_settings SET auth_password_policy = @val WHERE id = 1;

DELETE FROM `directus_settings` WHERE id > 1;

ALTER TABLE directus_settings
    DROP COLUMN `key`,
    DROP COLUMN `value`;

#
# TABLE directus_users
#
ALTER TABLE directus_users 
    CHANGE id id char(36),
    CHANGE first_name first_name varchar(50) AFTER id,
    CHANGE last_name last_name varchar(50) AFTER first_name,
    CHANGE email email varchar(128) NOT NULL AFTER last_name,
    CHANGE password password varchar(255) AFTER email,
    ADD location varchar(255) DEFAULT NULL AFTER password,
    CHANGE title title varchar(50) AFTER location,
    ADD description text DEFAULT NULL AFTER title,
    ADD tags longtext DEFAULT NULL AFTER description,
    CHANGE avatar avatar char(36) AFTER tags,
    CHANGE locale language varchar(8) DEFAULT 'en-US' AFTER avatar,
    CHANGE theme theme varchar(20) DEFAULT 'auto' AFTER language,
    CHANGE 2fa_secret tfa_secret varchar(255) DEFAULT NULL AFTER theme,
    CHANGE status status varchar(16) DEFAULT 'active' AFTER tfa_secret,
    CHANGE role role char(36) DEFAULT NULL AFTER status,
    CHANGE token token varchar(255) AFTER role,
    CHANGE last_access_on last_access timestamp DEFAULT current_timestamp() AFTER token,
    CHANGE last_page last_page varchar(255) AFTER last_access,
    CHANGE timezone deprecated_timezone varchar(32) AFTER last_page,
    CHANGE locale_options deprecated_locale_options text AFTER last_page,
    CHANGE company deprecated_company varchar(191) AFTER last_page,
    CHANGE email_notifications deprecated_email_notifications int(1) AFTER last_page,
    CHANGE external_id deprecated_external_id varchar(255) AFTER last_page,
    CHANGE password_reset_token deprecated_password_reset_token varchar(520) AFTER last_page;

DROP INDEX idx_users_email ON directus_users;
DROP INDEX idx_users_token ON directus_users;
DROP INDEX idx_users_external_id ON directus_users;

CREATE INDEX directus_users_email_unique ON directus_users(email);

#
# TABLE directus_webhooks
#
ALTER TABLE directus_webhooks
    CHANGE id id int(10) AUTO_INCREMENT,
    ADD name varchar(255) NOT NULL AFTER id,
    CHANGE http_action method varchar(10) DEFAULT 'POST' AFTER name,
    CHANGE url url text AFTER method,
    CHANGE status status varchar(10) DEFAULT 'active' AFTER url,
    ADD data tinyint(1) DEFAULT 1 AFTER status,
    CHANGE directus_action actions varchar(100) NOT NULL AFTER data,
    CHANGE collection collections varchar(255) NOT NULL AFTER actions;


#
# recreate SQL relations
#

ALTER TABLE `directus_fields` 
    ADD CONSTRAINT `directus_fields_group_foreign` 
    FOREIGN KEY (`group`) 
    REFERENCES `directus_fields`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE;

ALTER TABLE `directus_files` 
    ADD CONSTRAINT `directus_files_folder_foreign` 
    FOREIGN KEY (`folder`) 
    REFERENCES `directus_folders`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE;

ALTER TABLE `directus_files` 
    ADD CONSTRAINT `directus_files_modified_by_foreign` 
    FOREIGN KEY (`modified_by`) 
    REFERENCES `directus_users`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE; 

ALTER TABLE `directus_files` 
    ADD CONSTRAINT `directus_files_uploaded_by_foreign` 
    FOREIGN KEY (`uploaded_by`) 
    REFERENCES `directus_users`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE;

ALTER TABLE `directus_folders` 
    ADD CONSTRAINT `directus_folders_parent_foreign` 
    FOREIGN KEY (`parent`) 
    REFERENCES `directus_folders`(`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE;

ALTER TABLE `directus_permissions` 
    ADD CONSTRAINT `directus_permissions_role_foreign` 
    FOREIGN KEY (`role`) 
    REFERENCES `directus_roles`(`id`) 
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `directus_presets` 
    ADD CONSTRAINT `directus_presets_role_foreign` 
    FOREIGN KEY (`role`) 
    REFERENCES `directus_roles`(`id`) 
    ON DELETE CASCADE
    ON UPDATE CASCADE; 

ALTER TABLE `directus_presets` 
    ADD CONSTRAINT `directus_presets_user_foreign` 
    FOREIGN KEY (`user`) 
    REFERENCES `directus_users`(`id`) 
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `directus_revisions` 
    ADD CONSTRAINT `directus_revisions_activity_foreign` 
    FOREIGN KEY (`activity`) 
    REFERENCES `directus_activity`(`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE; 

ALTER TABLE `directus_revisions` 
    ADD CONSTRAINT `directus_revisions_parent_foreign` 
    FOREIGN KEY (`parent`) 
    REFERENCES `directus_revisions`(`id`) 
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE `directus_sessions` 
    ADD CONSTRAINT `directus_sessions_user_foreign` 
    FOREIGN KEY (`user`) 
    REFERENCES `directus_users`(`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE;

ALTER TABLE `directus_settings` 
    ADD CONSTRAINT `directus_settings_project_logo_foreign` 
    FOREIGN KEY (`project_logo`) 
    REFERENCES `directus_files`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE; 

ALTER TABLE `directus_settings` 
    ADD CONSTRAINT `directus_settings_public_background_foreign` 
    FOREIGN KEY (`public_background`) 
    REFERENCES `directus_files`(`id`) 
    ON DELETE SET NULL
    ON UPDATE CASCADE; 

ALTER TABLE `directus_settings` 
    ADD CONSTRAINT `directus_settings_public_foreground_foreign` 
    FOREIGN KEY (`public_foreground`) 
    REFERENCES `directus_files`(`id`) 
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE `directus_users` 
    ADD CONSTRAINT `directus_users_role_foreign` 
    FOREIGN KEY (`role`) 
    REFERENCES `directus_roles`(`id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE;

#
# fix translations
#

UPDATE `directus_collections` 
    SET translations = REPLACE(translations, "locale", "language") 
    WHERE translations 
    LIKE "%locale%";

UPDATE `directus_collections` 
    SET translations = REPLACE(translations, "\"newItem\":true,", "") 
    WHERE translations 
    LIKE "%\"newItem\":true,%";

UPDATE `directus_fields` 
    SET translations = REPLACE(translations, "locale", "language") 
    WHERE translations 
    LIKE "%locale%";

UPDATE `directus_fields` 
    SET translations = REPLACE(translations, "\"newItem\":true,", "") 
    WHERE translations 
    LIKE "%\"newItem\":true,%";


#
# restore user profile list
#
UPDATE `directus_presets`
    SET layout_options = '{"cards":{"title":"{{first_name}}","subtitle":"{{last_name}}","content":"title","src":"avatar","icon":"person"}}'
    WHERE collection = "directus_users";

#
# restore file list
#
UPDATE `directus_presets`
    SET layout_options = '{"cards":{"title":"title","subtitle":"type","content":"description","src":"data"}}'
    WHERE collection = "directus_files";

#
# remove deprecated system table relations
#
DELETE FROM directus_relations WHERE id < 12;

#
# remove deprecated field definition
#
DELETE FROM directus_fields WHERE collection LIKE "%directus_%";

#
# remove deprecated system presets
#
DELETE FROM directus_presets WHERE collection LIKE "%directus_%";

#
# reset relation field options
#

UPDATE directus_fields
    SET special="files"
    WHERE interface="files";

UPDATE directus_fields
    set options = NULL
    WHERE special = "m2m" OR special = "o2m" OR special = "m2o";

#
# cleanup collection list in directus_roles and remove old collection lists
#

UPDATE directus_roles
    SET collection_list = NULL;


#
# change directus_files from id to uuid
#

ALTER TABLE directus_files
    ADD deprecated_id int(11);

UPDATE directus_files
    SET deprecated_id = id;
    
UPDATE directus_files
	SET id = uuid_v4();

UPDATE directus_users 
   SET avatar=(SELECT id FROM directus_files WHERE directus_users.avatar=directus_files.deprecated_id);

#
# change directus_users and roles from id to uuid
#

ALTER TABLE directus_users
    ADD deprecated_id int(11);

UPDATE directus_users
    SET deprecated_id = id;

ALTER TABLE directus_roles
    ADD deprecated_id int(11);

UPDATE directus_roles
    SET deprecated_id = id;

UPDATE directus_users
	SET id = uuid_v4();

UPDATE directus_roles
	SET id = uuid_v4();
