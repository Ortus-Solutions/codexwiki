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
DROP TABLE IF EXISTS wiki_namespace
;
DROP TABLE IF EXISTS wiki_category
;
DROP TABLE IF EXISTS wiki_roles
;
DROP TABLE IF EXISTS wiki_permissions
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
) 
;


CREATE TABLE wiki_pagecontent
(
	pagecontent_id VARCHAR(36) NOT NULL,
	FKpage_id VARCHAR(36) NOT NULL,
	pagecontent_content TEXT NULL,
	pagecontent_version BIGINT NOT NULL DEFAULT 1,
	pagecontent_createdate DATETIME NOT NULL,
	pagecontent_isActive BIT NOT NULL DEFAULT 1,
	PRIMARY KEY (pagecontent_id),
	KEY (FKpage_id),
	INDEX idx_wiki_pagecontent_isActive (pagecontent_isActive ASC)
) 
;


CREATE TABLE wiki_users_permissions
(
	FKusers_id VARCHAR(36) NOT NULL,
	FKpermission_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKusers_id, FKpermission_id),
	KEY (FKpermission_id),
	KEY (FKusers_id),
	KEY (FKpermission_id),
	KEY (FKusers_id)
) 
;


CREATE TABLE wiki_page
(
	page_id VARCHAR(36) NOT NULL,
	page_name VARCHAR(255) NOT NULL,
	FKnamespace_id VARCHAR(36) NULL,
	PRIMARY KEY (page_id),
	UNIQUE (page_name),
	KEY (FKnamespace_id),
	KEY (FKnamespace_id),
	INDEX idx_wiki_page_name (page_name ASC)
) 
;


CREATE TABLE wiki_users
(
	user_id VARCHAR(36) NOT NULL,
	user_fname VARCHAR(100) NOT NULL,
	user_lname VARCHAR(100) NOT NULL,
	user_email VARCHAR(255) NOT NULL,
	user_active BIT NOT NULL DEFAULT 1,
	user_confirmed BIT NOT NULL DEFAULT 0,
	user_create_date TIMESTAMP NOT NULL,
	user_modify_date DATETIME NULL,
	FKrole_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (user_id),
	KEY (FKrole_id)
) 
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
) 
;


CREATE TABLE wiki_namespace
(
	namespace_id VARCHAR(36) NOT NULL,
	namespace_name VARCHAR(255) NOT NULL,
	namespace_description VARCHAR(255) NOT NULL,
	namespace_isdefault BIT NOT NULL DEFAULT 0,
	PRIMARY KEY (namespace_id),
	UNIQUE (namespace_name),
	INDEX idx_wiki_namespace_name (namespace_name ASC)
) 
;


CREATE TABLE wiki_category
(
	category_id VARCHAR(36) NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	category_createddate DATETIME NULL,
	PRIMARY KEY (category_id),
	UNIQUE (category_name),
	INDEX idx_wiki_category_name (category_name ASC)
) 
;


CREATE TABLE wiki_roles
(
	role_id VARCHAR(36) NOT NULL,
	role VARCHAR(100) NOT NULL,
	PRIMARY KEY (role_id)
) 
;


CREATE TABLE wiki_permissions
(
	permission_id VARCHAR(36) NOT NULL,
	permission VARCHAR(100) NOT NULL,
	active BIT NOT NULL DEFAULT 1,
	PRIMARY KEY (permission_id),
	UNIQUE (permission)
) 
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

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKpermission_id 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_users_permissions ADD CONSTRAINT FKusers_id 
	FOREIGN KEY (FKusers_id) REFERENCES wiki_users (user_id)
;

ALTER TABLE wiki_page ADD CONSTRAINT FKnamespace_id 
	FOREIGN KEY (FKnamespace_id) REFERENCES wiki_namespace (namespace_id)
;

ALTER TABLE wiki_users ADD CONSTRAINT FK_wiki_users_wiki_roles 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FKpermission_id 
	FOREIGN KEY (FKpermission_id) REFERENCES wiki_permissions (permission_id)
;

ALTER TABLE wiki_role_permissions ADD CONSTRAINT FKrole_id 
	FOREIGN KEY (FKrole_id) REFERENCES wiki_roles (role_id)
;
