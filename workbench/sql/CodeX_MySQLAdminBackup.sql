-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.37-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,ANSI_QUOTES' */;


--
-- Create schema codex
--

CREATE DATABASE IF NOT EXISTS codex;
USE codex;

--
-- Definition of table "wiki_category"
--

DROP TABLE IF EXISTS "wiki_category";
CREATE TABLE "wiki_category" (
  "category_id" varchar(36) NOT NULL,
  "category_name" varchar(255) NOT NULL,
  "category_createddate" datetime default NULL,
  PRIMARY KEY  ("category_id"),
  UNIQUE KEY "category_name" ("category_name"),
  KEY "idx_wiki_category_name" ("category_name")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_category"
--

/*!40000 ALTER TABLE "wiki_category" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_category" ENABLE KEYS */;


--
-- Definition of table "wiki_namespace"
--

DROP TABLE IF EXISTS "wiki_namespace";
CREATE TABLE "wiki_namespace" (
  "namespace_id" varchar(36) NOT NULL,
  "namespace_name" varchar(255) NOT NULL,
  "namespace_description" varchar(255) NOT NULL,
  "namespace_isdefault" tinyint(4) NOT NULL default '0',
  PRIMARY KEY  ("namespace_id"),
  UNIQUE KEY "namespace_name" ("namespace_name"),
  KEY "idx_wiki_namespace_name" ("namespace_name")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_namespace"
--

/*!40000 ALTER TABLE "wiki_namespace" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_namespace" ENABLE KEYS */;


--
-- Definition of table "wiki_page"
--

DROP TABLE IF EXISTS "wiki_page";
CREATE TABLE "wiki_page" (
  "page_id" varchar(36) NOT NULL,
  "page_name" varchar(255) NOT NULL,
  "FKnamespace_id" varchar(36) default NULL,
  PRIMARY KEY  ("page_id"),
  UNIQUE KEY "page_name" ("page_name"),
  KEY "FKnamespace_id" ("FKnamespace_id"),
  KEY "FKnamespace_id_2" ("FKnamespace_id"),
  KEY "idx_wiki_page_name" ("page_name"),
  CONSTRAINT "FKnamespace_id" FOREIGN KEY ("FKnamespace_id") REFERENCES "wiki_namespace" ("namespace_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_page"
--

/*!40000 ALTER TABLE "wiki_page" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_page" ENABLE KEYS */;


--
-- Definition of table "wiki_pagecontent"
--

DROP TABLE IF EXISTS "wiki_pagecontent";
CREATE TABLE "wiki_pagecontent" (
  "pagecontent_id" varchar(36) NOT NULL,
  "FKpage_id" varchar(36) NOT NULL,
  "pagecontent_content" text,
  "pagecontent_comment" text,
  "pagecontent_version" bigint(20) NOT NULL default '1',
  "pagecontent_createdate" datetime NOT NULL,
  "pagecontent_isActive" tinyint(4) NOT NULL default '1',
  PRIMARY KEY  ("pagecontent_id"),
  KEY "FKpage_id" ("FKpage_id"),
  KEY "idx_wiki_pagecontent_isActive" ("pagecontent_isActive"),
  CONSTRAINT "FK_wiki_pagecontent_wiki_page" FOREIGN KEY ("FKpage_id") REFERENCES "wiki_page" ("page_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_pagecontent"
--

/*!40000 ALTER TABLE "wiki_pagecontent" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_pagecontent" ENABLE KEYS */;


--
-- Definition of table "wiki_pagecontent_category"
--

DROP TABLE IF EXISTS "wiki_pagecontent_category";
CREATE TABLE "wiki_pagecontent_category" (
  "FKpagecontent_id" varchar(36) NOT NULL,
  "FKcategory_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpagecontent_id","FKcategory_id"),
  KEY "FKcategory_id" ("FKcategory_id"),
  KEY "FKpagecontent_id" ("FKpagecontent_id"),
  KEY "FKcategory_id_2" ("FKcategory_id"),
  KEY "FKpagecontent_id_2" ("FKpagecontent_id"),
  CONSTRAINT "FKpagecontent_id" FOREIGN KEY ("FKpagecontent_id") REFERENCES "wiki_pagecontent" ("pagecontent_id"),
  CONSTRAINT "FKcategory_id" FOREIGN KEY ("FKcategory_id") REFERENCES "wiki_category" ("category_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_pagecontent_category"
--

/*!40000 ALTER TABLE "wiki_pagecontent_category" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_pagecontent_category" ENABLE KEYS */;


--
-- Definition of table "wiki_permissions"
--

DROP TABLE IF EXISTS "wiki_permissions";
CREATE TABLE "wiki_permissions" (
  "permission_id" varchar(36) NOT NULL,
  "permission" varchar(100) NOT NULL,
  PRIMARY KEY  ("permission_id"),
  UNIQUE KEY "permission" ("permission")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_permissions"
--

/*!40000 ALTER TABLE "wiki_permissions" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_permissions" ENABLE KEYS */;


--
-- Definition of table "wiki_role_permissions"
--

DROP TABLE IF EXISTS "wiki_role_permissions";
CREATE TABLE "wiki_role_permissions" (
  "FKpermission_id" varchar(36) NOT NULL,
  "FKrole_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpermission_id","FKrole_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKrole_id" ("FKrole_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKrole_id_2" ("FKrole_id"),
  CONSTRAINT "FKrole_id" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id"),
  CONSTRAINT "FK_permissionid" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_role_permissions"
--

/*!40000 ALTER TABLE "wiki_role_permissions" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_role_permissions" ENABLE KEYS */;


--
-- Definition of table "wiki_roles"
--

DROP TABLE IF EXISTS "wiki_roles";
CREATE TABLE "wiki_roles" (
  "role_id" varchar(36) NOT NULL,
  "role" varchar(100) NOT NULL,
  PRIMARY KEY  ("role_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_roles"
--

/*!40000 ALTER TABLE "wiki_roles" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_roles" ENABLE KEYS */;


--
-- Definition of table "wiki_securityrules"
--

DROP TABLE IF EXISTS "wiki_securityrules";
CREATE TABLE "wiki_securityrules" (
  "securityrule_id" varchar(36) NOT NULL,
  "whitelist" varchar(255) default NULL,
  "securelist" varchar(255) default NULL,
  "roles" varchar(255) default NULL,
  "redirect" varchar(255) default NULL,
  PRIMARY KEY  ("securityrule_id"),
  UNIQUE KEY "securityrule_id" ("securityrule_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_securityrules"
--

/*!40000 ALTER TABLE "wiki_securityrules" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_securityrules" ENABLE KEYS */;


--
-- Definition of table "wiki_users"
--

DROP TABLE IF EXISTS "wiki_users";
CREATE TABLE "wiki_users" (
  "user_id" varchar(36) NOT NULL,
  "user_fname" varchar(100) NOT NULL,
  "user_lname" varchar(100) NOT NULL,
  "user_email" varchar(255) NOT NULL,
  "user_isActive" tinyint(4) NOT NULL default '1',
  "user_isConfirmed" tinyint(4) NOT NULL default '0',
  "user_create_date" timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  "user_modify_date" datetime default NULL,
  "user_isDefault" tinyint(4) NOT NULL default '0',
  "user_username" varchar(50) NOT NULL,
  "user_password" varchar(50) NOT NULL,
  "FKrole_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("user_id"),
  UNIQUE KEY "user_username" ("user_username"),
  KEY "FKrole_id" ("FKrole_id"),
  CONSTRAINT "FK_wiki_users_wiki_roles" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_users"
--

/*!40000 ALTER TABLE "wiki_users" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_users" ENABLE KEYS */;


--
-- Definition of table "wiki_users_permissions"
--

DROP TABLE IF EXISTS "wiki_users_permissions";
CREATE TABLE "wiki_users_permissions" (
  "FKuser_id" varchar(36) NOT NULL,
  "FKpermission_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKuser_id","FKpermission_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKuser_id" ("FKuser_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKuser_id_2" ("FKuser_id"),
  CONSTRAINT "FKusers_id" FOREIGN KEY ("FKuser_id") REFERENCES "wiki_users" ("user_id"),
  CONSTRAINT "FKpermission_id" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "wiki_users_permissions"
--

/*!40000 ALTER TABLE "wiki_users_permissions" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_users_permissions" ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
