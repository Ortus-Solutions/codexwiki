IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.wiki_comments_ibfk_1') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_comments DROP CONSTRAINT wiki_comments_ibfk_1
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.wiki_comments_ibfk_2') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_comments DROP CONSTRAINT wiki_comments_ibfk_2
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKnamespace_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_page DROP CONSTRAINT FKnamespace_id
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FK_wiki_pagecontent_wiki_page') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_pagecontent DROP CONSTRAINT FK_wiki_pagecontent_wiki_page
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FK_wiki_pagecontent_wiki_users') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_pagecontent DROP CONSTRAINT FK_wiki_pagecontent_wiki_users
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKcategory_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_pagecontent_category DROP CONSTRAINT FKcategory_id
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKpagecontent_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_pagecontent_category DROP CONSTRAINT FKpagecontent_id
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKrole_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_role_permissions DROP CONSTRAINT FKrole_id
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FK_permissionid') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_role_permissions DROP CONSTRAINT FK_permissionid
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FK_wiki_users_wiki_roles') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_users DROP CONSTRAINT FK_wiki_users_wiki_roles
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKpermission_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_users_permissions DROP CONSTRAINT FKpermission_id
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('dbo.FKusers_id') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE dbo.wiki_users_permissions DROP CONSTRAINT FKusers_id
;


IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_category') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_category
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_comments') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_comments
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_customhtml') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_customhtml
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_namespace') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_namespace
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_options') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_options
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_page') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_page
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_pagecontent') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_pagecontent
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_pagecontent_category') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_pagecontent_category
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_permissions') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_permissions
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_role_permissions') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_role_permissions
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_roles') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_roles
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_securityrules') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_securityrules
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_users') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_users
;

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('dbo.wiki_users_permissions') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE dbo.wiki_users_permissions
;




CREATE TABLE dbo.wiki_category ( 
	category_id varchar(36) NOT NULL,
	category_name varchar(255) NOT NULL,
	category_createddate datetime
)
;

CREATE TABLE dbo.wiki_comments ( 
	comment_id varchar(36) NOT NULL,
	FKpage_id varchar(36) NOT NULL,
	comment_content text NOT NULL,
	comment_author varchar(255),
	comment_author_email varchar(255),
	comment_author_url varchar(255),
	comment_author_ip varchar(100),
	comment_createdate datetime NOT NULL,
	comment_isActive tinyint DEFAULT '1' NOT NULL,
	comment_isApproved tinyint DEFAULT '0' NOT NULL,
	FKuser_id varchar(36)
)
;

CREATE TABLE dbo.wiki_customhtml ( 
	customHTML_id varchar(36) NOT NULL,
	customHTML_beforeHeadEnd text,
	customHTML_afterBodyStart text,
	customHTML_beforeBodyEnd text,
	customHTML_modify_date datetime NOT NULL,
	customHTML_afterSideBar text,
	customHTML_beforeSideBar text
)
;

CREATE TABLE dbo.wiki_namespace ( 
	namespace_id varchar(36) NOT NULL,
	namespace_name varchar(255) NOT NULL,
	namespace_description varchar(255) NOT NULL,
	namespace_isdefault tinyint DEFAULT '0' NOT NULL,
	namespace_createddate datetime
)
;

CREATE TABLE dbo.wiki_options ( 
	option_id varchar(36) NOT NULL,
	option_name varchar(255) NOT NULL,
	option_value text NOT NULL
)
;

CREATE TABLE dbo.wiki_page ( 
	page_id varchar(36) NOT NULL,
	page_name varchar(255) NOT NULL,
	FKnamespace_id varchar(36),
	page_title varchar(255),
	page_password varchar(255),
	page_description varchar(255),
	page_keywords varchar(255),
	page_allowcomments tinyint DEFAULT '1' NOT NULL
)
;

CREATE TABLE dbo.wiki_pagecontent ( 
	pagecontent_id varchar(36) NOT NULL,
	FKpage_id varchar(36) NOT NULL,
	FKuser_id varchar(36) NOT NULL,
	pagecontent_content text,
	pagecontent_comment text,
	pagecontent_version bigint DEFAULT '1' NOT NULL,
	pagecontent_createdate datetime NOT NULL,
	pagecontent_isActive tinyint DEFAULT '1' NOT NULL,
	pagecontent_isReadOnly tinyint DEFAULT '0' NOT NULL
)
;

CREATE TABLE dbo.wiki_pagecontent_category ( 
	FKpagecontent_id varchar(36) NOT NULL,
	FKcategory_id varchar(36) NOT NULL
)
;

CREATE TABLE dbo.wiki_permissions ( 
	permission_id varchar(36) NOT NULL,
	permission varchar(100) NOT NULL,
	description varchar(255) NOT NULL
)
;

CREATE TABLE dbo.wiki_role_permissions ( 
	FKpermission_id varchar(36) NOT NULL,
	FKrole_id varchar(36) NOT NULL
)
;

CREATE TABLE dbo.wiki_roles ( 
	role_id varchar(36) NOT NULL,
	role varchar(100) NOT NULL,
	description varchar(255) NOT NULL
)
;

CREATE TABLE dbo.wiki_securityrules ( 
	securityrule_id varchar(36) NOT NULL,
	whitelist varchar(255),
	securelist varchar(255),
	permissions varchar(255),
	authorize_check tinyint DEFAULT '0' NOT NULL,
	redirect varchar(255)
)
;

CREATE TABLE dbo.wiki_users ( 
	user_id varchar(36) NOT NULL,
	user_fname varchar(100) NOT NULL,
	user_lname varchar(100) NOT NULL,
	user_email varchar(255) NOT NULL,
	user_isActive tinyint DEFAULT '1' NOT NULL,
	user_isConfirmed tinyint DEFAULT '0' NOT NULL,
	user_create_date datetime DEFAULT getDate() NOT NULL,
	user_modify_date datetime,
	user_isDefault tinyint DEFAULT '0' NOT NULL,
	user_username varchar(50) NOT NULL,
	user_password varchar(255) NOT NULL,
	FKrole_id varchar(36) NOT NULL
)
;

CREATE TABLE dbo.wiki_users_permissions ( 
	FKuser_id varchar(36) NOT NULL,
	FKpermission_id varchar(36) NOT NULL
)
;


ALTER TABLE dbo.wiki_category ADD CONSTRAINT PK_wiki_category 
	PRIMARY KEY CLUSTERED (category_id)
;

ALTER TABLE dbo.wiki_comments ADD CONSTRAINT PK_wiki_comments 
	PRIMARY KEY CLUSTERED (comment_id)
;

ALTER TABLE dbo.wiki_customhtml ADD CONSTRAINT PK_wiki_customhtml 
	PRIMARY KEY CLUSTERED (customHTML_id)
;

ALTER TABLE dbo.wiki_namespace ADD CONSTRAINT PK_wiki_namespace 
	PRIMARY KEY CLUSTERED (namespace_id)
;

ALTER TABLE dbo.wiki_options ADD CONSTRAINT PK_wiki_options 
	PRIMARY KEY CLUSTERED (option_id)
;

ALTER TABLE dbo.wiki_page ADD CONSTRAINT PK_wiki_page 
	PRIMARY KEY CLUSTERED (page_id)
;

ALTER TABLE dbo.wiki_pagecontent ADD CONSTRAINT PK_wiki_pagecontent 
	PRIMARY KEY CLUSTERED (pagecontent_id)
;

ALTER TABLE dbo.wiki_pagecontent_category ADD CONSTRAINT PK_wiki_pagecontent_category 
	PRIMARY KEY CLUSTERED (FKpagecontent_id, FKcategory_id)
;

ALTER TABLE dbo.wiki_permissions ADD CONSTRAINT PK_wiki_permissions 
	PRIMARY KEY CLUSTERED (permission_id)
;

ALTER TABLE dbo.wiki_role_permissions ADD CONSTRAINT PK_wiki_role_permissions 
	PRIMARY KEY CLUSTERED (FKpermission_id, FKrole_id)
;

ALTER TABLE dbo.wiki_roles ADD CONSTRAINT PK_wiki_roles 
	PRIMARY KEY CLUSTERED (role_id)
;

ALTER TABLE dbo.wiki_securityrules ADD CONSTRAINT PK_wiki_securityrules 
	PRIMARY KEY CLUSTERED (securityrule_id)
;

ALTER TABLE dbo.wiki_users ADD CONSTRAINT PK_wiki_users 
	PRIMARY KEY CLUSTERED (user_id)
;

ALTER TABLE dbo.wiki_users_permissions ADD CONSTRAINT PK_wiki_users_permissions 
	PRIMARY KEY CLUSTERED (FKuser_id, FKpermission_id)
;


CREATE INDEX idx_wiki_category_name
ON dbo.wiki_category (category_name ASC)
;

CREATE INDEX idx_createdate
ON dbo.wiki_comments (comment_createdate ASC)
;

CREATE INDEX idx_pagecomments
ON dbo.wiki_comments (FKpage_id ASC, comment_isActive ASC, comment_isApproved ASC)
;

CREATE INDEX FKpage_id
ON dbo.wiki_comments (FKpage_id ASC)
;

CREATE INDEX FKuser_id
ON dbo.wiki_comments (FKuser_id ASC)
;

CREATE INDEX idx_wiki_namespace_name
ON dbo.wiki_namespace (namespace_name ASC)
;

CREATE INDEX FKnamespace_id
ON dbo.wiki_page (FKnamespace_id ASC)
;

CREATE INDEX FKnamespace_id_2
ON dbo.wiki_page (FKnamespace_id ASC)
;

CREATE INDEX idx_wiki_page_name
ON dbo.wiki_page (page_name ASC)
;

CREATE INDEX FKpage_id
ON dbo.wiki_pagecontent (FKpage_id ASC)
;

CREATE INDEX FKuser_id
ON dbo.wiki_pagecontent (FKuser_id ASC)
;

CREATE INDEX idx_wiki_pagecontent_isActive
ON dbo.wiki_pagecontent (pagecontent_isActive ASC)
;

CREATE INDEX FKcategory_id
ON dbo.wiki_pagecontent_category (FKcategory_id ASC)
;

CREATE INDEX FKpagecontent_id
ON dbo.wiki_pagecontent_category (FKpagecontent_id ASC)
;

CREATE INDEX FKcategory_id_2
ON dbo.wiki_pagecontent_category (FKcategory_id ASC)
;

CREATE INDEX FKpagecontent_id_2
ON dbo.wiki_pagecontent_category (FKpagecontent_id ASC)
;

ALTER TABLE dbo.wiki_permissions
	ADD CONSTRAINT permission UNIQUE (permission)
;

CREATE INDEX FKpermission_id
ON dbo.wiki_role_permissions (FKpermission_id ASC)
;

CREATE INDEX FKrole_id
ON dbo.wiki_role_permissions (FKrole_id ASC)
;

CREATE INDEX FKpermission_id_2
ON dbo.wiki_role_permissions (FKpermission_id ASC)
;

CREATE INDEX FKrole_id_2
ON dbo.wiki_role_permissions (FKrole_id ASC)
;

ALTER TABLE dbo.wiki_securityrules
	ADD CONSTRAINT securityrule_id UNIQUE (securityrule_id)
;

CREATE INDEX newindex
ON dbo.wiki_users (user_username ASC)
;

CREATE INDEX FKrole_id
ON dbo.wiki_users (FKrole_id ASC)
;

CREATE INDEX idx_credentials
ON dbo.wiki_users (user_isActive ASC, user_isConfirmed ASC, user_username ASC, user_password ASC)
;

CREATE INDEX idx_byEmail
ON dbo.wiki_users (user_isActive ASC, user_isConfirmed ASC, user_email ASC)
;

CREATE INDEX idx_default
ON dbo.wiki_users (user_isDefault ASC)
;

CREATE INDEX FKpermission_id
ON dbo.wiki_users_permissions (FKpermission_id ASC)
;

CREATE INDEX FKuser_id
ON dbo.wiki_users_permissions (FKuser_id ASC)
;

CREATE INDEX FKpermission_id_2
ON dbo.wiki_users_permissions (FKpermission_id ASC)
;

CREATE INDEX FKuser_id_2
ON dbo.wiki_users_permissions (FKuser_id ASC)
;


ALTER TABLE dbo.wiki_comments ADD CONSTRAINT wiki_comments_ibfk_1 
	FOREIGN KEY (FKpage_id) REFERENCES dbo.wiki_page (page_id)
;

ALTER TABLE dbo.wiki_comments ADD CONSTRAINT wiki_comments_ibfk_2 
	FOREIGN KEY (FKuser_id) REFERENCES dbo.wiki_users (user_id)
;

ALTER TABLE dbo.wiki_page ADD CONSTRAINT FKnamespace_id 
	FOREIGN KEY (FKnamespace_id) REFERENCES dbo.wiki_namespace (namespace_id)
;

ALTER TABLE dbo.wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_page 
	FOREIGN KEY (FKpage_id) REFERENCES dbo.wiki_page (page_id)
;

ALTER TABLE dbo.wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_users 
	FOREIGN KEY (FKuser_id) REFERENCES dbo.wiki_users (user_id)
;

ALTER TABLE dbo.wiki_pagecontent_category ADD CONSTRAINT FKcategory_id 
	FOREIGN KEY (FKcategory_id) REFERENCES dbo.wiki_category (category_id)
;

ALTER TABLE dbo.wiki_pagecontent_category ADD CONSTRAINT FKpagecontent_id 
	FOREIGN KEY (FKpagecontent_id) REFERENCES dbo.wiki_pagecontent (pagecontent_id)
;

ALTER TABLE dbo.wiki_role_permissions ADD CONSTRAINT FKrole_id 
	FOREIGN KEY (FKrole_id) REFERENCES dbo.wiki_roles (role_id)
;

ALTER TABLE dbo.wiki_role_permissions ADD CONSTRAINT FK_permissionid 
	FOREIGN KEY (FKpermission_id) REFERENCES dbo.wiki_permissions (permission_id)
;

ALTER TABLE dbo.wiki_users ADD CONSTRAINT FK_wiki_users_wiki_roles 
	FOREIGN KEY (FKrole_id) REFERENCES dbo.wiki_roles (role_id)
;

ALTER TABLE dbo.wiki_users_permissions ADD CONSTRAINT FKpermission_id 
	FOREIGN KEY (FKpermission_id) REFERENCES dbo.wiki_permissions (permission_id)
;

ALTER TABLE dbo.wiki_users_permissions ADD CONSTRAINT FKusers_id 
	FOREIGN KEY (FKuser_id) REFERENCES dbo.wiki_users (user_id)
;
