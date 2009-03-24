DROP TABLE IF EXISTS wiki_pagecontent
;
DROP TABLE IF EXISTS wiki_comments
;
DROP TABLE IF EXISTS wiki_users_permissions
;
DROP TABLE IF EXISTS wiki_users
;
DROP TABLE IF EXISTS wiki_role_permissions
;
DROP TABLE IF EXISTS wiki_pagecontent_category
;
DROP TABLE IF EXISTS wiki_page
;
DROP TABLE IF EXISTS wiki_securityrules
;
DROP TABLE IF EXISTS wiki_roles
;
DROP TABLE IF EXISTS wiki_permissions
;
DROP TABLE IF EXISTS wiki_options
;
DROP TABLE IF EXISTS wiki_namespace
;
DROP TABLE IF EXISTS wiki_customhtml
;
DROP TABLE IF EXISTS wiki_category
;



CREATE TABLE wiki_pagecontent
(
	pagecontent_id VARCHAR(36) NOT NULL,
	FKpage_id VARCHAR(36) NOT NULL,
	FKuser_id VARCHAR(36) NOT NULL,
	pagecontent_content TEXT,
	pagecontent_comment TEXT,
	pagecontent_version BIGINT NOT NULL DEFAULT '1',
	pagecontent_createdate DATETIME NOT NULL,
	pagecontent_isActive TINYINT NOT NULL DEFAULT '1',
	pagecontent_isReadOnly TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY (pagecontent_id),
	INDEX FKpage_id (FKpage_id ASC),
	INDEX FKuser_id (FKuser_id ASC),
	INDEX idx_wiki_pagecontent_isActive (pagecontent_isActive ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_comments
(
	comment_id VARCHAR(36) NOT NULL,
	FKpage_id VARCHAR(36) NOT NULL,
	comment_content TEXT NOT NULL,
	comment_author VARCHAR(255),
	comment_author_email VARCHAR(255),
	comment_author_url VARCHAR(255),
	comment_author_ip VARCHAR(100),
	comment_createdate DATETIME NOT NULL,
	comment_isActive TINYINT NOT NULL DEFAULT '1',
	comment_isApproved TINYINT NOT NULL DEFAULT '0',
	FKuser_id VARCHAR(36),
	PRIMARY KEY (comment_id),
	INDEX idx_createdate (comment_createdate ASC),
	INDEX idx_pagecomments (FKpage_id ASC, comment_isActive ASC, comment_isApproved ASC),
	INDEX FKpage_id (FKpage_id ASC),
	INDEX FKuser_id (FKuser_id ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_users_permissions
(
	FKuser_id VARCHAR(36) NOT NULL,
	FKpermission_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKuser_id, FKpermission_id),
	INDEX FKpermission_id (FKpermission_id ASC),
	INDEX FKuser_id (FKuser_id ASC),
	INDEX FKpermission_id_2 (FKpermission_id ASC),
	INDEX FKuser_id_2 (FKuser_id ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_users
(
	user_id VARCHAR(36) NOT NULL,
	user_fname VARCHAR(100) NOT NULL,
	user_lname VARCHAR(100) NOT NULL,
	user_email VARCHAR(255) NOT NULL,
	user_isActive TINYINT NOT NULL DEFAULT '1',
	user_isConfirmed TINYINT NOT NULL DEFAULT '0',
	user_create_date TIMESTAMP NOT NULL DEFAULT ''CURRENT_TIMESTAMP'',
	user_modify_date DATETIME,
	user_isDefault TINYINT NOT NULL DEFAULT '0',
	user_username VARCHAR(50) NOT NULL,
	user_password VARCHAR(255) NOT NULL,
	FKrole_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (user_id),
	INDEX newindex (user_username ASC),
	INDEX FKrole_id (FKrole_id ASC),
	INDEX idx_credentials (user_isActive ASC, user_isConfirmed ASC, user_username ASC, user_password ASC),
	INDEX idx_byEmail (user_isActive ASC, user_isConfirmed ASC, user_email ASC),
	INDEX idx_default (user_isDefault ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_role_permissions
(
	FKpermission_id VARCHAR(36) NOT NULL,
	FKrole_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKpermission_id, FKrole_id),
	INDEX FKpermission_id (FKpermission_id ASC),
	INDEX FKrole_id (FKrole_id ASC),
	INDEX FKpermission_id_2 (FKpermission_id ASC),
	INDEX FKrole_id_2 (FKrole_id ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_pagecontent_category
(
	FKpagecontent_id VARCHAR(36) NOT NULL,
	FKcategory_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKpagecontent_id, FKcategory_id),
	INDEX FKcategory_id (FKcategory_id ASC),
	INDEX FKpagecontent_id (FKpagecontent_id ASC),
	INDEX FKcategory_id_2 (FKcategory_id ASC),
	INDEX FKpagecontent_id_2 (FKpagecontent_id ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_page
(
	page_id VARCHAR(36) NOT NULL,
	page_name VARCHAR(255) NOT NULL,
	FKnamespace_id VARCHAR(36),
	page_title VARCHAR(255),
	page_password VARCHAR(255),
	page_description VARCHAR(255),
	page_keywords VARCHAR(255),
	page_allowcomments TINYINT NOT NULL DEFAULT '1',
	PRIMARY KEY (page_id),
	INDEX FKnamespace_id (FKnamespace_id ASC),
	INDEX FKnamespace_id_2 (FKnamespace_id ASC),
	INDEX idx_wiki_page_name (page_name ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_securityrules
(
	securityrule_id VARCHAR(36) NOT NULL,
	whitelist VARCHAR(255),
	securelist VARCHAR(255),
	permissions VARCHAR(255),
	authorize_check TINYINT NOT NULL DEFAULT '0',
	redirect VARCHAR(255),
	PRIMARY KEY (securityrule_id),
	UNIQUE securityrule_id(securityrule_id)
) TYPE=InnoDB
;


CREATE TABLE wiki_roles
(
	role_id VARCHAR(36) NOT NULL,
	role VARCHAR(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	PRIMARY KEY (role_id)
) TYPE=InnoDB
;


CREATE TABLE wiki_permissions
(
	permission_id VARCHAR(36) NOT NULL,
	permission VARCHAR(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	PRIMARY KEY (permission_id),
	UNIQUE permission(permission)
) TYPE=InnoDB
;


CREATE TABLE wiki_options
(
	option_id VARCHAR(36) NOT NULL,
	option_name VARCHAR(255) NOT NULL,
	option_value TEXT NOT NULL,
	PRIMARY KEY (option_id)
) TYPE=InnoDB
;


CREATE TABLE wiki_namespace
(
	namespace_id VARCHAR(36) NOT NULL,
	namespace_name VARCHAR(255) NOT NULL,
	namespace_description VARCHAR(255) NOT NULL,
	namespace_isdefault TINYINT NOT NULL DEFAULT '0',
	namespace_createddate DATETIME,
	PRIMARY KEY (namespace_id),
	INDEX idx_wiki_namespace_name (namespace_name ASC)
) TYPE=InnoDB
;


CREATE TABLE wiki_customhtml
(
	customHTML_id VARCHAR(36) NOT NULL,
	customHTML_beforeHeadEnd TEXT,
	customHTML_afterBodyStart TEXT,
	customHTML_beforeBodyEnd TEXT,
	customHTML_modify_date DATETIME NOT NULL,
	customHTML_afterSideBar TEXT,
	customHTML_beforeSideBar TEXT,
	PRIMARY KEY (customHTML_id)
) TYPE=InnoDB
;


CREATE TABLE wiki_category
(
	category_id VARCHAR(36) NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	category_createddate DATETIME,
	PRIMARY KEY (category_id),
	INDEX idx_wiki_category_name (category_name ASC)
) TYPE=InnoDB
;





ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_page 
	FOREIGN KEY (FKpage_id) REFERENCES wiki_page (page_id)
;

ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_users 
	FOREIGN KEY (FKuser_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_comments ADD CONSTRAINT wiki_comments_ibfk_1 
	FOREIGN KEY (FKpage_id) REFERENCES wiki_page (page_id)
	ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE wiki_comments ADD CONSTRAINT wiki_comments_ibfk_2 
	FOREIGN KEY (FKuser_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKpermission_id 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKusers_id 
	FOREIGN KEY (FKuser_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_users ADD CONSTRAINT FK_wiki_users_wiki_roles 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FKrole_id 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FK_permissionid 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKcategory_id 
	FOREIGN KEY (FKcategory_id) REFERENCES wiki_category (category_id)
;

ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKpagecontent_id 
	FOREIGN KEY (FKpagecontent_id) REFERENCES wiki_pagecontent (pagecontent_id)
;

ALTER TABLE wiki_page ADD CONSTRAINT FKnamespace_id 
	FOREIGN KEY (FKnamespace_id) REFERENCES wiki_namespace (namespace_id)
;
