DROP TABLE IF EXISTS wiki_pagecontent_category
;
DROP TABLE IF EXISTS wiki_pagecontent
;
DROP TABLE IF EXISTS wiki_users_permissions
;
DROP TABLE IF EXISTS wiki_page
;
DROP TABLE IF EXISTS wiki_users
;
DROP TABLE IF EXISTS wiki_role_permissions
;
DROP TABLE IF EXISTS wiki_options
;
DROP TABLE IF EXISTS wiki_namespace
;
DROP TABLE IF EXISTS wiki_customHTML
;
DROP TABLE IF EXISTS wiki_category
;



CREATE TABLE wiki_pagecontent_category
(
	FKpagecontent_id VARCHAR(36) NOT NULL,
	FKcategory_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKpagecontent_id, FKcategory_id),
	KEY (FKcategory_id),
	KEY (FKpagecontent_id),
	KEY (FKcategory_id),
	KEY (FKpagecontent_id)
) ENGINE=InnoDB
;


CREATE TABLE wiki_pagecontent
(
	pagecontent_id VARCHAR(36) NOT NULL,
	FKpage_id VARCHAR(36) NOT NULL,
	FKuser_id VARCHAR(36) NOT NULL,
	pagecontent_content TEXT,
	pagecontent_comment TEXT,
	pagecontent_version BIGINT NOT NULL DEFAULT 1,
	pagecontent_createdate DATETIME NOT NULL,
	pagecontent_isActive TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY (pagecontent_id),
	KEY (FKpage_id),
	KEY (FKuser_id),
	INDEX idx_wiki_pagecontent_isActive (pagecontent_isActive ASC)
) ENGINE=InnoDB
;


CREATE TABLE wiki_users_permissions
(
	FKuser_id VARCHAR(36) NOT NULL,
	FKpermission_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKuser_id, FKpermission_id),
	KEY (FKpermission_id),
	KEY (FKuser_id),
	KEY (FKpermission_id),
	KEY (FKuser_id)
) ENGINE=InnoDB
;


CREATE TABLE wiki_page
(
	page_id VARCHAR(36) NOT NULL,
	page_name VARCHAR(255) NOT NULL,
	FKnamespace_id VARCHAR(36),
	PRIMARY KEY (page_id),
	UNIQUE (page_name),
	KEY (FKnamespace_id),
	KEY (FKnamespace_id),
	INDEX idx_wiki_page_name (page_name ASC)
) ENGINE=InnoDB
;


CREATE TABLE wiki_users
(
	user_id VARCHAR(36) NOT NULL,
	user_fname VARCHAR(100) NOT NULL,
	user_lname VARCHAR(100) NOT NULL,
	user_email VARCHAR(255) NOT NULL,
	user_isActive TINYINT NOT NULL DEFAULT 1,
	user_isConfirmed TINYINT NOT NULL DEFAULT 0,
	user_create_date TIMESTAMP NOT NULL,
	user_modify_date DATETIME,
	user_isDefault TINYINT NOT NULL DEFAULT 0,
	user_username VARCHAR(50) NOT NULL,
	user_password VARCHAR(255) NOT NULL,
	FKrole_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (user_id),
	UNIQUE (user_username),
	KEY (FKrole_id),
	INDEX idx_credentials (user_isActive ASC, user_isConfirmed ASC, user_username ASC, user_password ASC),
	INDEX idx_byEmail (user_isActive ASC, user_isConfirmed ASC, user_email ASC),
	INDEX idx_default (user_isDefault ASC)
) ENGINE=InnoDB
;


CREATE TABLE wiki_role_permissions
(
	FKpermission_id VARCHAR(36) NOT NULL,
	FKrole_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKpermission_id, FKrole_id),
	KEY (FKpermission_id),
	KEY (FKrole_id),
	KEY (FKpermission_id),
	KEY (FKrole_id)
) ENGINE=InnoDB
;


CREATE TABLE wiki_options
(
	options_id VARCHAR(36) NOT NULL,
	option_name VARCHAR(255),
	option_value TEXT,
	PRIMARY KEY (options_id)
) ENGINE=InnoDB
;


CREATE TABLE wiki_namespace
(
	namespace_id VARCHAR(36) NOT NULL,
	namespace_name VARCHAR(255) NOT NULL,
	namespace_description VARCHAR(255) NOT NULL,
	namespace_isdefault TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (namespace_id),
	UNIQUE (namespace_name),
	INDEX idx_wiki_namespace_name (namespace_name ASC)
) ENGINE=InnoDB
;


CREATE TABLE wiki_customHTML
(
	customHTML_id VARCHAR(36) NOT NULL,
	customHTML_beforeHeadEnd TEXT,
	customHTML_afterBodyStart TEXT,
	customHTML_beforeBodyEnd TEXT,
	customHTML_modify_date DATETIME NOT NULL,
	PRIMARY KEY (customHTML_id)
) ENGINE=InnoDB
;


CREATE TABLE wiki_category
(
	category_id VARCHAR(36) NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	category_createddate DATETIME,
	PRIMARY KEY (category_id),
	UNIQUE (category_name),
	INDEX idx_wiki_category_name (category_name ASC)
) ENGINE=InnoDB
;






ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKcategory_id 
	FOREIGN KEY (FKcategory_id) REFERENCES wiki_category (category_id)
;

ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKpagecontent_id 
	FOREIGN KEY (FKpagecontent_id) REFERENCES wiki_pagecontent (pagecontent_id)
;

ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_page 
	FOREIGN KEY (FKpage_id) REFERENCES wiki_page (page_id)
;

ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_users 
	FOREIGN KEY (FKuser_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKpermission_id 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKusers_id 
	FOREIGN KEY (FKuser_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_page ADD CONSTRAINT FKnamespace_id 
	FOREIGN KEY (FKnamespace_id) REFERENCES wiki_namespace (namespace_id)
;

ALTER TABLE wiki_users ADD CONSTRAINT FK_wiki_users_wiki_roles 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FK_permissionid 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FKrole_id 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;
