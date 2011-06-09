<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
<cfcomponent hint="The Wiki Service layer" output="false" extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiService" output="false">
	<cfargument name="transfer" 		hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="datasource" 		hint="the datasource bean" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="transaction" 		hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
	<cfargument name="securityService" 	hint="the security service" type="codex.model.security.SecurityService" required="Yes">
	<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfscript>
	
		super.init(argumentCollection=arguments);
		
		// Properties
		setSecurityService(arguments.securityService);
		setAppName(arguments.configService.getSetting("appName"));
		setConfigService(arguments.configService);
		
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getContent" hint="returns a specific content object" access="public" returntype="codex.model.wiki.Content" output="false">
	<cfargument name="contentID" hint="the specific content id" type="string" required="no">
	<cfargument name="pageName" hint="the page name to look for the active content on" type="string" required="no">
	<cfscript>
		// retrieve by id
		if(StructKeyExists(arguments, "contentID") AND len(arguments.contentID))
		{
			return getTransfer().get("wiki.Content", arguments.contentID);
		}
		else if(StructKeyExists(arguments, "pageName") AND len(arguments.pageName))
		{
			return getContentByPageName(arguments.pageName);
		}

		return getTransfer().new("wiki.Content");
	</cfscript>
</cffunction>

<cffunction name="getContentByPageVersion" hint="returns a specific content object" access="public" returntype="codex.model.wiki.Content" output="false">
	<cfargument name="pageName" hint="the specific page name" type="string" required="yes">
	<cfargument name="version" hint="the version number" type="string" required="yes">
	<cfscript>
		var tql = 0;
		var query = 0;
		var content = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		from
			wiki.Content as content
			join
			wiki.Page as page
		where
			page.name = :name AND
			content.version = :version
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);

		query.setCacheEvaluation(true);

		query.setParam("name", arguments.pageName);
		query.setParam("version",arguments.version,"numeric");

		content = getTransfer().readByQuery("wiki.Content", query);

		return content;
	</cfscript>
</cffunction>

<cffunction name="getPage" hint="returns a specific page object" access="public" returntype="codex.model.wiki.Page" output="false">
	<cfargument name="pageID" hint="the specific page id" type="string" required="no">
	<cfargument name="pageName" hint="the page name" type="string" required="no">
	<cfscript>
		var page = 0;

		// retrieve by id
		if(StructKeyExists(arguments, "pageID") AND len(arguments.pageID))
		{
			return getTransfer().get("wiki.Page", arguments.pageID);
		}
		else if(StructKeyExists(arguments, "pageName") AND len(arguments.pageName))
		{
			page = getTransfer().readByProperty("wiki.Page", "name", arguments.pageName);

			//if the page is not persisted, we'll give it the name
			if(NOT page.getIsPersisted())
			{
				page.setName(arguments.pageName);
			}

			return page;
		}

		return getTransfer().new("wiki.Page");
	</cfscript>
</cffunction>

<!--- savePage --->
<cffunction name="savePage" output="false" access="public" returntype="void" hint="Save a page.">
	<cfargument name="page" type="codex.model.wiki.Page" required="true" hint="The page to save"/>
	<cfscript>
		var namespace = arguments.page.getNamespace();
		/* Check if namespace exists first, else persist it */
		if( not namespace.getIsPersisted() ){
			save(namespace);
		}
		/* Save Page Now */
		save(arguments.page);
	</cfscript>
</cffunction>

<!--- Save Category --->
<cffunction name="saveCategory" output="false" access="public" returntype="void" hint="Save a category in the system.">
	<cfargument name="category" type="codex.model.wiki.Category" required="true" hint="The category to save"/>
	<cfscript>
		/* Creation Date */
		arguments.category.setCreatedDate(now());
		/* Create the catgegory page first */
		arguments.category.createCategoryPage();
		/* Then persist category */
		save(arguments.category);
	</cfscript>
</cffunction>

<cffunction name="getCategory" hint="returns a Category Object" access="public" returntype="codex.model.wiki.Category" output="false">
	<cfargument name="categoryID" hint="the specific category id" type="string" required="no">
	<cfargument name="categoryName" hint="the category name" type="string" required="no">
	<cfscript>
		var category = 0;
		// retrieve by id
		if(StructKeyExists(arguments, "categoryID") AND len(arguments.categoryID))
		{
			return getTransfer().get("wiki.Category", arguments.categoryID);
		}
		else if(StructKeyExists(arguments, "categoryName") AND len(arguments.categoryName))
		{
			category = getTransfer().readByProperty("wiki.Category", "name", arguments.categoryName);

			//if the category is not persisted, we'll give it the name
			if(NOT category.getIsPersisted())
			{
				category.setName(arguments.categoryName);
			}

			return category;
		}

		return getTransfer().new("wiki.Category");
	</cfscript>
</cffunction>

<cffunction name="saveContent" hint="saves the content, and cascades to the page" access="public" returntype="void" output="false">
	<cfargument name="content" hint="The content object" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		var iterator = content.getCategoryIterator();
		var category = 0;
	</cfscript>
	<cfscript>
		//save the name space first
		getTransfer().save(arguments.content.getPage().getNamespace());
		/* Save the Page */
		getTransfer().save(arguments.content.getPage());
		/* Loop over Categories in the Content */
		while(iterator.hasNext())
		{
			category = iterator.next();

			if(NOT category.getIsPersisted())
			{
				category.createCategoryPage();
			}

			getTransfer().save(category);
		}

		if(NOT arguments.content.getIsPersisted())
		{
			arguments.content.setUser(getSecurityService().getUserSession());
		}
		/* Persist the content now. */
		getTransfer().save(arguments.content);
	</cfscript>
</cffunction>

<cffunction name="deleteContent" hint="deletes a content object" access="public" returntype="void" output="false">
	<cfargument name="content" hint="The content object" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		getTransfer().delete(arguments.content);
	</cfscript>
</cffunction>

<cffunction name="saveContentVersion" hint="saves the content versions, making the new content the active one" access="public" returntype="void" output="false">
	<cfargument name="content" hint="The content object" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		var activeContent = 0;
	</cfscript>
	<!--- lock this, so we only have 1 active content at any given time --->
	<cflock name="codex.wiki.saveContentVersion.#arguments.content.getPage().getName()#" timeout="60">
		<cfscript>
			/* Get the active content object */
			activeContent = getContent(pageName=arguments.content.getPage().getName());
			/* Check if found? */
			if(activeContent.getIsPersisted())
			{
				/* Found, so deactivate it */
				activeContent.setIsActive(false);
				/* Increase the version of the incoming content */
				arguments.content.setVersion(activeContent.getVersion() + 1);
				/* Save the now old content. */
				saveContent(activeContent);
			}
			/* Activate incoming content to save */
			arguments.content.setIsActive(true);
			/* Save it */
			saveContent(arguments.content);
		</cfscript>
	</cflock>
</cffunction>

<cffunction name="getNamespace" hint="returns a namespace Object" access="public" returntype="codex.model.wiki.Namespace" output="false">
	<cfargument name="namespaceID" hint="the specific namespace id" type="string" required="no">
	<cfargument name="namespaceName" hint="the namespace name" type="string" required="no">
	<cfscript>
		var namespace = 0;
		// retrieve by id
		if(StructKeyExists(arguments, "namespaceID") AND len(arguments.namespaceID))
		{
			return getTransfer().get("wiki.Namespace", arguments.namespaceID);
		}
		else if(StructKeyExists(arguments, "namespaceName") AND len(arguments.namespaceName))
		{
			namespace = getTransfer().readByProperty("wiki.Namespace", "name", arguments.namespaceName);

			//if the namespace is not persisted, we'll give it the name
			if(NOT namespace.getIsPersisted())
			{
				namespace.setName(arguments.namespaceName);
				namespace.setDescription(arguments.namespaceName);
			}

			return namespace;
		}

		return getTransfer().new("wiki.Namespace");
	</cfscript>
</cffunction>

<cffunction name="getDefaultNamespace" hint="gets the default namespace" access="public" returntype="codex.model.wiki.Namespace" output="false">
	<cfreturn getTransfer().readByProperty("wiki.Namespace", "isDefault", true) />
</cffunction>

<!--- getNamespaces --->
<cffunction name="getNamespaces" output="false" access="public" returntype="query" hint="Get a list of all the namespaces in the wiki">
	<cfscript>
		var query = 0;
		
		query = getTransfer().list('wiki.Namespace','name');
		
		return query;
	</cfscript>
</cffunction>

<!--- getPages --->
<cffunction name="getPages" output="false" access="public" returntype="query" hint="Get a list of all pages in the wiki or filter with a namespace">
	<cfargument name="namespace" 		type="string" 	required="false" default="" hint="A namespace name to try to match"/>
	<cfargument name="defaultNamespace" type="boolean" 	required="false" default="false" hint="Get pages for the default namespace only"/>
	<cfscript>
		var tql = 0;
		var query = 0;
		var oNamespace = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		SELECT page.name, page.pageID,
			   Namespace.name as Namespace,
			   Namespace.isDefault,
			   Namespace.Description as NamespaceDescription,
			   Namespace.namespace_id,
			   content.createdDate
		FROM
			wiki.Page as page
			JOIN
			wiki.Content as content
			JOIN
			wiki.Namespace as Namespace
		where
			content.isActive = :true
		<cfif len(trim(arguments.namespace))>
			AND
			Namespace.name = :Namespace
		<cfelseif arguments.defaultNamespace>
			AND
			Namespace.namespace_id = :NamespaceID
		</cfif>
		order by
		page.name
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		/* Run Query */
		query = getTransfer().createQuery(tql);
		/* Params */
		if( len(trim(arguments.namespace)) ){
			query.setParam("Namespace", arguments.namespace);
		}
		else if( arguments.defaultNamespace ){
			/* get default namespace */
			oNamespace = getDefaultNamespace();
			query.setParam("NamespaceID", oNamespace.getNamespace_id());
		}
		query.setParam("true", true, "boolean");
		query.setCacheEvaluation(true);
		
		/* REturn it */
		return getTransfer().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="getPagesByCategory" hint="Returns Pages by Category" access="public" returntype="query" output="false">
	<cfargument name="category" hint="the category name" type="string" required="No" default="">
	<cfscript>
		var tql = 0;
		var query = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		select
			page.name,
			content.createdDate
		from
			wiki.Page as page
			join
			wiki.Content as content
			left outer join
			wiki.Category as category
		where
			content.isActive = :true
			and
			<cfif Len(arguments.category)>
				category.name = :categoryName
			<cfelse>
				category.name IS NULL
			</cfif>
		order by
		page.name
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);
		query.setCacheEvaluation(true);

		query.setParam("true", true, "boolean");
		query.setParam("categoryName", arguments.category);

		return getTransfer().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="getPageUpdates" hint="get a list of page updates" access="public" returntype="query" output="false">
	<cfargument name="limit" type="numeric" required="true" hint="The limit of updates. -1 (All records, no cutoff)">
	<cfset var qUpdates = 0 />
	<cfquery name="qUpdates" datasource="#getDataSource().getName()#" maxrows="#arguments.limit#" 
			 username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		SELECT
			wiki_page.page_name,
			wiki_pagecontent.pagecontent_comment,
			wiki_pagecontent.pagecontent_createdate,
			wiki_pagecontent.pagecontent_version,
			wiki_users.user_username
			FROM
			wiki_pagecontent
			JOIN
			wiki_page
				ON wiki_page.page_id = wiki_pagecontent.FKpage_id
			JOIN
			wiki_users
				ON wiki_users.user_id = wiki_pagecontent.FKuser_id
		ORDER BY
			wiki_pagecontent.pagecontent_createdate desc
	</cfquery>
	<cfreturn qUpdates />
</cffunction>

<cffunction name="listCategories" hint="list all categories" access="public" returntype="query" output="false">
	<cfreturn getTransfer().list("wiki.Category", "name") />
</cffunction>

<cffunction name="getPageHistory" hint="get's a page's history" access="public" returntype="query" output="false">
	<cfargument name="pageName" hint="the page name" type="string" required="Yes">
	<cfscript>
		var tql = 0;
		var query = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		select
			page.name,
			page.pageid,
			content.contentid,
			content.comment,
			content.version,
			content.createdDate,
			content.isActive,
			CodexUser.username,
			CodexUser.email
		from
			wiki.Page as page
			join
			wiki.Content as content
			join
			security.User as CodexUser
		where
			page.name = :name
		order by
			content.version desc
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);
		query.setCacheEvaluation(true);

		query.setParam("name", arguments.pageName);

		return getTransfer().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="deletePage" hint="deletes a whole page, and all it's versions from the system. Transactioned by AOP" access="public" returntype="void" output="false">
	<cfargument name="pageid" hint="the id of the page to delete" type="uuid" required="Yes">
	<cfset var qDelete = 0>

	<!--- Remove ALL pagecontent categories First --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_pagecontent_category
		WHERE
		FKpagecontent_id IN
			(
				SELECT
					wiki_pagecontent.pagecontent_id
				FROM
					wiki_pagecontent
				WHERE
					FKpage_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">
			)
	</cfquery>
	<!--- Remove All wiki page content --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_pagecontent
		WHERE
			(FKpage_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	<!--- Remove All wiki page comments --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_comments
		WHERE
			(FKpage_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	<!--- Remove the Actual Page --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_page
		WHERE
		(page_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	
	<!--- we shouldn't need to discard more than this, as it will cascade --->
	<cfset getTransfer().discardByClassAndKey("wiki.Page", arguments.pageid)>
</cffunction>

<cffunction name="deleteCategory" hint="Deletes an entire category and its pages. Transactioned by AOP" access="public" returntype="void" output="false">
	<cfargument name="categoryID" hint="the id of the category to delete" type="uuid" required="Yes">
	<cfset var qDelete = 0>
	<cfset var oCategory = 0>
	
	<!--- Get Category --->
	<cfset oCategory = getTransfer().get('wiki.Category',arguments.categoryID)>
	
	<!--- Remove ALL pagecontent categories First --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_pagecontent_category
		WHERE
		FKcategory_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
	</cfquery>
	
	<!--- Remove the Category Now --->
	<cfset getTransfer().delete(oCategory)>
	
	<!--- Discard all objects, just in case. wish we had a discard by class? Mark, where is this?? --->
	<cfset getTransfer().discardAll()>
</cffunction>

<cffunction name="deleteNamespace" hint="Deletes an entire namespace and its pages. Transactioned by AOP" access="public" returntype="void" output="false">
	<cfargument name="namespaceid" hint="the id of the namespace to delete" type="uuid" required="Yes">
	<cfset var qDelete = 0>
	<cfset var qPages = 0>
	<cfset var idList = "">
	
	<!--- Get all pages to delete --->
	<cfquery name="qPages" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
	SELECT a.page_id
	FROM wiki_page a, wiki_namespace b
	WHERE a.FKnamespace_id = b.namespace_id AND
		  b.namespace_id = <cfqueryparam value="#arguments.namespaceid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset idList = valueList(qPages.page_id)>
	
	<cfif listLen(idList)>
		<!--- Remove ALL pagecontent categories First --->
		<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				wiki_pagecontent_category
			WHERE
			FKpagecontent_id IN
				(
					SELECT
						wiki_pagecontent.pagecontent_id
					FROM
						wiki_pagecontent
					WHERE
						FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">)
				)
		</cfquery>
		<!--- Remove All wiki page content --->
		<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				wiki_pagecontent
			WHERE
				(FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
		</cfquery>
		<!--- Remove All wiki page comments --->
		<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				wiki_comments
			WHERE
				(FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
		</cfquery>
		<!--- Remove the Actual Pages --->
		<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				wiki_page
			WHERE
			(page_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
		</cfquery>
	</cfif>
	
	<!--- Remove the Namespace --->
	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_namespace
		WHERE
			namespace_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.namespaceid#">
	</cfquery>
	<!--- Discard all objects, just in case. wish we had a discard by class? Mark, where is this?? --->
	<cfset getTransfer().discardAll()>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getContentByPageName" hint="returns the active content by page name" access="private" returntype="codex.model.wiki.Content" output="false">
	<cfargument name="pageName" hint="the page name to look for the active content on" type="string" required="true">
	<cfscript>
		var tql = 0;
		var query = 0;
		var content = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		from
			wiki.Content as content
			join
			wiki.Page as page
		where
			page.name = :name
			and
			content.isActive = :active
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);

		query.setCacheEvaluation(true);

		query.setParam("name", arguments.pageName);
		query.setParam("active", true, "boolean");

		content = getTransfer().readByQuery("wiki.Content", query);

		//if the object is not persisted, we'll pass in the title of the page
		if(NOT content.getIsPersisted())
		{
			content.setPage(getPage(pageName=arguments.pageName));
		}

		return content;
	</cfscript>
</cffunction>

<!--- Get/Set Security Service --->
<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
	<cfreturn instance.securityService />
</cffunction>
<cffunction name="setSecurityService" access="private" returntype="void" output="false">
	<cfargument name="securityService" type="codex.model.security.SecurityService" required="true">
	<cfset instance.securityService = arguments.securityService />
</cffunction>

<!--- Get/Set Config Service --->
<cffunction name="getconfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">
	<cfreturn instance.configService>
</cffunction>
<cffunction name="setconfigService" access="private" returntype="void" output="false">
	<cfargument name="configService" type="codex.model.wiki.ConfigService" required="true">
	<cfset instance.configService = arguments.configService>
</cffunction>

<!--- Get/Set App Name --->
<cffunction name="getAppName" access="private" returntype="string" output="false">
	<cfreturn instance.appName />
</cffunction>
<cffunction name="setAppName" access="private" returntype="void" output="false">
	<cfargument name="appName" type="string" required="true">
	<cfset instance.appName = arguments.appName />
</cffunction>

</cfcomponent>
