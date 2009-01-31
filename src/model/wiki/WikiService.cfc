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
	<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="datasource" hint="the datasource bean" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="transaction" hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
	<cfargument name="securityService" hint="the security service" type="codex.model.security.SecurityService" required="Yes">
	<cfargument name="configBean" hint="the configuration beam" type="coldbox.system.beans.configBean" required="Yes">
	<cfscript>
		/* Init */
		super.init(argumentCollection=arguments);
		
		/* Properties */
		setSecurityService(arguments.securityService);
		setAppName(arguments.configBean.getKey("appName"));
		
		/* Rewrite Extension */
		if( arguments.configBean.getKey("usingRewrite") ){
			setRewriteExtension("");
		}
		else{
			setRewriteExtension(".cfm");
		}
		
		/* Return */
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
		query.setParam("version",arguments.version);

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
<cffunction name="getPages" output="false" access="public" returntype="query" hint="Get a list of all pages in the wiki">
	<cfargument name="namespace" type="string" required="false" default="" hint="A namespace name to try to match"/>
	<cfscript>
		var tql = 0;
		var query = 0;
	</cfscript>
	<cfsavecontent variable="tql">
	<cfoutput>
		select page.name, page.pageID,
			   Namespace.name as Namespace,
			   Namespace.isDefault,
			   Namespace.Description as NamespaceDescription,
			   Namespace.namespace_id
		from
			wiki.Page as page
			join
			wiki.Namespace as Namespace
		<cfif len(trim(arguments.namespace))>
		where
			Namespace.name = :Namespace
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
	<cfargument name="limit" hint="the limit of upates" type="numeric" required="Yes">
	<cfset var qUpdates = 0 />
	<cfquery name="qUpdates" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
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
		LIMIT 0,<cfqueryparam value="#arguments.limit#" cfsqltype="cf_sql_numeric">
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
			user.username
		from
			wiki.Page as page
			join
			wiki.Content as content
			join
			security.User as user
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

<cffunction name="deletePage" hint="deletes a whole page, and all it's versions from the system" access="public" returntype="void" output="false">
	<cfargument name="pageid" hint="the id of the page to delete" type="uuid" required="Yes">
	<cfscript>
		var qDelete = 0;
	</cfscript>

	<!--- TODO: include deletion of security permissions --->

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

	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_pagecontent
		WHERE
			(FKpage_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>

	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_page
		WHERE
		(page_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>

	<cfquery name="qDelete" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
			wiki_page
		WHERE
		(page_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">)
	</cfquery>

	<cfscript>
		//we shouldn't need to discard more than this, as it will cascade
		getTransfer().discardByClassAndKey("wiki.Page", arguments.pageid);
	</cfscript>
</cffunction>

<cffunction name="getrewriteExtension" access="public" output="false" returntype="string" hint="Get rewriteExtension">
	<cfreturn instance.rewriteExtension/>
</cffunction>

<cffunction name="setrewriteExtension" access="public" output="false" returntype="void" hint="Set rewriteExtension">
	<cfargument name="rewriteExtension" type="string" required="true"/>
	<cfset instance.rewriteExtension = arguments.rewriteExtension/>
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

<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
	<cfreturn instance.securityService />
</cffunction>

<cffunction name="setSecurityService" access="private" returntype="void" output="false">
	<cfargument name="securityService" type="codex.model.security.SecurityService" required="true">
	<cfset instance.securityService = arguments.securityService />
</cffunction>

<cffunction name="getAppName" access="private" returntype="string" output="false">
	<cfreturn instance.appName />
</cffunction>

<cffunction name="setAppName" access="private" returntype="void" output="false">
	<cfargument name="appName" type="string" required="true">
	<cfset instance.appName = arguments.appName />
</cffunction>

</cfcomponent>
