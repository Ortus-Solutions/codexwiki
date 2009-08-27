-- SQL Manager 2008 Lite for SQL Server 3.3.0.3
-- ---------------------------------------
-- Host      : icepick\SQLEXPRESS
-- Database  : codex
-- Version   : Microsoft SQL Server  10.0.1600.22


--
-- Dropping table wiki_category : 
--

DROP TABLE [dbo].[wiki_category]
GO

--
-- Dropping table wiki_comments : 
--

DROP TABLE [dbo].[wiki_comments]
GO

--
-- Dropping table wiki_customhtml : 
--

DROP TABLE [dbo].[wiki_customhtml]
GO

--
-- Dropping table wiki_namespace : 
--

DROP TABLE [dbo].[wiki_namespace]
GO

--
-- Dropping table wiki_options : 
--

DROP TABLE [dbo].[wiki_options]
GO

--
-- Dropping table wiki_page : 
--

DROP TABLE [dbo].[wiki_page]
GO

--
-- Dropping table wiki_pagecontent : 
--

DROP TABLE [dbo].[wiki_pagecontent]
GO

--
-- Dropping table wiki_pagecontent_category : 
--

DROP TABLE [dbo].[wiki_pagecontent_category]
GO

--
-- Dropping table wiki_permissions : 
--

DROP TABLE [dbo].[wiki_permissions]
GO

--
-- Dropping table wiki_role_permissions : 
--

DROP TABLE [dbo].[wiki_role_permissions]
GO

--
-- Dropping table wiki_roles : 
--

DROP TABLE [dbo].[wiki_roles]
GO

--
-- Dropping table wiki_securityrules : 
--

DROP TABLE [dbo].[wiki_securityrules]
GO

--
-- Dropping table wiki_users : 
--

DROP TABLE [dbo].[wiki_users]
GO

--
-- Dropping table wiki_users_permissions : 
--

DROP TABLE [dbo].[wiki_users_permissions]
GO

ALTER TABLE [dbo].[wiki_users_permissions]
DROP CONSTRAINT [PK_wiki_users_permissions]
GO

DROP INDEX [FKuser_id_2] ON [dbo].[wiki_users_permissions]
GO

DROP INDEX [FKuser_id] ON [dbo].[wiki_users_permissions]
GO

DROP INDEX [FKpermission_id_2] ON [dbo].[wiki_users_permissions]
GO

DROP INDEX [FKpermission_id] ON [dbo].[wiki_users_permissions]
GO

ALTER TABLE [dbo].[wiki_users]
DROP CONSTRAINT [PK_wiki_users]
GO

DROP INDEX [newindex] ON [dbo].[wiki_users]
GO

DROP INDEX [idx_default] ON [dbo].[wiki_users]
GO

DROP INDEX [idx_credentials] ON [dbo].[wiki_users]
GO

DROP INDEX [idx_byEmail] ON [dbo].[wiki_users]
GO

DROP INDEX [FKrole_id] ON [dbo].[wiki_users]
GO

ALTER TABLE [dbo].[wiki_securityrules]
DROP CONSTRAINT [securityrule_id]
GO

ALTER TABLE [dbo].[wiki_securityrules]
DROP CONSTRAINT [PK_wiki_securityrules]
GO

ALTER TABLE [dbo].[wiki_roles]
DROP CONSTRAINT [PK_wiki_roles]
GO

ALTER TABLE [dbo].[wiki_role_permissions]
DROP CONSTRAINT [PK_wiki_role_permissions]
GO

DROP INDEX [FKrole_id_2] ON [dbo].[wiki_role_permissions]
GO

DROP INDEX [FKrole_id] ON [dbo].[wiki_role_permissions]
GO

DROP INDEX [FKpermission_id_2] ON [dbo].[wiki_role_permissions]
GO

DROP INDEX [FKpermission_id] ON [dbo].[wiki_role_permissions]
GO

ALTER TABLE [dbo].[wiki_permissions]
DROP CONSTRAINT [PK_wiki_permissions]
GO

ALTER TABLE [dbo].[wiki_permissions]
DROP CONSTRAINT [permission]
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
DROP CONSTRAINT [PK_wiki_pagecontent_category]
GO

DROP INDEX [FKpagecontent_id_2] ON [dbo].[wiki_pagecontent_category]
GO

DROP INDEX [FKpagecontent_id] ON [dbo].[wiki_pagecontent_category]
GO

DROP INDEX [FKcategory_id_2] ON [dbo].[wiki_pagecontent_category]
GO

DROP INDEX [FKcategory_id] ON [dbo].[wiki_pagecontent_category]
GO

ALTER TABLE [dbo].[wiki_pagecontent]
DROP CONSTRAINT [PK_wiki_pagecontent]
GO

DROP INDEX [idx_wiki_pagecontent_isActive] ON [dbo].[wiki_pagecontent]
GO

DROP INDEX [FKuser_id] ON [dbo].[wiki_pagecontent]
GO

DROP INDEX [FKpage_id] ON [dbo].[wiki_pagecontent]
GO

ALTER TABLE [dbo].[wiki_page]
DROP CONSTRAINT [PK_wiki_page]
GO

DROP INDEX [idx_wiki_page_name] ON [dbo].[wiki_page]
GO

DROP INDEX [FKnamespace_id_2] ON [dbo].[wiki_page]
GO

DROP INDEX [FKnamespace_id] ON [dbo].[wiki_page]
GO

ALTER TABLE [dbo].[wiki_options]
DROP CONSTRAINT [PK_wiki_options]
GO

ALTER TABLE [dbo].[wiki_namespace]
DROP CONSTRAINT [PK_wiki_namespace]
GO

DROP INDEX [idx_wiki_namespace_name] ON [dbo].[wiki_namespace]
GO

ALTER TABLE [dbo].[wiki_customhtml]
DROP CONSTRAINT [PK_wiki_customhtml]
GO

ALTER TABLE [dbo].[wiki_comments]
DROP CONSTRAINT [PK_wiki_comments]
GO

DROP INDEX [idx_pagecomments] ON [dbo].[wiki_comments]
GO

DROP INDEX [idx_createdate] ON [dbo].[wiki_comments]
GO

DROP INDEX [FKuser_id] ON [dbo].[wiki_comments]
GO

DROP INDEX [FKpage_id] ON [dbo].[wiki_comments]
GO

ALTER TABLE [dbo].[wiki_category]
DROP CONSTRAINT [PK_wiki_category]
GO

DROP INDEX [idx_wiki_category_name] ON [dbo].[wiki_category]
GO

ALTER TABLE [dbo].[wiki_users_permissions]
DROP CONSTRAINT [FKusers_id]
GO

ALTER TABLE [dbo].[wiki_users_permissions]
DROP CONSTRAINT [FKpermission_id]
GO

ALTER TABLE [dbo].[wiki_users]
DROP CONSTRAINT [FK_wiki_users_wiki_roles]
GO

ALTER TABLE [dbo].[wiki_role_permissions]
DROP CONSTRAINT [FKrole_id]
GO

ALTER TABLE [dbo].[wiki_role_permissions]
DROP CONSTRAINT [FK_permissionid]
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
DROP CONSTRAINT [FKpagecontent_id]
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
DROP CONSTRAINT [FKcategory_id]
GO

ALTER TABLE [dbo].[wiki_pagecontent]
DROP CONSTRAINT [FK_wiki_pagecontent_wiki_users]
GO

ALTER TABLE [dbo].[wiki_pagecontent]
DROP CONSTRAINT [FK_wiki_pagecontent_wiki_page]
GO

ALTER TABLE [dbo].[wiki_page]
DROP CONSTRAINT [FKnamespace_id]
GO

ALTER TABLE [dbo].[wiki_comments]
DROP CONSTRAINT [wiki_comments_ibfk_2]
GO

ALTER TABLE [dbo].[wiki_comments]
DROP CONSTRAINT [wiki_comments_ibfk_1]
GO

--
-- Definition for table wiki_category : 
--

CREATE TABLE [dbo].[wiki_category] (
  [category_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [category_name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [category_createddate] datetime NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_comments : 
--

CREATE TABLE [dbo].[wiki_comments] (
  [comment_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKpage_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [comment_content] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [comment_author] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [comment_author_email] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [comment_author_url] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [comment_author_ip] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [comment_createdate] datetime NOT NULL,
  [comment_isActive] bit CONSTRAINT [DF__wiki_comm__comme__7F60ED59] DEFAULT '1' NOT NULL,
  [comment_isApproved] bit CONSTRAINT [DF__wiki_comm__comme__00551192] DEFAULT '0' NOT NULL,
  [FKuser_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Definition for table wiki_customhtml : 
--

CREATE TABLE [dbo].[wiki_customhtml] (
  [customHTML_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [customHTML_beforeHeadEnd] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [customHTML_afterBodyStart] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [customHTML_beforeBodyEnd] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [customHTML_modify_date] datetime NOT NULL,
  [customHTML_afterSideBar] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [customHTML_beforeSideBar] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Definition for table wiki_namespace : 
--

CREATE TABLE [dbo].[wiki_namespace] (
  [namespace_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [namespace_name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [namespace_description] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [namespace_isdefault] bit CONSTRAINT [DF__wiki_name__names__03317E3D] DEFAULT '0' NOT NULL,
  [namespace_createddate] datetime NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_options : 
--

CREATE TABLE [dbo].[wiki_options] (
  [option_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [option_name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [option_value] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Definition for table wiki_page : 
--

CREATE TABLE [dbo].[wiki_page] (
  [page_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [page_name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKnamespace_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [page_title] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [page_password] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [page_description] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [page_keywords] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [page_allowcomments] bit CONSTRAINT [DF__wiki_page__page___060DEAE8] DEFAULT '1' NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_pagecontent : 
--

CREATE TABLE [dbo].[wiki_pagecontent] (
  [pagecontent_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKpage_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKuser_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [pagecontent_content] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [pagecontent_comment] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [pagecontent_version] bigint CONSTRAINT [DF__wiki_page__pagec__07F6335A] DEFAULT '1' NOT NULL,
  [pagecontent_createdate] datetime NOT NULL,
  [pagecontent_isActive] bit CONSTRAINT [DF__wiki_page__pagec__08EA5793] DEFAULT '1' NOT NULL,
  [pagecontent_isReadOnly] bit CONSTRAINT [DF__wiki_page__pagec__09DE7BCC] DEFAULT '0' NOT NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Definition for table wiki_pagecontent_category : 
--

CREATE TABLE [dbo].[wiki_pagecontent_category] (
  [FKpagecontent_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKcategory_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_permissions : 
--

CREATE TABLE [dbo].[wiki_permissions] (
  [permission_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [permission] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [description] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_role_permissions : 
--

CREATE TABLE [dbo].[wiki_role_permissions] (
  [FKpermission_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKrole_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_roles : 
--

CREATE TABLE [dbo].[wiki_roles] (
  [role_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [role] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [description] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_securityrules : 
--

CREATE TABLE [dbo].[wiki_securityrules] (
  [securityrule_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [whitelist] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [securelist] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [permissions] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [authorize_check] bit CONSTRAINT [DF__wiki_secu__autho__0F975522] DEFAULT '0' NOT NULL,
  [redirect] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_users : 
--

CREATE TABLE [dbo].[wiki_users] (
  [user_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [user_fname] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [user_lname] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [user_email] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [user_isActive] bit CONSTRAINT [DF__wiki_user__user___117F9D94] DEFAULT '1' NOT NULL,
  [user_isConfirmed] bit CONSTRAINT [DF__wiki_user__user___1273C1CD] DEFAULT '0' NOT NULL,
  [user_create_date] datetime CONSTRAINT [DF__wiki_user__user___1367E606] DEFAULT getdate() NOT NULL,
  [user_modify_date] datetime NULL,
  [user_isDefault] bit CONSTRAINT [DF__wiki_user__user___145C0A3F] DEFAULT '0' NOT NULL,
  [user_username] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [user_password] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKrole_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table wiki_users_permissions : 
--

CREATE TABLE [dbo].[wiki_users_permissions] (
  [FKuser_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FKpermission_id] varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Data for table dbo.wiki_customhtml  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_customhtml] ([customHTML_id], [customHTML_beforeHeadEnd], [customHTML_afterBodyStart], [customHTML_beforeBodyEnd], [customHTML_modify_date], [customHTML_afterSideBar], [customHTML_beforeSideBar])
VALUES 
  (N'64597197-CF1E-5C1B-91F2B0710FA5B5B3', N'', N'', N'', '20080509 13:40:34', N'', N'')
GO

--
-- Data for table dbo.wiki_namespace  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_namespace] ([namespace_id], [namespace_name], [namespace_description], [namespace_isdefault], [namespace_createddate])
VALUES 
  (N'06AF3D1C-0B00-EAA3-09A138DFA27F7E28', N'Special', N'Special', 0, '20090218 09:18:58')
GO

INSERT INTO [dbo].[wiki_namespace] ([namespace_id], [namespace_name], [namespace_description], [namespace_isdefault], [namespace_createddate])
VALUES 
  (N'58F2F981-F62A-3124-E886BBF8CE6C5295', N'Help', N'Help', 0, '20090218 09:18:58')
GO

INSERT INTO [dbo].[wiki_namespace] ([namespace_id], [namespace_name], [namespace_description], [namespace_isdefault], [namespace_createddate])
VALUES 
  (N'75D11EE4-8FD9-463C-8892FC02BD905735', N'Template', N'Template', 0, '20090218 09:18:58')
GO

INSERT INTO [dbo].[wiki_namespace] ([namespace_id], [namespace_name], [namespace_description], [namespace_isdefault], [namespace_createddate])
VALUES 
  (N'F1C0292E-CB06-FD09-41D904E8550FE734', N'', N'Default Namespace', 1, '20090218 09:18:58')
GO

--
-- Data for table dbo.wiki_options  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'3331E8AF-F41F-4CF5-A2F519959BF4342B', N'wiki_gravatar_display', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'3FFE012E-7228-44F7-B4D3FC088892EB45', N'comments_notify', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'704DD976-B03B-441B-A0B7B5C8403034C9', N'comments_registration', N'false')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'7AB2BC87-9D28-45ED-BDAD2A64BEFBF3A4', N'comments_enabled', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'8D3CA636-2439-4D69-A2724617C8854718', N'comments_urltranslations', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F03F883-AFFA-A78C-1A2EDA50675A3B46', N'wiki_defaultpage', N'Dashboard')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F045002-0E99-A690-7C59F405F98A19BE', N'wiki_search_engine', N'codex.model.search.adapters.DBSearch')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F0485D1-F0AB-DF57-DCD68A6AE5F2FF33', N'wiki_name', N'A Sweet Wiki')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F050595-E875-9C19-9978C4F271441867', N'wiki_paging_maxrows', N'10')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F052A79-DA80-9757-F8B952EFF0BF467E', N'wiki_paging_bandgap', N'5')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F05890F-C8D4-A7E1-7C60462D3C7AA437', N'wiki_defaultpage_label', N'My Dashboard')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F0622D3-A20F-60CF-5AE67B68F7294189', N'wiki_comments_mandatory', N'1')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'9F0716AB-AF0A-8D94-4AEAA59490D24CB2', N'wiki_outgoing_email', N'myemail@email.com')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'A2E52F85-EC94-6F0D-63D54DA07F9054E9', N'wiki_defaultrole_id', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'B1D80246-CF1E-5C1B-91310C4FA0F78984', N'wiki_metadata', N'codex wiki')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'B1DD1CDD-CF1E-5C1B-9106B89C23AB9410', N'wiki_metadata_keywords', N'codex coldbox transfer wiki')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'C3E7EC67-6ACE-4BFE-95062D1035F66BEA', N'comments_moderation_notify', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'C5BFE426-F38C-8745-2CA44F6B29D5A19B', N'wiki_registration', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'CBE76066-6635-4FD3-805CE2A3933FEDC5', N'comments_moderation', N'true')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'E487E2CE-8BE0-482C-A71249423D4FC757', N'wiki_gravatar_rating', N'pg')
GO

INSERT INTO [dbo].[wiki_options] ([option_id], [option_name], [option_value])
VALUES 
  (N'F1783B24-1C0E-4214-8616907628A8D9D2', N'comments_moderation_whitelist', N'true')
GO

--
-- Data for table dbo.wiki_page  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'06AF3D6A-0AB3-43E6-EF2D1118F58A1562', N'Special:Feeds', N'06AF3D1C-0B00-EAA3-09A138DFA27F7E28', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'58F2F999-FC99-125A-DB21FCD7085C44A1', N'Help:Contents', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'59014C5F-C1C6-7E91-A38446214A380C7D', N'Help:Wiki_Markup', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'59104F5A-9555-E540-6BCAA65D9AE6F448', N'Help:List_Markup', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'A8736248-DCE2-A123-A6DA083754C59203', N'Help:Cheatsheet', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'A895949D-B7C5-34B5-0E32B0CE52BC3FA0', N'Help:Messagebox_Markup', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'B5C4FA1D-CF1E-5C1B-950B4A04E276B736', N'Help:Codex_Wiki_Plugins', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'C90869A2-090D-50DA-0800C94BB5DB7026', N'Help:Feed_Markup', N'58F2F981-F62A-3124-E886BBF8CE6C5295', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'E12403BB-F4C1-5F8A-1B20DB3894BAF144', N'Dashboard', N'F1C0292E-CB06-FD09-41D904E8550FE734', NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO [dbo].[wiki_page] ([page_id], [page_name], [FKnamespace_id], [page_title], [page_password], [page_description], [page_keywords], [page_allowcomments])
VALUES 
  (N'E5CC1A90-D36E-9214-33EB0021D817DE59', N'Special:Categories', N'06AF3D1C-0B00-EAA3-09A138DFA27F7E28', NULL, NULL, NULL, NULL, 1)
GO

--
-- Data for table dbo.wiki_pagecontent  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'06AF3D9F-F000-34AC-65CBF528D2F4F658', N'06AF3D6A-0AB3-43E6-EF2D1118F58A1562', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== Codex RSS Feed Directory ==
<feed url="/feed/directory/list.cfm" />', NULL, 1, '20080211 15:09:50', 1, 0)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'5906B62D-FBD0-6F75-B6B7BF36DCD904C5', N'59014C5F-C1C6-7E91-A38446214A380C7D', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'==Wiki markup==

The ''''''wiki markup'''''' is the syntax system you can use to format a Wikipedia page; please see [[Help:Editing]] for details on it, and [[Help:Wikitext examples]] for a longer list of the possibilities of Wikitext.

===Links and URLs===
{| border="1" cellpadding="2" cellspacing="0"
|- valign="top"
! What it looks like
! What you type
|- id="emph" valign="top"
|
London has [[public transport]].

* A link to another Wiki article.
* Internally, the first letter of the target page is automatically capitalized and spaces are represented as underscores (typing an underscore in the link has the same effect as typing a space, but is not recommended).
* Thus the link above is to the [[URL]] en.wikipedia.org/wiki/Public_transport, which is the Wikipedia article with the name "Public transport". See also [[Wikipedia:Canonicalization]].
|
<pre><nowiki>
London has [[public transport]].
</nowiki></pre>
|- valign="top"
|
San Francisco also has [[public transport|
public transportation]].

* Same target, different name.
* The target ("piped") text must be placed ''''''first'''''', then the text that will be displayed second.
|
<pre><nowiki>
San Francisco also has
[[public transport| public transportation]].
</nowiki></pre>
|- valign="top"
|
San Francisco also has
[[public transport]]ation.

Examples include [[bus]]es, [[taxicab]]s,
and [[streetcar]]s.

* Endings are blended into the link.
* Preferred style is to use this instead of a piped link, if possible.
* Blending can be suppressed by using <nowiki><nowiki></nowiki></nowiki> tags, which may be desirable in some instances.  Example: a [[micro]]<nowiki>second</nowiki>.
|
<pre><nowiki>
San Francisco also has
[[public transport]]ation.

Examples include [[bus]]es,
 [[taxicab]]s, and [[streetcar]]s.

a [[micro]]<nowiki>second</nowiki>
</nowiki></pre>
|- valign="top"
|
See the [[Wikipedia:Manual of Style]].

* A link to another [[Help:namespace|namespace]].
|
<pre><nowiki>
See the 
[[Wikipedia:Manual of Style]].
</nowiki></pre>

|- id="link-to-section" valign="top"
|
[[Wikipedia:Manual of Style#Italics]] is a link to a section within another page.

[[#Links and URLs]] is a link to another section on the current page.

[[Wikipedia:Manual of Style#Italics|Italics]] is a piped link to a section within another page.

* The part after the number sign (#) must match a section heading on the page. Matches must be exact in terms of spelling, case, and punctuation.  Links to non-existent sections are not broken; they are treated as links to the top of the page.
* Include "| link title" to create a stylish (piped) link title.

|
<pre><nowiki>
[[Wikipedia:Manual of Style#Italics]] 
is a link to a section within another page.

[[#Links and URLs]] is a link
to another section on the 
current page.

[[Wikipedia:Manual of Style#Italics|Italics]] 
is a piped link to a section within 
another page.</nowiki></pre>
|- valign="top"
|
Automatically hide stuff in parentheses:
[[kingdom (biology)|kingdom]].

Automatically hide namespace:
[[Wikipedia:Village Pump|Village Pump]]. 

Or both:
[[Wikipedia:Manual of Style (headings)|Manual of Style]]

But not:
[[Wikipedia:Manual of Style#Links|]]
* The server fills in the part after the pipe character (|) when you save the page. The next time you open the edit box you will see the expanded piped link. When [[Wikipedia:Show preview|preview]]ing your edits, you will not see the expanded form until you press ''''''Save'''''' and ''''''Edit'''''' again. The same applies to links to sections within the same page ([[#link-to-section|see previous entry]]).
* See [[Wikipedia:Pipe trick]] for details.

|
<pre><nowiki>
Automatically hide stuff
in parentheses:
[[kingdom (biology)|]].

Automatically hide namespace: 
[[Wikipedia:Village Pump|]].

Or both:
[[Wikipedia:
Manual of Style (headings)|]]

But not:
[[Wikipedia:
Manual of Style#Links|]]
</nowiki></pre>


|- valign="top"
|
<!-- A village pump proposal was made so that users would be allowed to create the article shown here. Pages here would be articles requested for a long time. If you find someone has created the article, please look in requested articles and put one in its place -->
[[National sarcasm society]] is a page
that does not exist yet.

* You can create it by clicking on the link.
* To create a new page: 
*# Create a link to it on some other (related) page.
*# Save that page.
*# Click on the link you just made. The new page will open for editing.
* For more information, see [[Wikipedia:How to start a page|How to start a page]] and check out Wikipedia''s [[Wikipedia:Naming conventions|naming conventions]].
* Please do not create a new article without linking to it from at least one other article.
|
<pre><nowiki>
[[National sarcasm society]]
is a page 
that does not exist yet.
</nowiki></pre>
|- valign="top"
|

[[Wikipedia:How to edit a page]] is a link to this page.

* [[Help:Self link|Self link]]s appear as bold text when the article is viewed.
* Do not use this technique to make the article name bold in the first paragraph; see the [[Wikipedia:Manual of Style#Article titles|Manual of Style]].
|
<pre><nowiki>
[[Wikipedia:How to edit a page]]
is a link to this page.
</nowiki></pre>
|- valign="top"
|
The character ''''''tilde'''''' (~) is used when adding a comment to a Talk page. 
You should sign your comment by appending four tildes (<nowiki>~~~~</nowiki>)
to the comment so as to add your user name plus date/time:
: [[User:Patricia|Patricia Zhang]] 13:40, Jan 14, 2007 (UTC)
Adding three tildes (<nowiki>~~~</nowiki>) will add just your user name:
: [[User:Patricia|Patricia Zhang]]
and adding five tildes (<nowiki>~~~~~</nowiki>) gives the date/time alone:
: 13:40, Jan 14, 2007 (UTC)

* The first two both provide a link to your [[Wikipedia:user page|user page]].
|
<pre><nowiki>
The character ''''''tilde'''''' (~) is used 
when adding a comment to a Talk page. 
You should sign your comment by 
appending four tildes (~~~~)
to the comment so as to add your 
user name plus date/time:
: ~~~~
Adding three tildes (~~~) will add 
just your user name:
: ~~~
and adding five tildes (~~~~~) gives 
the date/time alone:
: ~~~~~
</nowiki></pre>
|- valign="top"
|
* [[Wikipedia:Redirect|Redirect]] one article title to another by placing a directive like the one shown to the right on the ''''first'''' line of the article (such as at a page titled "[[USA]]").
* It is possible to redirect to a section. For example, a redirect to [[United States#History|United States History]] will redirect to the [[United States]] page, to the History section if it exists.
|
<pre><nowiki>
#REDIRECT [[United States]]

#REDIRECT [[United States#History|United 
States History]] will redirect to the 
[[United States]] page, to the History 
section if it exists 
</nowiki></pre>
|- valign="top"
|

* Link to a page on the same subject in another language by placing a link of the form: <nowiki>[[language code:Title]]</nowiki> in the wiki text of the article.
For example in the article on [[Plankton]], which is available on a lot of other wikis, the interlanguage links would look like so:
:<tt><nowiki>[[de:Plankton]] [[es:Plancton]] [[ru:????????]] [[simple:Plankton]]</nowiki></tt>
* While it does not matter where you put these links while editing, it is recommended that these links be placed at the very end of the edit box. 
* These will not be visible in the main text of the article on which they are placed but appear as links in the extreme left margin column of Wikipedia page as part of a separate box under the ''toolbox'' titled ''in other languages''. You can check out the links to the corresponding page in wikipedias of other languages for this Wikipedia MOS help page itself.
* Please see [[Wikipedia:Interlanguage links]] and the [[Wikipedia:Complete list of language wikis available|list of languages and codes]].
|
<pre><nowiki>
</nowiki></pre>
|- valign="top"
|
''''''What links here'''''' and ''''''Related changes''''''
pages can be linked as:
[[Special:Whatlinkshere/Wikipedia:How to edit a page]]
and
[[Special:Recentchangeslinked/Wikipedia:How to edit a page]]

|
<pre><nowiki>
''''''What links here'''''' and
''''''Related changes''''''
pages can be linked as:
[[Special:Whatlinkshere/
Wikipedia:How to edit a page]]
and
[[Special:Recentchangeslinked/
Wikipedia:How to edit a page]]
</nowiki></pre>
|- valign="top"
|
A user''s ''''''Contributions'''''' page can be linked as:
[[Special:Contributions/UserName]]
or
[[Special:Contributions/192.0.2.0]]
|
<pre><nowiki>
A user''s ''''''Contributions'''''' page
can be linked as:
[[Special:Contributions/UserName]]
or
[[Special:Contributions/192.0.2.0]]
</nowiki></pre>
|- valign="top"
|
* To put an article in a [[Wikipedia:Category]], place a link like the one to the right anywhere in the article. As with interlanguage links, it does not matter where you put these links while editing as they will always show up in the same place when you save the page, but placement at the end of the edit box is recommended.
|
<pre><nowiki>
[[Category:Character sets]]
</nowiki></pre>
|- valign="top"
|
* To ''''link'''' to a [[Wikipedia:Category]] page without putting the article into the category, use an initial colon (:) in the link.
|
<pre><nowiki>
[[:Category:Character sets]]
</nowiki></pre>
|- id="link-external" valign="top"
|
Three ways to link to external (non-wiki) sources:
# Bare URL: http://www.wikipedia.com/ (bad style)
# Unnamed link: [http://www.wikipedia.com/] (only used within article body for footnotes)
# Named link: [http://www.wikipedia.com Wikipedia]

:See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts.

* Square brackets indicate an external link. Note the use of a ''''space'''' (not a pipe) to separate the URL from the link text in the "named" version.
* In the [[URL]], all symbols must be among:<br/>''''''A-Z a-z 0-9 . _  / ~ % - + & # ? ! = ( ) @''''''
* If a URL contains a character not in this list, it should be encoded by using a percent sign (%) followed by the [[hexadecimal|hex]] code of the character, which can be found in the table of [[ASCII#ASCII printable characters|ASCII printable characters]]. For example, the caret character (^) would be encoded in a URL as ''''''%5E''''''.
* If the "named" version contains a closing square bracket "]", then you must use the [[HTML]] special character syntax, i.e. '''''']'''''' otherwise the [[MediaWiki]] software will prematurely interpret this as the end of the external link.
* There is a class that can be used to remove the arrow image from the external link. It is used in [[Template:Ref]] to stop the URL from expanding during printing. It should ''''''never'''''' be used in the main body of an article. However, there is an exception: wikilinks in Image markup. An example of the markup is as follows:
** Markup: <nowiki><span
class="plainlinksneverexpand">
[http://www.sysinternals.com/
ntw2k/freeware/winobj.shtml WinObj]</span></nowiki>
** Display: <span class="plainlinksneverexpand"> [http://www.sysinternals.com/ntw2k/freeware/winobj.shtml WinObj]</span>
* See [[Wikipedia:External links]] for style issues.
|
<pre><nowiki>
Three ways to link to
external (non-wiki) sources:
# Bare URL:
http://en.wikipedia.org/
(bad style)
# Unnamed link:
[http://en.wikipedia.org/]
(only used within article
body for footnotes)
# Named link:
[http://en.wikipedia.org Wikipedia]
</nowiki></pre>
|- valign="top"
|
Linking to other wikis:
# [[Interwiki]] link: [[Wiktionary:Hello]]
# Interwiki link without prefix: [[Wiktionary:Hello|Hello]]
# Named interwiki link: [[Wiktionary:Hello|Wiktionary definition of ''Hello'']]

* All of these forms lead to the URL http://en.wiktionary.org/wiki/Hello
* Note that interwiki links use the ''''internal'''' link style.
* See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts; if the site you want to link to is not on the list, use an external link ([[#link-external|see above]]).
* See also [[Wikipedia:Wikimedia sister projects]].

Linking to another language''s wiktionary:
# [[Wiktionary:fr:bonjour]]
# [[Wiktionary:fr:bonjour|bonjour]]
# [[Wiktionary:fr:bonjour|fr:bonjour]]

* All of these forms lead to the URL http://fr.wiktionary.org/wiki/bonjour
|
<pre><nowiki>
Linking to other wikis:
# [[Interwiki]] link:
[[Wiktionary:Hello]]
# Interwiki link without prefix:
[[Wiktionary:Hello|]]
# Named interwiki link:
[[Wiktionary:Hello|
Wiktionary definition 
of ''Hello'']]

Linking to another
language''s wiktionary:
# [[Wiktionary:fr:bonjour]]
# [[Wiktionary:fr:bonjour|bonjour]]
# [[Wiktionary:fr:bonjour|]]
</nowiki></pre>
|- valign="top"
|
ISBN 012345678X

ISBN 0-12-345678-X

* Link to books using their [[Wikipedia:ISBN|ISBN]]. This is preferred to linking to a specific online bookstore, because it gives the reader a choice of vendors. However, if one bookstore or online service provides additional free information, such as table of contents or excerpts from the text, then a link to that source will aid the user and is recommended.
* ISBN links do not need any extra markup, provided you use one of the indicated formats.
|
<pre><nowiki>
ISBN 012345678X

ISBN 0-12-345678-X
</nowiki></pre>
|- valign="top"
|
Text mentioning RFC 4321 anywhere

* Link to [[Internet Engineering Task Force]] [[Request for Comments|RFC]]s.
|
<pre><nowiki>
Text mentioning RFC 4321 
anywhere
</nowiki></pre>

|- valign=top
|
Date formats:
# [[July 20]], [[1969]]
# [[20 July]] [[1969]]
# [[1969]]-[[07-20]]
# [[1969-07-20]]

* Link dates in one of the above formats, so that everyone can set their own display order. If [[Special:Userlogin|logged in]], you can use [[Special:Preferences]] to change your own date display setting.
* All of the above dates will appear as "[[20 July|20 July]] [[1969|1969]]" if you set your date display preference to "15 January 2001", but as "[[20 July|July 20]], [[1969|1969]]" if you set it to "January 15, 2001", or as "[[1969|1969]]-[[July 20|07-20]]" if you set it to "2001-01-15".
|
<pre><nowiki>
Date formats:
# [[July 20]], [[1969]]
# [[20 July]] [[1969]]
# [[1969]]-[[07-20]]
# [[1969-07-20]]

</nowiki></pre>
|- valign="top"
|
Special [[WP:AO|as-of]] links like [[As of 2006|this year]]
needing future maintenance
|
<pre><nowiki>
Special [[WP:AO|as-of]] links 
like [[As of 2006|this year]]
needing future maintenance
</nowiki></pre>
|- valign="top"
|
[[media:Classical guitar scale.ogg|Sound]]

*To include links to non image uploads such as sounds, use a "media" link. For images, [[#Images|see next section]].

Some uploaded sounds are listed at [[Wikipedia:Sound]].
|
<pre><nowiki>
[[media:Classical guitar scale.ogg|Sound]]
</nowiki></pre>

|- valign="top"
|
Link directly to ''''''edit'''''' for an existing page, or apply other link attributes. 
* use <nowiki>{{fullurl:}}</nowiki>  
* or use [[template:edit|<nowiki>{{template:edit}}</nowiki>]] which conceals the edit label for page printing 
|
<pre><nowiki>{{fullurl:page name|action=edit}}</nowiki></pre>
|}

===Images===
Only images that have been uploaded to Wikipedia can be used. To upload images, use the [[Special:Upload|upload page]]. You can find the uploaded image on the [[Special:Imagelist|image list]].

{| border="1" cellpadding="2" cellspacing="0"
|-
! What it looks like
! What you type
|- valign="top"
|A picture: 
[[Image:wiki.png]]
|<pre>A picture: 
<nowiki>[[Image:wiki.png]]</nowiki></pre>

|- valign="top"
|With alternative text:
[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]
|<pre>With alternative text:
<nowiki>[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]</nowiki></pre>
* Alternative text, used when the image is unavailable or when the image is loaded in a text-only browser, or when spoken aloud, is ''''''strongly'''''' encouraged. See [[Wikipedia:Alternate text for images|Alternate text for images]] for help on choosing it.

|- valign="top"
|Floating to the right side of the page using the ''''frame'''' attribute and a caption:
[[Image:wiki.png|frame|Wikipedia Encyclopedia]]<br clear=all>
|<pre>Floating to the right side of the page 
using the ''''frame'''' attribute and a caption:
<nowiki>[[Image:wiki.png|frame|Wikipedia Encyclopedia]]</nowiki></pre>
* The frame tag automatically floats the image right.
* The caption is also used as alternate text.

|- valign="top"
|Floating to the right side of the page using the ''''thumb'''' attribute and a caption:
[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]<br clear=all>
|<pre>Floating to the right side of the page 
using the ''''thumb'''' attribute and a caption:
<nowiki>[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]</nowiki></pre>
* The thumb tag automatically floats the image right.
* The caption is also used as alternate text.
* An enlarge icon is placed in the lower right corner.

|- valign="top"
|Floating to the right side of the page ''''without'''' a caption:
[[Image:wiki.png|right|Wikipedia Encyclopedia]]
|<pre>Floating to the right side of the page
''''without'''' a caption:
<nowiki>[[Image:wiki.png|right|Wikipedia Encyclopedia]]</nowiki></pre>
* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.

|- valign="top"
|A picture resized to 30 pixels...
[[Image:wiki.png|30 px]]
|<pre>A picture resized to 30 pixels...
<nowiki>[[Image:wiki.png|30 px]]</nowiki></pre>
* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.

|- valign="top"
|Linking directly to the description page of an image:
[[:Image:wiki.png]]
|<pre>Linking directly to the description page
of an image:
<nowiki>[[:Image:wiki.png]]</nowiki></pre>
* Clicking on an image displayed on a page
(such as any of the ones above)
also leads to the description page

|- valign="top"
|Linking directly to an image without displaying it:
[[:Image:wiki.png|Image of the jigsaw globe logo]]
|<pre>Linking directly to an image
without displaying it:
<nowiki>[[:media:wiki.png|Image of the jigsaw globe logo]]</nowiki></pre>
* To include links to images shown as links instead of drawn on the page, use a "media" link.

|- valign="top" 
|Using the [[div tag]] to separate images from text (note that this may allow images to cover text):
|<pre><nowiki>Example:
<div style="display:inline;
width:220px; float:right;">
Place images here </div></nowiki></pre>

|- valign="top" 
|Using wiki markup to make a table in which to place a vertical column of images (this helps edit links match headers, especially in Firefox browsers): 
|<pre><nowiki>Example: {| align=right
|-
| 
Place images here
|}
</nowiki></pre>

|}

See the Wikipedia''s [[Wikipedia:Image use policy|image use policy]] as a guideline used on Wikipedia.

For further help on images, including some more versatile abilities, see the topic on [[Wikipedia:Extended image syntax|Extended image syntax]].

===Headings===

For a top-level heading, put it on a separate line surrounded by ''==''. For example:

   ==Introduction==

Subheadings use ''==='', ''===='', and so on.

===Character formatting===
{| border="1" cellpadding="2" cellspacing="0"
|- valign="top"
! What it looks like
! What you type
|- id="emph" valign="top"
|
''''Italicized text''''<br />''''''Bold text''''''<br />''''''''''Italicized & Bold text''''''''''
|
<pre><nowiki>
''''Italicized text''''
''''''Bold text''''''
''''''''''Italicized & Bold text''''''''''
</nowiki></pre>
|- valign="top"
|
A typewriter font for <tt>monospace text</tt>
or for computer code: <code>int main()</code>

* For semantic reasons, using <code><code></code> where applicable is preferable to using <code><tt></code>.
|
<pre><nowiki>
A typewriter font for <tt>monospace text</tt>
or for computer code: <code>int main()</code>
</nowiki></pre>
|- valign=top
|
Create codeblocks<code><pre>
#include <iostream.h>
int main ()
{
cout << "Hello World!";
return 0;
}
</pre></code> that are printed as entered
|
<pre>Use <code><pre> Block of Code </pre></code> 
around the block of code.

* The <pre> tags within the code block 
will create formatting issues. To solve, 
display the tags literally with 
<pre>  and  </pre></pre>
|- valign="top"
|
You can use <small>small text</small> for captions.
|
<pre><nowiki>
You can use <small>small text</small> for captions.
</nowiki></pre>
|- valign="top"
|
Better stay away from <big>big text</big>, unless
<small> it''s <big>within</big> small</small> text. 
|
<pre><nowiki>
Better stay away from <big>big text</big>, unless
<small> it''s <big>within</big> small</small> text.
</nowiki></pre>
|- valign="top"
|
You can <s>strike out deleted material</s>
and <u>underline new material</u>.

You can also mark <del>deleted material</del> and
<ins>inserted material</ins> using logical markup.
For backwards compatibility better combine this
potentially ignored new <del>logical</del> with 
the old <s><del>physical</del></s> markup.

* When editing regular Wikipedia articles, just make your changes and do not mark them up in any special way.
* When editing your own previous remarks in talk pages, it is sometimes appropriate to mark up deleted or inserted material.
|
<pre><nowiki>
You can <s>strike out deleted material</s>
and <u>underline new material</u>.

You can also mark <del>deleted material</del> and
<ins>inserted material</ins> using logical markup.
For backwards compatibility better combine this
potentially ignored new <del>logical</del> with
the old <s><del>physical</del></s> markup.
</nowiki></pre>
|- valign="top"
|
''''''Suppressing interpretation of markup:''''''
<br/>
<nowiki>Link ? (''''to'''') the [[Wikipedia FAQ]]</nowiki>
* Used to show literal data that would otherwise have special meaning.
* Escape all wiki markup, including that which looks like HTML tags.
* Does not escape HTML character references.
* To escape HTML character references such as <tt>?</tt> use <tt>&rarr;</tt>
|
<br/>
<pre><nowiki>
<nowiki>Link ? (''''to'''') 
the [[Wikipedia FAQ]]</nowiki>
</nowiki></pre>
|- valign="top"
|
''''''Commenting page source:''''''
<br/>
''''not shown when viewing page''''
* Used to leave comments in a page for future editors.
* Note that most comments should go on the appropriate [[Wikipedia:Talk page|Talk page]].
|
<br/>
<pre><nowiki>
<!-- comment here -->
</nowiki></pre>
|- valign="top"
|
''''''<span id="diacritics">Diacritical marks:</span>''''''
<br/>
À Á Â Ã Ä Å <br/>
Æ Ç È É Ê Ë <br/>
Ì Í
Î Ï Ñ Ò <br/>
Ó Ô Õ
Ö Ø Ù <br/>
Ú Û Ü ß
à á <br/>
â ã ä å æ
ç <br/>
è é ê ë ì í<br/>
î ï ñ ò ó ô <br/>
œ õ
ö ø ù ú <br/>
û ü ÿ

* See [[meta:Help:Special characters|special characters]].
|
<br/>
<pre><nowiki>
À Á Â Ã Ä Å 
Æ Ç È É Ê Ë 
Ì Í Î Ï Ñ Ò 
Ó Ô Õ Ö Ø Ù 
Ú Û Ü ß à á 
â ã ä å æ ç 
è é ê ë ì í
î ï ñ ò ó ô 
œ õ ö ø ù ú 
û ü ÿ
</nowiki></pre>
|- valign="top"
|
''''''Punctuation:''''''
<br/>
¿ ¡ § ¶<br/>
† ‡ • – —<br/>
‹ › « »<br/>
‘ ’ “ ”
|
<br/>
<pre><nowiki>
¿ ¡ § ¶
† ‡ • – —
‹ › « »
‘ ’ “ ”
</nowiki></pre>
|- valign="top"
|
''''''Commercial symbols:''''''
<br/>
™ © ® ¢ € ¥<br/>
£ ¤
|
<br/>
<pre><nowiki>
™ © ® ¢ € ¥ 
£ ¤
</nowiki></pre>
|- valign="top"
|
''''''Subscripts:''''''
<br/>
x<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or
<br/>
x? x? x? x? x?
<br/>
x? x? x? x? x?

''''''Superscripts:''''''
<br/>
x<sup>1</sup> x² x³ or
<br/>
x? x¹ x² x³ x?
<br/>
x? x? x? x? x?

*The latter methods of sub/superscripting cannot be used in the most general context, as they rely on Unicode support which may not be present on all users'' machines. For the 1-2-3 superscripts, it is nevertheless preferred when possible (as with units of measurement) because most browsers have an easier time formatting lines with it.

?<sub>0</sub> =
8.85 × 10<sup>?12</sup>
C² / J m.

1 [[hectare]] = [[1 E4 m²]]
|
<br/>
<pre><nowiki>
x<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or
<br/>
x? x? x? x? x?
<br/>
x? x? x? x? x?
</nowiki></pre>

<pre><nowiki>
x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> or
<br/>
x? x¹ x² x³ x?
<br/>
x? x? x? x? x?

?<sub>0</sub> =
8.85 × 10<sup>?12</sup>
C² / J m.

1 [[hectare]] = [[1 E4 m²]]
</nowiki></pre>
|- valign="top"
|
''''''Greek characters:''''''
<br/>
? ? ? ? ? ? <br/>
? ? ? ? ? ? ? <br/>
? ? ? ? ? ?<br/>
? ? ? ? ? ?<br/>
? ? ? ? ? ? <br/>
? ? ? ?
|
<br/>
<pre><nowiki>
? ? ? ? ? ? 
? ? ? ? ? ? ? 
? ? ? ? ? ?
? ? ? ? ? ?
? ? ? ? ? ? 
? ? ? ?
</nowiki></pre>
|- valign="top"
|
''''''Mathematical characters:''''''
<br/>
? ? ? ? ? ± ?<br/>
? ? ? ? ? ?<br/>
× · ÷ ? ? ?<br/>
? ‰ ° ? ? ø<br/>
? ? ? ? ? ? ? ?<br/>
¬ ? ? ? ? <br/>
? ? ? ? ?<br/>
? ? ? ? ?<br/>
* See also [[Wikipedia:WikiProject Mathematics|WikiProject Mathematics]] and [[TeX]].
|
<br/>
<pre><nowiki>
? ? ? ? ? ± ?
? ? ? ? ? ?
× · ÷ ? ? ?
? ‰ ° ? ? ø
? ? ? ? ? ? ? ?
¬ ? ? ? ? 
? ? ? ? ?
? ? ? ? ?
</nowiki></pre>
|- valign="top"
|
<math>,! sin x + ln y</math><br>
sin''''x'''' + ln''''y''''
<!-- no space between roman "sin" and italic "x" -->

<math>mathbf{x} = 0</math><br>
''''''x'''''' = 0

Ordinary text should use [[#emph|wiki markup for emphasis]], and should not use <code><i></code> or <code><b></code>.  However, mathematical formulae often use italics, and sometimes use bold, for reasons unrelated to emphasis.  Complex formulae should use [[Help:Formula|<code><math></code> markup]], and simple formulae may use <code><math></code>; or <code><i></code> and <code><b></code>; or <code><nowiki>''''</nowiki></code> and <code><nowiki>''''''</nowiki></code>.  According to [[Wikipedia:WikiProject Mathematics#Italicization and bolding|WikiProject Mathematics]], wiki markup is preferred over HTML markup like <code><i></code> and <code><b></code>.
|
<pre><nowiki>
<math>,! sin x + ln y</math>
sin''''x'''' + ln''''y''''

<math>mathbf{x} = 0</math>
''''''x'''''' = 0
</nowiki></pre>
|- valign="top"
|
''''''Spacing in simple math formulae:''''''
<br/>
Obviously, ''''x''''² ? 0 is true when ''''x'''' is a real number.
*To space things out without allowing line breaks to interrupt the formula, use non-breaking spaces: <tt> </tt>.
|
<br/>
<pre><nowiki>
Obviously, ''''x''''² ? 0 is true 
when ''''x'''' is a real number.
</nowiki></pre>
|- valign="top"
|
''''''Complicated formulae:''''''
<br/>
: <math>sum_{n=0}^infty frac{x^n}{n!}</math>
* See [[Help:Formula]] for how to use <tt><math></tt>.
* A formula displayed on a line by itself should probably be indented by using the colon (:) character.
|
<br/>
<pre><nowiki>
: <math>sum_{n=0}^infty frac{x^n}{n!}</math>
</nowiki></pre>
|}
''''(see also: [[Chess symbols in Unicode]])''''

===No or limited formatting—showing exactly what is being typed===

A few different kinds of formatting will tell the Wiki to display things as you typed them—what you see, is what you get!

{| border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|''''''<nowiki> tag:''''''<br/>
<nowiki>
The nowiki tag ignores [[Wiki]] ''''markup''''.
It reformats text by removing newlines    and multiple spaces.
It still interprets special characters: ?
</nowiki>
|<pre><nowiki>
<nowiki>
The nowiki tag ignores [[Wiki]] ''''markup''''.
It reformats text by removing newlines 
and multiple spaces.
It still interprets special
characters: ?
</nowiki>
</nowiki></pre>
|-
|''''''<pre> tag:''''''</br>
<pre>
The pre tag ignores [[Wiki]] ''''markup''''.
It also doesn''t     reformat text.
It still interprets special characters: ?
</pre>
|<pre><pre><nowiki>
The pre tag ignores [[Wiki]] ''''markup''''.
It also doesn''t     reformat text.
It still interprets special characters:
 ?
</nowiki></pre></pre>
|-
|''''''Leading space:''''''<br/>
Leading spaces are another way 
to preserve formatting. ''''However, it will make the whole page fail to render properly in some browsers, such as IE7, thus making the page unreadable.''''


 Putting a space at the beginning of each line
 stops the text   from being reformatted. 
 It still interprets [[Wiki]] ''''markup'''' and
 special characters: ?
|<pre><nowiki>
Leading spaces are another way 
to preserve formatting.
 Putting a space at the beginning of each line
 stops the text   from being reformatted. 
 It still interprets [[Wiki]] ''''markup'''' and
 special characters: ?
</nowiki></pre>
|}

===Invisible text (comments)===
{{main|Wikipedia:Manual of Style#Invisible comments}}
It''s uncommon, but on occasion acceptable, to add a hidden comment within the text of an article.  <!-- This is an example of text that won''t normally be visible except in "edit" mode. --> The format is this:
 <nowiki><!-- This is an example of text that won''t normally be visible except in "edit" mode. --></nowiki>

=== Table of contents===
<!-- ==== Placement of the Table of Contents (TOC) ==== -->
At the current status of the wiki markup language, having at least four headers on a page triggers the table of contents (TOC) to appear in front of the first header (or after introductory sections).  Putting <nowiki>__TOC__</nowiki> anywhere forces the TOC to appear at that point (instead of just before the first header).  Putting <nowiki>__NOTOC__</nowiki> anywhere forces the TOC to disappear.  See also [[Wikipedia:Section#Compact_TOC|compact TOC]] for alphabet and year headings.
<!--
THE TEXT BELOW IS COMMENTED OUT SINCE THE DESCRIBED TECHNIQUE 
DOESN''T WORK AFTER UPGRADING TO MEDIAWIKI 1.5

====Keeping headings out of the Table of Contents====
If you want some subheadings to not appear in the Table of Contents, then make the following replacements.

Replace  <nowiki> == Header 2 == with <h2> Header 2 </h2> </nowiki>

Replace  <nowiki> === Header 3 === with <h3> Header 3 </h3> </nowiki>

And so forth.

For example, notice that the following header has the same font as the other subheaders to this "Tables" section, but the following header does not appear in the Table of Contents for this page.

<h4> This header has the h4 font, but is NOT in the Table of Contents (actually, it is)</h4>

This effect is obtained by the following line of code.

<code><nowiki><h4> This header has the h4 font, but is not in the Table of Contents </h4></nowiki></code>

Note that when editing by section, this approach places the text between the tags in the subsequent section, not the previous section. To edit this text, click the edit link next to "Tables", not the one above.
-->

===Tables===
There are two ways to build tables: 
*in special Wiki-markup (see [[Help:Table]])
*with the usual HTML elements: <table>, <tr>, <td> or <th>.

For the latter, and a discussion on when tables are appropriate, see [[Wikipedia:When to use tables]].

===Variables===
''''(See also [[Help:Variable]])''''
{| style="text-align:center"
|-
! Code
! Effect
|-
| <nowiki>{{CURRENTWEEK}}</nowiki> || {{CURRENTWEEK}}
|-
| <nowiki>{{CURRENTDOW}}</nowiki> || {{CURRENTDOW}}
|-
| <nowiki>{{CURRENTMONTH}}</nowiki> || {{CURRENTMONTH}}
|-
| <nowiki>{{CURRENTMONTHNAME}}</nowiki>
| {{CURRENTMONTHNAME}}
|-
| <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>
| {{CURRENTMONTHNAMEGEN}}
|-
| <nowiki>{{CURRENTDAY}}</nowiki> || {{CURRENTDAY}}
|-
| <nowiki>{{CURRENTDAYNAME}}</nowiki> || {{CURRENTDAYNAME}}
|-
| <nowiki>{{CURRENTYEAR}}</nowiki> || {{CURRENTYEAR}}
|-
| <nowiki>{{CURRENTTIME}}</nowiki> || {{CURRENTTIME}}
|-
| <nowiki>{{NUMBEROFARTICLES}}</nowiki>
| {{NUMBEROFARTICLES}}
|-
| <nowiki>{{NUMBEROFUSERS}}</nowiki>
| {{NUMBEROFUSERS}}
|-
| <nowiki>{{PAGENAME}}</nowiki> || {{PAGENAME}}
|-
| <nowiki>{{NAMESPACE}}</nowiki> || {{NAMESPACE}}
|-
| <nowiki>{{REVISIONID}}</nowiki> || {{REVISIONID}}
|-
| <nowiki>{{localurl:pagename}}</nowiki>
| {{localurl:pagename}}
|-
| <nowiki>{{localurl:</nowiki>''''Wikipedia:Sandbox''''<nowiki>|action=edit}}</nowiki>
| {{localurl:Wikipedia:Sandbox|action=edit}}
|-
| <nowiki>{{fullurl:pagename}}</nowiki>
| {{fullurl:pagename}} 
|- 
| <nowiki>{{fullurl:pagename|</nowiki>''''query_string''''<nowiki>}}</nowiki>
| {{fullurl:pagename|query_string}} 
|- 
| <nowiki>{{SERVER}}</nowiki> || {{SERVER}}
|-
| <nowiki>{{ns:1}}</nowiki> || {{ns:1}}
|-
| <nowiki>{{ns:2}}</nowiki> || {{ns:2}}
|-
| <nowiki>{{ns:3}}</nowiki> || {{ns:3}}
|-
| <nowiki>{{ns:4}}</nowiki> || {{ns:4}}
|-
| <nowiki>{{ns:5}}</nowiki> || {{ns:5}}
|-
| <nowiki>{{ns:6}}</nowiki> || {{ns:6}}
|-
| <nowiki>{{ns:7}}</nowiki> || {{ns:7}}
|-
| <nowiki>{{ns:8}}</nowiki> || {{ns:8}}
|-
| <nowiki>{{ns:9}}</nowiki> || {{ns:9}}
|-
| <nowiki>{{ns:10}}</nowiki> || {{ns:10}}
|-
| <nowiki>{{ns:11}}</nowiki> || {{ns:11}}
|-
| <nowiki>{{ns:12}}</nowiki> || {{ns:12}}
|-
| <nowiki>{{ns:13}}</nowiki> || {{ns:13}}
|-
| <nowiki>{{ns:14}}</nowiki> || {{ns:14}}
|-
| <nowiki>{{ns:15}}</nowiki> || {{ns:15}}
|-
| <nowiki>{{SITENAME}}</nowiki> || {{SITENAME}}
|}

''''''NUMBEROFARTICLES'''''' is the number of pages in the main namespace which contain a link and are not a redirect, in other words number of articles, stubs containing a link, and disambiguation pages.

''''''CURRENTMONTHNAMEGEN'''''' is the genitive (possessive) grammatical form of the month name, as used in some languages; ''''''CURRENTMONTHNAME'''''' is the nominative (subject) form, as usually seen in English.

In languages where it makes a difference, you can use constructs like <nowiki>{{grammar:case|word}}</nowiki> to convert a word from the nominative case to some other case.  For example, <nowiki>{{grammar:genitive|{{CURRENTMONTHNAME}}}}</nowiki> means the same as <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>. <!-- Is there a reference for this, other than the source code (for example, phase3/languages/Lnaguage*.php) ? -->


This page is covered by [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]', NULL, 1, '20080227 14:54:14', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'59121859-EB3F-023C-703B2FFFF21FBAE3', N'59104F5A-9555-E540-6BCAA65D9AE6F448', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== List basics ==

CodexWiki offers three types of lists. ''''''Ordered lists'''''', ''''''unordered lists'''''', and ''''''definition lists''''''. In the following sections, ordered lists are used for examples. Unordered lists would give corresponding results.

{|border=1 width="79%"
!wikitext!!rendering
|-
|
 * Lists are easy to do:
 ** start every line
 * with a star
 ** more stars mean
 *** deeper levels
||
* Lists are easy to do:
** start every line
* with a star
** more stars mean 
*** deeper levels
|-
|
 *A newline
 *in a list  
 marks the end of the list.
 Of course
 *you can
 *start again.
|
*A newline
*in a list  
marks the end of the list.
Of course
*you can
*start again.
|-
|
 # Numbered lists are good
 ## very organized
 ## easy to follow
|
# Numbered lists are good
## very organized
## easy to follow
|-
|
 * You can also
 **break lines
 **like this
|
* You can also
**break lines
**like this
|-
|
 ; Definition lists
 ; item : definition
 ; semicolon plus term
 : colon plus definition
|
; Definition lists
; item : definition
; semicolon plus term
: colon plus definition
|-
|
 * Or create mixed lists
 *# and nest them
 *#* like this
 *#*; definitions
 *#*: work:
 *#*; apple
 *#*; banana
 *#*: fruits
|
* Or create mixed lists
*# and nest them
*#* like this
*#*; definitions
*#*: work: 
*#*; apple
*#*; banana
*#*: fruits
|}

== Paragraphs in lists ==

For simplicity, list items in wiki markup cannot be longer than a paragraph. A following blank line will end the list and reset the counter on ordered lists. Separating unordered list items usually has no noticable effects.

Paragraphs can be forced in lists by using HTML tags. Two line break symbols, <code><nowiki><br><br></nowiki></code>, will create the desired effect. So will enclosing all but the first paragraph with <code><nowiki><p>...</p></nowiki></code>

For a list with items of more than one paragraph long, adding a blank line between items may be necessary to avoid confusion.

==Continuing a list item after a sub-item==

In HTML, a list item may contain several sublists, not necessarily adjacent; thus there may be parts of the list item not only before the first sublist, but also between sublists, and after the last one; however, in wiki-syntax, sublists follow the same rules as sections of a page: the only possible part of the list item not in sublists is before the first sublist.

In the case of an unnumbered first-level list in wikitext code this limitation can be overcome by splitting the list into multiple lists; indented text between the partial lists may visually serve as part of a list item after a sublist; however, this may give, depending on CSS, a blank line before and after each list, in which case, for uniformity, every first-level list item could be made a separate list.

Numbered lists illustrate that what should look like one list may, for the software, consist of multiple lists; unnumbered lists give a corresponding result, except that the problem of restarting with 1 is not applicable.

{| style="border:1px;border-spacing:1px;background-color:black;" cellpadding="5"
|- style="background-color:white;"
|
 <nowiki>
<ol>
  <li>list item A1
    <ol>
      <li>list item B1</li>
      <li>list item B2</li>
    </ol>continuing list item A1
  </li>
  <li>list item A2</li>
</ol></nowiki>
| <ol>
  <li>list item A1
    <ol>
      <li>list item B1</li>
      <li>list item B2</li>
    </ol>continuing list item A1
  </li>
  <li>list item A2</li>
</ol>
|- style="background-color:#E0E0E0;font-weight:bold;text-align:center;"
| colspan="2" | vs.
|- style="background-color:white;"
|
 #list item A1
 ##list item B1
 ##list item B2
 #:continuing list item A1
 #list item A2
|
#list item A1
##list item B1
##list item B2
#:continuing list item A1
#list item A2
|}

One level deeper, with a sublist item continuing after a sub-sublist, one gets even more blank lines; however, the continuation of the first-level list is not affected:
<pre>
#list item A1
##list item B1
###list item C1
##:continuing list item B1
##list item B2
#list item A2
</pre>
gives
#list item A1
##list item B1
###list item C1
##:continuing list item B1
##list item B2
#list item A2

See also [[Help:Section#Subdivisions in general|subdivisions]].

== Changing the list type ==

The list type (which type of marker appears before the list item) can be changed in CSS by setting the [http://www.w3.org/TR/REC-CSS2/generate.html#lists list-style-type] property:

{|border=1 width="79%"
!wikitext!!rendering
|-
|
 <nowiki>
<ol style="list-style-type:lower-roman">
  <li>About the author</li>
  <li>Foreword to the first edition</li>
  <li>Foreword to the second edition</li>
</ol></nowiki>
|<ol style="list-style-type:lower-roman">
  <li>About the author</li>
  <li>Foreword to the first edition</li>
  <li>Foreword to the second edition</li>
</ol>
|-
|}

==Extra indentation of lists==
In a numbered list in a large font, some browsers do not show more than two digits, unless extra indentation is applied (if there are multiple columns: for each column). This can be done with CSS:
 ol { margin-left: 2cm}
or alternatively, like below.

{|border=1
!wikitext!!rendering 
! style="width: 40%" | comments
|-
|
 <nowiki>
:#abc
:#def
:#ghi
 </nowiki>
|
:#abc
:#def
:#ghi
| A list of one or more lines starting with a colon creates a [http://www.w3.org/TR/html4/struct/lists.html#edef-DL definition list] without definition terms, and with the items as definition descriptions, hence indented. However, if the colons are in front of the codes "*" or "#" of an unordered or ordered list, the list is treated as one definition description, so the whole list is indented.
|-
|
 <nowiki>
<ul>
  <ol>
    <li>abc</li>
    <li>def</li>
    <li>ghi</li>
  </ol>
</ul>
</nowiki>
|
<ul>
  <ol>
    <li>abc</li>
    <li>def</li>
    <li>ghi</li>
  </ol>
</ul>
| MediaWiki translates an unordered list (ul) without any list items (li) into a div with a <code>style="margin-left: 2em"</code>, causing  indentation of the contents. This is ''''''the most versatile method'''''', as it allows starting with a number other than 1, see below.

|-
|
 <nowiki>
<ul>
#abc
#def
#ghi
</ul>
</nowiki>
|
<ul>
#abc
#def
#ghi
</ul>
|Like above, with the content of the "unordered list without any list items", which itself is an ordered list, expressed with # codes. The HTML produced, and hence the rendering, is the same. This is the ''''''recommended'''''' method when not starting with a number other than 1.

|}

To demonstrate that all three methods show all digits of 3-digit numbers, see [[m:Help:List demo|List demo]].

==Specifying a starting value==
Specifying a starting value is only possible with HTML syntax.
(W3C has deprecated the <code>start</code> and <code>value</code> attributes as used below in HTML 4.01 and XHTML 1.0. But as of 2007, no popular web browsers implement CSS counters, which were to replace these attributes. Wikimedia projects use XHTML Transitional, which contains the deprecated attributes.)

<pre>
<ol start="9">
<li>Amsterdam</li>
<li>Rotterdam</li>
<li>The Hague</li>
</ol>
</pre>
gives
<ol start="9">
<li>Amsterdam</li>
<li>Rotterdam</li>
<li>The Hague</li>
</ol>

Or:
<pre>
<ol>
<li value="9">Amsterdam</li>
<li value="8">Rotterdam</li>
<li value="7">The Hague</li>
</ol>
</pre>
gives
<ol>
<li value="9">Amsterdam</li>
<li value="8">Rotterdam</li>
<li value="7">The Hague</li>
</ol>

==Comparison with a table==
Apart from providing automatic numbering, the numbered list also aligns the contents of the items, comparable with using table syntax:
<pre>
{|
|-
| align=right |  9.||Amsterdam
|-
| align=right | 10.||Rotterdam
|-
| align=right | 11.||The Hague
|}
</pre>
gives
{|
|-
| align=right |  9.||Amsterdam
|-
| align=right | 10.||Rotterdam
|-
| align=right | 11.||The Hague
|}

This non-automatic numbering has the advantage that if a text refers to the numbers, insertion or deletion of an item does not disturb the correspondence.

==Multi-column bulleted list==
<pre>
{| 
| 
*1
*2 
| 
*3
*4
|}
</pre>
gives:
{| 
| 
*1
*2 
| 
*3
*4
|}

==Multi-column numbered list==
Specifying a starting value is useful for a numbered list with multiple columns, to avoid restarting from one in each column. As mentioned above, this is only possible with HTML-syntax (for the first column either wiki-syntax or HTML-syntax can be used).

In combination with the extra indentation explained in the previous section:
<pre>
{| valign="top"
|-
|<ul><ol start="125"><li>a<li>bb<li>ccc</ol></ul>
|<ul><ol start="128"><li>ddd<li>ee<li>f</ol></ul>
|}
</pre>

gives

{| valign="top"
|-
|<ul><ol start="125"><li>a<li>bb<li>ccc</ol></ul>
|<ul><ol start="128"><li>ddd<li>ee<li>f</ol></ul>
|}

Using {{tim|multi-column numbered list}} the computation of the starting values can be automated, and only the first starting value and the number of items in each column except the last has to be specified. Adding an item to, or removing an item from a column requires adjusting only one number, the number of items in that column, instead of changing the starting numbers for all subsequent columns.

<pre>{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}</pre>

gives

{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}

<pre>{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}

<pre>{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}

<pre>{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}

==Streamlined style or horizontal style==
It is also possible to present short lists using very basic formatting, such as:

 <nowiki>''''Title of list:''''</nowiki> example 1, example 2, example 3

''''Title of list:'''' example 1, example 2, example 3

This style requires less space on the page, and is preferred if there are only a few entries in the list, it can be read easily, and a direct edit point is not required. The list items should start with a lowercase letter unless they are proper nouns.

==Tables==
A one-column table is very similar to a list, but it allows sorting. If the wikitext itself is already sorted with the same sortkey, this advantage does not apply.
A multiple-column table allows sorting on any column.

See also [[en:Wikipedia:When to use tables]].

==Changing unordered lists to ordered ones==
With the CSS
 ul { list-style: decimal }
unordered lists are changed to ordered ones. This applies (as far as the CSS selector does not restrict this) to all ul-lists in the HTML source code:
*those produced with *
*those with <nowiki><ul></nowiki> in the wikitext
*those produced by the system

Since each special page, like other pages, has a class based on the pagename, one can separately specify for each type whether the lists should be ordered, see [[Help:User contributions#User styles]] and [[Help:What links here#User styles]].

However, it does not seem possible to make all page history lists ordered (unless one makes ''''all'''' lists ordered), because the class name is based on the page for which the history is viewed. 




This page is covered under [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]', NULL, 1, '20080227 15:06:40', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'A873628C-0187-145E-574309C8195CA646', N'A8736248-DCE2-A123-A6DA083754C59203', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'<div align="center">
<!--COMMENT MARKUP. Displays:Edit mode only.-->
{|align="center" style="width:100%; border:2px #a3b1bf solid; background:#f5faff; text-align:left;"
|colspan="3" align="center" style="background:#cee0f2; text-align:center;" |
<h2 style="margin:.5em; margin-top:.1em; margin-bottom:.1em; border-bottom:0; font-weight:bold;">Wikipedia Cheatsheet</h2>
|-<!--COLUMN HEADINGS-->
| width="25%" style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''Description''''''
| style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''You type'''''' 
| width="25%" style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''You get''''''
|-<!--1ST ROW 1ST COLUMN-->
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Italic text]]
|<!--2ND COLUMN-->
<tt><nowiki>''''italic''''</nowiki></tt>
|<!--3RD COLUMN-->
''''italic''''
|-<!--HORIZONTAL LINE-->
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-<!--2ND ROW 1ST COLUMN-->
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Bold text]]
|
<tt><nowiki>''''''bold''''''</nowiki></tt>
|
''''''bold''''''
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Bold and italic]]
|
<tt><nowiki>''''''''''bold & italic''''''''''</nowiki></tt>
|
''''''''''bold & italic''''''''''
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
||[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Internal link]]<br />
<div style="padding: 0em .5em; font-size:0.9em;">''''(within Wikipedia)''''</div>
|
<tt><nowiki>[[Name of page]]</nowiki></tt><br />
<tt><nowiki>[[Name of page|Text to display]]</nowiki></tt>
|
[[Name of page]]<br />
[[Name of page|Text to display]]
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|External link]]<br />
<div style="padding: 0em .5em; font-size:0.9em;">''''(to other websites)''''</div>
|
<tt><nowiki>[http://www.example.org Text to display]</nowiki></tt><br />
<tt><nowiki>[http://www.example.org]</nowiki></tt><br />
<tt><nowiki>http://www.example.org</nowiki></tt>
|
[http://www.example.org Text to display]<br />
[http://www.example.org]<br />
http://www.example.org
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Redirect to another page]]
|
<tt><nowiki>#REDIRECT [[Target page]]</nowiki></tt>
|
[[Image:Redirect arrow without text.svg|30px]][[Target page]]
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|rowspan="3"|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Footnotes/References]]
<div style="padding: 0em .5em; font-size:0.9em;">''''Numbering is generated automatically.''''</div>
|<div style="margin-left:2em; font-size:0.9em;">''''To create a footnote or reference, use this format:''''</div>
<tt><nowiki>Article text.<ref name="test">[http://www.example.org Link text], additional text.</ref></nowiki></tt>
|rowspan="2"|Article text.<ref name="test">[http://www.example.org Link text], additional text.</ref>
|-
|<div style="margin-left:2em; font-size:0.9em;">''''To reuse the same note, reuse the name with a trailing slash:''''</div>
<tt><nowiki>Article text.<ref name="test" /></nowiki></tt>
|-
|<div style="margin-left:2em; font-size:0.9em;">''''To display notes, add ''''''either'''''' of these lines to the References section''''</div>
<tt><nowiki><references/></nowiki></tt><br/>
<tt>{{tl|Reflist}}</tt>
|<br/><references /><br/>
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Headings|Section headings]]<ref name="firstline">''''Applies only at the very beginning of lines.''''</ref><br />
<div style="padding: 0em .5em; font-size:0.9em;">''''A Table of Contents will automatically be generated when four headings are added to an article.''''</div>
|
<tt><nowiki>== Level 1 ==</nowiki></tt><br />
<tt><nowiki>=== Level 2 ===</nowiki></tt><br />
<tt><nowiki>==== Level 3 ====</nowiki></tt><br />
<tt><nowiki>===== Level 4 =====</nowiki></tt><br />
<tt><nowiki>====== Level 5 ======</nowiki></tt>
|
== Level 1 ==
=== Level 2 ===
==== Level 3 ====
===== Level 4 =====
====== Level 5 ======
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Help:List|Bulleted list]]<ref name="firstline" />
<div style="padding: 0em .5em; font-size:0.9em;">''''Empty lines between list items discouraged, (see numbered lists).''''</div>
|
<tt>* One</tt><br />
<tt>* Two</tt><br />
<tt>** Two point one</tt><br />
<tt>* Three</tt>
|
* One
* Two
** Two point one
* Three
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Help:List|Numbered list]]<ref name="firstline" />
<div style="padding: 0em .5em; font-size:0.9em;">''''Empty lines between list items restarts numbering at 1.''''</div>
|
<tt># One</tt><br />
<tt># Two</tt><br />
<tt>## Two point one</tt><br />
<tt># Three</tt><br />
|
# One
# Two
## Two point one
# Three
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:Extended_image_syntax|Thumbnail image]]
|
<tt><nowiki>[[Image:Wiki.png|thumb|Caption text]]</nowiki></tt>
|
[[Image:Wiki.png|thumb|Caption text]]
|-

|-<!--TALKPAGES-->
| colspan="3" style="background:#E6F2FF; padding: 0.2em; font-family: sans-serif; font-size: 0.9em; text-align:center;" | For [[Wikipedia:Tutorial_%28Talk_pages%29|Talk Pages]]
|-
|Signature
|
<tt><nowiki>~~~~</nowiki></tt>
|
[[Special:Mypage|Your username]] {{CURRENTTIME}}, <br />
{{CURRENTDAY}} {{CURRENTMONTHNAME}} {{CURRENTYEAR}} (UTC) 
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|Indenting Text<ref name="firstline" />
|
<tt><nowiki>no indent (normal)</nowiki></tt><br/>
<tt><nowiki>:first indent</nowiki></tt><br/>
<tt><nowiki>::second indent</nowiki></tt><br/>
<tt><nowiki>:::third indent</nowiki></tt>
|
no indent (normal)<br/>
:first indent
::second indent
:::third indent
|-

|colspan="3" style="border-top:1px solid #cee0f2; font-size:0.9em;"|<references/>
|}
</div>', N'First Import', 1, '20081116 19:16:53', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'A8743C30-A526-DA45-970FB0A65A8F917D', N'58F2F999-FC99-125A-DB21FCD7085C44A1', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== Help Contents ==

Welcome to the Codex Wiki.  Here you will find the documentation to edit and create pages on this wiki.

=== Editing ===

* [[Help:Wiki Markup|Wiki Markup]] - The most common wiki markups.
* [[Help:List Markup|Lists Markup]] - Creating and using lists.
* [[Help:Cheatsheet|Wiki Markup Cheatsheet]] - Wiki Markup Cheatsheet
* [[Help:Feed Markup|Feed Markup]] - Using feed tags.
* [[Help:Messagebox Markup|Messagebox Markup]] - Using messagebox tags.
* [[Help:Codex Wiki Plugins|Codex Wiki Plugins]] - How to create your own wiki plugins and extend the wiki parser.

=== More Information ===

More information can be found via the Wikipedia site [http://en.wikipedia.org/wiki/Help:Contents Wikipedia Help] as this wiki follows many of its markup guidelines.', N'Messagebox tags.', 1, '20081116 19:17:49', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'A89594E7-970D-BE3D-C32A3395AD685354', N'A895949D-B7C5-34B5-0E32B0CE52BC3FA0', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== Messagebox Markup ==
The <nowiki><messagebox></nowiki> tag is available to integrate the [http://www.coldboxframework.com ColdBox] Messagebox Plugin into your wiki pages.

The following attributes are available to be used with the <nowiki><messagebox></nowiki> tag
<br /><br />
{|border=1 width="80%" cellpadding="5" cellspacing="0"
!Attribute!!Required!!Values!!Description
|-
||
''''''type''''''
||
No
||
info,warning,error
||
The type of messagebox to generate: info, warning or error.

Example:
<code><pre><messagebox type="error">My Message</messagebox></pre></code>
', N'First Import', 1, '20081116 19:54:14', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'B5C20C69-CF1E-5C1B-97430D6BDABBF4B6', N'E12403BB-F4C1-5F8A-1B20DB3894BAF144', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'{|align="right"
|-
| __TOC__
|}

= Welcome To Codex =
This is your Wiki landing page.  You can customize this page at anytime by clicking on the ''''''Edit'''''' button below.

== Navigation ==
To your left you can see the wiki sidebar.  From here you can comeback to this page, go to our help section, view the wiki''s rss feeds, get a wiki category listing and even see the entire wiki page directory.  Come on, try it out!!

== Search ==
The top header bar includes our incredible search engine, search for anything in a wiki page or title.  Try it out!

== Top Navigation ==
If you have the correct  or are a registered user, you can view your user profile and manage this wiki.  Just click on the ''''''Admin'''''' tab to start managing Codex.

{{{Messagebox message="Hello Everybody" type="info"}}}', N'Updates', 1, '20081119 09:17:48', 1, 0)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'B5C4FA6B-CF1E-5C1B-9830AE891E48FCD2', N'B5C4FA1D-CF1E-5C1B-950B4A04E276B736', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'{|align="right"
|-
| __TOC__
|}

= Codex Wiki Plugins =

== Introduction ==
Codex comes bundled with a set of custom wiki plugins that can be used in any wiki page by following the following syntax:

<source lang="xml">
{{{PluginName arg1="" arg2="" ...}}}
</source>

Basically, you create a tag with the name of the plugin to use and then just create arguments of name-value pairs of whatever arguments the plugin''s ''''''renderit()'''''' method takes in.

== A Wiki Plugin ==
Creating wiki plugins are very easy. Just drop them in the ''''''/App/plugins/wiki'''''' folder and you are ready to start using them in your wiki pages.

A wiki plugin is exactly just like any other ColdBox plugin. [http://ortus.svnrepository.com/coldbox/trac.cgi/wiki/cbPluginsGuide ColdBox Plugin Guide].

=== Rules ===

# Plugin component must extend ''''coldbox.system.plugin'''' and implement the coldbox plugin init() method.
# Plugin can just implement the ColdBox init() method with no inheritance, but will not be able to tap into the framework''s supertype''s methods.  It will have to do everything via the injected controller.
# Plugin must implement a method called ''''''renderit()''''''.
## This method can have 1 or more arguments.

== Example ==

So if we have a plugin called ''''''DateTime'''''', it''s source code can look like this:

<source lang="coldfusion">
<cfcomponent name="DateTime" 
			 hint="A datetime wiki plugin" 
			 extends="coldbox.system.plugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="DateTime" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("DateTime");
  		setpluginVersion("1.0");
  		setpluginDescription("A date time wiki plugin");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		<cfargument name="format" type="string" required="true" default="full" hint="Full,Short, Medium"/>
		<cfreturn dateformat(now(),arguments.format)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	
	
</cfcomponent>
</source>

And we can use it in our wiki pages like so:

<source lang="xml">
//Initial space is left so wiki doesn''t match and you can see the source
{{{ Messagebox message="Hello World!"}}}
</source>

That''s it. Welcome to the world of Codex Wiki Plugins.  Now go out and start coding your very own plugins. Below you can see a plugin at work:

{{{WikiPlugins}}}', N'First Import', 1, '20081119 09:21:03', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'C90869BF-F321-E64A-26D668F8EE8988B5', N'C90869A2-090D-50DA-0800C94BB5DB7026', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== Feed Markup ==
The <nowiki><feed></nowiki> tag is available to integrate RSS and ATOM feeds to provide dynamic information into your wiki pages.

The following attributes are available to be used with the <nowiki><feed></nowiki> tag
{|border=1 width="80%" cellpadding="5" cellspacing="0"
!Attribute!!Required!!Values!!Description
|-
||
''''''url''''''
||
Yes
||
A URL
||
Either a absolute, or root relative link to the RSS or ATOM feed.
A root relative link points directly back to the codeX wiki RSS feeds.

Example of an absolute link:
<code><pre><feed url="http://www.compoundtheory.com/?action=feed.rss" /></pre></code>

Example of a relative link:
<code><pre><feed url="/feed/directory/list.cfm" /></pre></code>
|-
||
''''''display''''''
||
No
||
bullet, numbered
||
RSS Feed data can either be displayed as regular bullet points, or by numbered bullet points.

Example of display by bullet points:
<code><pre><feed url="/feed/directory/list.cfm" display="bullet" /></pre></code>

Example of display by numbered bullet points:
<code><pre><feed url="/feed/directory/list.cfm" display="numbered" /></pre></code>

By default it is displayed by ''bullet''
|-
||
''''''cache''''''
||
No
||
number of minutes
||
The number of minutes in which the results of this RSS feed are cached.

Example of a RSS feed cached for 5 minutes
<code><pre><feed url="/feed/directory/list.cfm" cahe="5" /></pre></code>

By default, the default cache time out of the installed ColdBox.
|-
|}', N'Initial creation', 1, '20080320 08:53:34', 1, 1)
GO

INSERT INTO [dbo].[wiki_pagecontent] ([pagecontent_id], [FKpage_id], [FKuser_id], [pagecontent_content], [pagecontent_comment], [pagecontent_version], [pagecontent_createdate], [pagecontent_isActive], [pagecontent_isReadOnly])
VALUES 
  (N'E5CC1AC5-C484-565C-19E5F34B3712AD02', N'E5CC1A90-D36E-9214-33EB0021D817DE59', N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'== Category Listing ==

<feed url="/feed/category/list.cfm" display="numbered" />', N'Initial Creation', 1, '20080514 14:59:28', 1, 0)
GO

--
-- Data for table dbo.wiki_permissions  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1', N'WIKI_VIEW', N'Ability to view any wiki page')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'8840B7C9-E693-D54B-6A69F07AA5265839', N'WIKI_CREATE', N'Ability to create wiki pages')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'8840D553-F9D9-59F9-90B05EF765403F90', N'WIKI_EDIT', N'Ability to edit wiki pages')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'8840FF13-0A96-AAA9-63322F27E6713489', N'WIKI_DELETE_PAGE', N'Ability to remove pages')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'884120D4-F9D7-22CB-46341F8BCF1B68A5', N'WIKI_DELETE_VERSION', N'Ability to remove page versions')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'88415476-D0F8-32A5-7E7D3340828C0E6B', N'WIKI_ROLLBACK_VERSION', N'Ability to rollback to previous versions')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'88417F6E-CA8B-53C9-59DEF4C4888CDE82', N'WIKI_VIEW_HISTORY', N'Ability to view a page''s history')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'A9D04702-CF1E-5C1B-94C2965619E301C8', N'WIKI_ADMIN', N'Access to all the administrator panels')
GO

INSERT INTO [dbo].[wiki_permissions] ([permission_id], [permission], [description])
VALUES 
  (N'7B0058D2-78D5-4262-B8CBC221AE179FED', N'COMMENT_MODERATION', N'Ability to moderate comments.')
GO

--
-- Data for table dbo.wiki_role_permissions  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840B7C9-E693-D54B-6A69F07AA5265839', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840D553-F9D9-59F9-90B05EF765403F90', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840FF13-0A96-AAA9-63322F27E6713489', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'884120D4-F9D7-22CB-46341F8BCF1B68A5', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88415476-D0F8-32A5-7E7D3340828C0E6B', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88417F6E-CA8B-53C9-59DEF4C4888CDE82', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'A9D04702-CF1E-5C1B-94C2965619E301C8', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840B7C9-E693-D54B-6A69F07AA5265839', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840D553-F9D9-59F9-90B05EF765403F90', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'8840FF13-0A96-AAA9-63322F27E6713489', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'884120D4-F9D7-22CB-46341F8BCF1B68A5', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88417F6E-CA8B-53C9-59DEF4C4888CDE82', N'883C6A58-05CA-D886-22F7940C19F792BD')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1', N'A9D370CD-CF1E-5C1B-9B9B75680AB49DE4')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'88417F6E-CA8B-53C9-59DEF4C4888CDE82', N'A9D370CD-CF1E-5C1B-9B9B75680AB49DE4')
GO

INSERT INTO [dbo].[wiki_role_permissions] ([FKpermission_id], [FKrole_id])
VALUES 
  (N'7B0058D2-78D5-4262-B8CBC221AE179FED', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

--
-- Data for table dbo.wiki_roles  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_roles] ([role_id], [role], [description])
VALUES 
  (N'883C4730-ACC9-1AF4-93737DB4E2E368EF', N'ADMIN', N'The wiki administrator')
GO

INSERT INTO [dbo].[wiki_roles] ([role_id], [role], [description])
VALUES 
  (N'883C6A58-05CA-D886-22F7940C19F792BD', N'USER', N'A basic wiki user')
GO

INSERT INTO [dbo].[wiki_roles] ([role_id], [role], [description])
VALUES 
  (N'883C8533-DC73-C1F0-521E41EC19FD6E78', N'MODERATOR', N'A wiki moderator or editor')
GO

INSERT INTO [dbo].[wiki_roles] ([role_id], [role], [description])
VALUES 
  (N'A9D370CD-CF1E-5C1B-9B9B75680AB49DE4', N'ANONYMOUS', N'Anonymous access role')
GO

--
-- Data for table dbo.wiki_securityrules  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'88572359-B40D-B373-DE9E3DA49F37ABE5', NULL, N'^admin', N'WIKI_ADMIN', 1, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C3CA560A-CF1E-5C1B-954981333B6ECA46', NULL, N'^profile', NULL, 1, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C42598A5-CF1E-5C1B-98C39B0B163E7A98', NULL, N'^page\.show$,^page\.search,^page\.render', N'WIKI_VIEW', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C426C55E-CF1E-5C1B-9B4DE753A5DEA781', NULL, N'^page\.showHistory', N'WIKI_VIEW_HISTORY', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C42C5C1D-CF1E-5C1B-9776D52AF996EA7E', NULL, N'^page\.deleteContent', N'WIKI_DELETE_VERSION', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C42D5746-CF1E-5C1B-9D676C9985BA89CC', NULL, N'^page\.delete$', N'WIKI_DELETE_PAGE', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C42DE4B2-CF1E-5C1B-9780791CABD241E8', NULL, N'^page\.replace', N'WIKI_ROLLBACK_VERSION', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C4317156-CF1E-5C1B-917C1C422FF1B6D7', NULL, N'^page\.(create|doCreate)$', N'WIKI_CREATE', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'CE69AF93-CF1E-5C1B-9E984A4FE2CECE6F', NULL, N'^page\.(edit|doEdit)$', N'WIKI_EDIT', 0, N'user/login.cfm')
GO

INSERT INTO [dbo].[wiki_securityrules] ([securityrule_id], [whitelist], [securelist], [permissions], [authorize_check], [redirect])
VALUES 
  (N'C20DF4C9-9656-4A57-AC53529B7A3F33A9', NULL, N'^comments\.(delete|approve)$', N'COMMENT_MODERATION', 0, N'user/login.cfm')
GO

--
-- Data for table dbo.wiki_users  (LIMIT 0,500)
--

INSERT INTO [dbo].[wiki_users] ([user_id], [user_fname], [user_lname], [user_email], [user_isActive], [user_isConfirmed], [user_create_date], [user_modify_date], [user_isDefault], [user_username], [user_password], [FKrole_id])
VALUES 
  (N'A9CF56CA-CF1E-5C1B-91F2AEF8FBD03AA4', N'ANONYMOUS', N'ANONYMOUS', N'ANONYMOUS@CODEXWIKI.COM', 1, 1, '20090416 14:39:27.120', '20090416 14:39:27.120', 1, N'ANONYMOUS', N'A2AD7D448321F4D974D468E0B251030E5BED9F128BC760FA3DBA299756E9B31A4D6F8504EA4F10DC2665834E5FFA93CB978FD2FD075C53322C58CD6FE7A7A878', N'A9D370CD-CF1E-5C1B-9B9B75680AB49DE4')
GO

INSERT INTO [dbo].[wiki_users] ([user_id], [user_fname], [user_lname], [user_email], [user_isActive], [user_isConfirmed], [user_create_date], [user_modify_date], [user_isDefault], [user_username], [user_password], [FKrole_id])
VALUES 
  (N'A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1', N'admin', N'admin', N'admin@codexwiki.com', 1, 1, '20090416 14:39:27.137', '20090416 14:39:27.120', 0, N'admin', N'0CD487D652F3139D5E01E3263B3B37995602EB8692D11BB37E4DBE33F40581852C63A9964EBC233E10BEB192B2851AA613E640E5137132CA8C061D3327388E5F', N'883C4730-ACC9-1AF4-93737DB4E2E368EF')
GO

--
-- Definition for indices : 
--

CREATE NONCLUSTERED INDEX [idx_wiki_category_name] ON [dbo].[wiki_category]
  ([category_name])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_category]
ADD CONSTRAINT [PK_wiki_category] 
PRIMARY KEY CLUSTERED ([category_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpage_id] ON [dbo].[wiki_comments]
  ([FKpage_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKuser_id] ON [dbo].[wiki_comments]
  ([FKuser_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_createdate] ON [dbo].[wiki_comments]
  ([comment_createdate])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_pagecomments] ON [dbo].[wiki_comments]
  ([FKpage_id], [comment_isActive], [comment_isApproved])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_comments]
ADD CONSTRAINT [PK_wiki_comments] 
PRIMARY KEY CLUSTERED ([comment_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_customhtml]
ADD CONSTRAINT [PK_wiki_customhtml] 
PRIMARY KEY CLUSTERED ([customHTML_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_wiki_namespace_name] ON [dbo].[wiki_namespace]
  ([namespace_name])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_namespace]
ADD CONSTRAINT [PK_wiki_namespace] 
PRIMARY KEY CLUSTERED ([namespace_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_options]
ADD CONSTRAINT [PK_wiki_options] 
PRIMARY KEY CLUSTERED ([option_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKnamespace_id] ON [dbo].[wiki_page]
  ([FKnamespace_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKnamespace_id_2] ON [dbo].[wiki_page]
  ([FKnamespace_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_wiki_page_name] ON [dbo].[wiki_page]
  ([page_name])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_page]
ADD CONSTRAINT [PK_wiki_page] 
PRIMARY KEY CLUSTERED ([page_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpage_id] ON [dbo].[wiki_pagecontent]
  ([FKpage_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKuser_id] ON [dbo].[wiki_pagecontent]
  ([FKuser_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_wiki_pagecontent_isActive] ON [dbo].[wiki_pagecontent]
  ([pagecontent_isActive])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_pagecontent]
ADD CONSTRAINT [PK_wiki_pagecontent] 
PRIMARY KEY CLUSTERED ([pagecontent_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKcategory_id] ON [dbo].[wiki_pagecontent_category]
  ([FKcategory_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKcategory_id_2] ON [dbo].[wiki_pagecontent_category]
  ([FKcategory_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpagecontent_id] ON [dbo].[wiki_pagecontent_category]
  ([FKpagecontent_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpagecontent_id_2] ON [dbo].[wiki_pagecontent_category]
  ([FKpagecontent_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
ADD CONSTRAINT [PK_wiki_pagecontent_category] 
PRIMARY KEY CLUSTERED ([FKpagecontent_id], [FKcategory_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_permissions]
ADD CONSTRAINT [permission] 
UNIQUE NONCLUSTERED ([permission])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_permissions]
ADD CONSTRAINT [PK_wiki_permissions] 
PRIMARY KEY CLUSTERED ([permission_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpermission_id] ON [dbo].[wiki_role_permissions]
  ([FKpermission_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpermission_id_2] ON [dbo].[wiki_role_permissions]
  ([FKpermission_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKrole_id] ON [dbo].[wiki_role_permissions]
  ([FKrole_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKrole_id_2] ON [dbo].[wiki_role_permissions]
  ([FKrole_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_role_permissions]
ADD CONSTRAINT [PK_wiki_role_permissions] 
PRIMARY KEY CLUSTERED ([FKpermission_id], [FKrole_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_roles]
ADD CONSTRAINT [PK_wiki_roles] 
PRIMARY KEY CLUSTERED ([role_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_securityrules]
ADD CONSTRAINT [PK_wiki_securityrules] 
PRIMARY KEY CLUSTERED ([securityrule_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_securityrules]
ADD CONSTRAINT [securityrule_id] 
UNIQUE NONCLUSTERED ([securityrule_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKrole_id] ON [dbo].[wiki_users]
  ([FKrole_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_byEmail] ON [dbo].[wiki_users]
  ([user_isActive], [user_isConfirmed], [user_email])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_credentials] ON [dbo].[wiki_users]
  ([user_isActive], [user_isConfirmed], [user_username], [user_password])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_default] ON [dbo].[wiki_users]
  ([user_isDefault])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [newindex] ON [dbo].[wiki_users]
  ([user_username])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_users]
ADD CONSTRAINT [PK_wiki_users] 
PRIMARY KEY CLUSTERED ([user_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpermission_id] ON [dbo].[wiki_users_permissions]
  ([FKpermission_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKpermission_id_2] ON [dbo].[wiki_users_permissions]
  ([FKpermission_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKuser_id] ON [dbo].[wiki_users_permissions]
  ([FKuser_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FKuser_id_2] ON [dbo].[wiki_users_permissions]
  ([FKuser_id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[wiki_users_permissions]
ADD CONSTRAINT [PK_wiki_users_permissions] 
PRIMARY KEY CLUSTERED ([FKuser_id], [FKpermission_id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

--
-- Definition for foreign keys : 
--

ALTER TABLE [dbo].[wiki_comments]
ADD CONSTRAINT [wiki_comments_ibfk_1] FOREIGN KEY ([FKpage_id]) 
  REFERENCES [dbo].[wiki_page] ([page_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_comments]
ADD CONSTRAINT [wiki_comments_ibfk_2] FOREIGN KEY ([FKuser_id]) 
  REFERENCES [dbo].[wiki_users] ([user_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_page]
ADD CONSTRAINT [FKnamespace_id] FOREIGN KEY ([FKnamespace_id]) 
  REFERENCES [dbo].[wiki_namespace] ([namespace_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_pagecontent]
ADD CONSTRAINT [FK_wiki_pagecontent_wiki_page] FOREIGN KEY ([FKpage_id]) 
  REFERENCES [dbo].[wiki_page] ([page_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_pagecontent]
ADD CONSTRAINT [FK_wiki_pagecontent_wiki_users] FOREIGN KEY ([FKuser_id]) 
  REFERENCES [dbo].[wiki_users] ([user_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
ADD CONSTRAINT [FKcategory_id] FOREIGN KEY ([FKcategory_id]) 
  REFERENCES [dbo].[wiki_category] ([category_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_pagecontent_category]
ADD CONSTRAINT [FKpagecontent_id] FOREIGN KEY ([FKpagecontent_id]) 
  REFERENCES [dbo].[wiki_pagecontent] ([pagecontent_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_role_permissions]
ADD CONSTRAINT [FK_permissionid] FOREIGN KEY ([FKpermission_id]) 
  REFERENCES [dbo].[wiki_permissions] ([permission_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_role_permissions]
ADD CONSTRAINT [FKrole_id] FOREIGN KEY ([FKrole_id]) 
  REFERENCES [dbo].[wiki_roles] ([role_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_users]
ADD CONSTRAINT [FK_wiki_users_wiki_roles] FOREIGN KEY ([FKrole_id]) 
  REFERENCES [dbo].[wiki_roles] ([role_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_users_permissions]
ADD CONSTRAINT [FKpermission_id] FOREIGN KEY ([FKpermission_id]) 
  REFERENCES [dbo].[wiki_permissions] ([permission_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[wiki_users_permissions]
ADD CONSTRAINT [FKusers_id] FOREIGN KEY ([FKuser_id]) 
  REFERENCES [dbo].[wiki_users] ([user_id]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

