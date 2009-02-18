<!---
Migration script:
Please run this first, then use your favorite IDE or command line to import
the helpcontent.sql
--->
<cfoutput><h2>Migration Starting...</h2></cfoutput>
<cfflush><cfflush>

<cftransaction>
<!--- Drop Wiki Options --->
<cfquery name="qHelp" datasource="#request.dsn#">
DROP TABLE /*!32312 IF EXISTS*/ `wiki_options`;
</cfquery>
<cfquery name="qHelp" datasource="#request.dsn#">
CREATE TABLE `wiki_options` (
  `option_id` varchar(36) NOT NULL,
  `option_name` varchar(255) NOT NULL,
  `option_value` text NOT NULL,
  PRIMARY KEY  (`option_id`)
)DEFAULT CHARACTER SET utf8 ENGINE=InnoDB
</cfquery>

<cftry>
	<!--- Help Removeals --->
	<cfquery name="qHelp" datasource="#request.dsn#">
	ALTER TABLE `wiki_options` ADD UNIQUE INDEX Index_2(`option_name`);
	</cfquery>
	<cfquery name="qHelp" datasource="#request.dsn#">
	ALTER TABLE `wiki_customhtml` ADD `customHTML_afterSideBar` TEXT NULL AFTER `customHTML_modify_date`;
	</cfquery>
	<cfquery name="qHelp" datasource="#request.dsn#">
	ALTER TABLE `wiki_customhtml` ADD `customHTML_beforeSideBar` TEXT NULL AFTER `customHTML_afterSideBar`;
	</cfquery>
	<cfquery name="qHelp" datasource="#request.dsn#">
	ALTER TABLE `wiki_pagecontent` ADD COLUMN `pagecontent_isReadOnly` BOOLEAN NOT NULL DEFAULT false AFTER `pagecontent_isActive`;
	</cfquery>
	<cfquery name="qHelp" datasource="#request.dsn#">
	ALTER TABLE `wiki_users` ADD UNIQUE INDEX newindex(`user_username`);
	</cfquery>
	<cfcatch type="database">
		<p>
			Database changes already made, Continuing migration.
		</p>
	</cfcatch>
</cftry>
<cftry>
	<!--- Append To Namespaces The Create Date--->
	<cfquery name="qNamespace" datasource="#request.dsn#">
	ALTER TABLE `wiki_namespace` ADD COLUMN `namespace_createddate` datetime AFTER `namespace_isdefault`
	</cfquery>
	<cfquery name="qNamespace" datasource="#request.dsn#">
	UPDATE `wiki_namespace`
	SET `namespace_createddate` = '#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:mm:ss")#'
	</cfquery>
	<!--- Add Page Title and passwords --->
	<cfquery name="qNamespace" datasource="#request.dsn#">
	ALTER TABLE `wiki_page` 
	 ADD COLUMN `page_title` varchar(255) AFTER `FKnamespace_id`,
	 ADD COLUMN `page_password` varchar(255) AFTER `page_title`,
	 ADD COLUMN `page_description` varchar(255) AFTER `page_password`,
	 ADD COLUMN `page_keywords` varchar(255) AFTER `page_description`
	</cfquery>
	<cfcatch type="database">
		<p>
			Beta 2 changes already done.
		</p>
	</cfcatch>
</cftry>

<!--- Options --->
<cfquery name="qHelp" datasource="#request.dsn#">
INSERT IGNORE INTO `wiki_options` (`option_id`,`option_name`,`option_value`) VALUES
('9F03F883-AFFA-A78C-1A2EDA50675A3B46','wiki_defaultpage','Dashboard'),
('9F045002-0E99-A690-7C59F405F98A19BE','wiki_search_engine','codex.model.search.adapters.DBSearch'),
('9F0485D1-F0AB-DF57-DCD68A6AE5F2FF33','wiki_name','A Sweet Wiki'),
('9F050595-E875-9C19-9978C4F271441867','wiki_paging_maxrows','10'),
('9F052A79-DA80-9757-F8B952EFF0BF467E','wiki_paging_bandgap','5'),
('9F05890F-C8D4-A7E1-7C60462D3C7AA437','wiki_defaultpage_label','My Dashboard'),
('9F0622D3-A20F-60CF-5AE67B68F7294189','wiki_comments_mandatory','1'),
('9F0716AB-AF0A-8D94-4AEAA59490D24CB2','wiki_outgoing_email','myemail@email.com'),
('A2E52F85-EC94-6F0D-63D54DA07F9054E9','wiki_defaultrole_id','883C6A58-05CA-D886-22F7940C19F792BD'),
('B1D80246-CF1E-5C1B-91310C4FA0F78984','wiki_metadata','codex wiki'),
('B1DD1CDD-CF1E-5C1B-9106B89C23AB9410','wiki_metadata_keywords','codex coldbox transfer wiki'),
('C5BFE426-F38C-8745-2CA44F6B29D5A19B','wiki_registration','true'),
('3331E8AF-F41F-4CF5-A2F519959BF4342B','wiki_gravatar_display','true'),
('E487E2CE-8BE0-482C-A71249423D4FC757','wiki_gravatar_rating','pg');
</cfquery>

<!--- Get all Help Namespace pages --->
<cfquery name="qHelp" datasource="#request.dsn#">
select a.*
from wiki_page a, wiki_namespace b
where a.FKnamespace_id = b.namespace_id AND
b.namespace_name = 'Help';
</cfquery>
<!--- page_ids --->
<cfset helpIDs = valueList(qHelp.page_id)>
<!--- Remove Pagecontent --->
<cfquery name="qHelpContent" datasource="#request.dsn#">
delete
from wiki_pagecontent
where FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#helpIDs#">)
</cfquery>
<!--- Delete Pages --->
<cfquery name="qHelpContent" datasource="#request.dsn#">
delete
from wiki_page
where page_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#helpIDs#">)
</cfquery>

<!--- Insert New Wiki Help --->
<cfquery name="qInsert" datasource="#request.dsn#">
INSERT INTO wiki_page ( page_id, page_name, FKnamespace_id ) VALUES ('58F2F999-FC99-125A-DB21FCD7085C44A1','Help:Contents','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('59014C5F-C1C6-7E91-A38446214A380C7D','Help:Wiki_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('59104F5A-9555-E540-6BCAA65D9AE6F448','Help:List_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('A8736248-DCE2-A123-A6DA083754C59203','Help:Cheatsheet','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('A895949D-B7C5-34B5-0E32B0CE52BC3FA0','Help:Messagebox_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('C90869A2-090D-50DA-0800C94BB5DB7026','Help:Feed_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295'),
('B5C4FA1D-CF1E-5C1B-950B4A04E276B736','Help:Codex_Wiki_Plugins', '58F2F981-F62A-3124-E886BBF8CE6C5295')
</cfquery>

<!--- Wiki Registration permission removal --->
<cfquery name="qInsert" datasource="#request.dsn#">
delete
from wiki_users_permissions 
where FKpermission_id in (select permission_id from wiki_permissions where permission = 'WIKI_REGISTRATION')
</cfquery>
<cfquery name="qInsert" datasource="#request.dsn#">
delete 
from wiki_role_permissions 
where FKpermission_id in (select permission_id from wiki_permissions where permission = 'WIKI_REGISTRATION')
</cfquery>
<cfquery name="qInsert" datasource="#request.dsn#">
delete 
from wiki_permissions 
where permission = 'WIKI_REGISTRATION'
</cfquery>

<!--- let's try and import the help scripts --->
<cffile action="read" file="#expandPath('assets/helpcontent.sql')#" variable="helpsql">

<cfscript>
	split = "INSERT INTO";
	helpstatements = helpsql.split(split);
</cfscript>

<cfloop array="#helpstatements#" index="statement">
	<cfif statement.startsWith(' `wiki_pagecontent`')>

		<cfset statement = rereplace(statement, ";[\s]*$", "") />

		<cfquery name="qInsert" datasource="#request.dsn#">
			#split#
			#PreserveSingleQuotes(statement)#
		</cfquery>
	<cfelse>
		<p>
			<cfoutput><strong>Statement ignored:</strong> [#statement#];</cfoutput>
		</p>
	</cfif>
</cfloop>

</cftransaction>

<cfoutput>
<h2>Migration Finalized...</h2>
</cfoutput>
<!--- <cfdump var="#variables#"> --->