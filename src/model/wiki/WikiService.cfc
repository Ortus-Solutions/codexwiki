<cfcomponent hint="The Wiki Service layer" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiService" output="false">
	<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="transaction" hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
	<cfscript>
		instance = StructNew();

		setTransfer(arguments.transfer);

		arguments.transaction.advise(this, "^save");

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

<cffunction name="getPage" hint="returns a specific page object" access="public" returntype="codex.model.wiki.Page" output="false">
	<cfargument name="pageID" hint="the specific page id" type="string" required="no">
	<cfscript>
		// retrieve by id
		if(StructKeyExists(arguments, "pageID") AND len(arguments.pageID))
		{
			return getTransfer().get("wiki.Page", arguments.pageID);
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

<cffunction name="saveContent" hint="saves the content, and cascades to the page" access="public" returntype="void" output="false">
	<cfargument name="content" hint="The content object" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		var iterator = content.getCategoryIterator();
		var category = 0;
	</cfscript>
	<cfscript>
		//save the name space first
		getTransfer().save(arguments.content.getPage().getNamespace(), false);

		getTransfer().save(arguments.content.getPage(),false);

		while(iterator.hasNext())
		{
			category = iterator.next();

			if(NOT category.getIsPersisted())
			{
				category.createCategoryPage();
			}

			getTransfer().save(category, false);
		}

		getTransfer().save(arguments.content,false);
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
			content.setPageName(arguments.pageName);
		}

		return content;
	</cfscript>
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

<cffunction name="transaction" hint="Runs a method inside a transaction, if one already doesn't exist" access="private" returntype="void" output="false">
	<cfargument name="command" hint="the command method to run in a transaction" type="any" required="Yes">
	<cfargument name="commandArgs" hint="the command arguments" type="struct" required="Yes">
	<cfscript>
		var call = arguments.command;
	</cfscript>
	<cfif getInTransaction()>
		<cfset call(argumentCollection=arguments.commandArgs) />
	<cfelse>
		<cftransaction>
			<cfscript>
				getTransactionLocal().set(true);
				call(argumentCollection=arguments.commandArgs);
			</cfscript>
		</cftransaction>
		<cfscript>
			getTransactionLocal().set(false);
		</cfscript>
	</cfif>
</cffunction>

<cffunction name="getInTransaction" hint="returnsif we are in a transaction" access="private" returntype="boolean" output="false">
	<cfscript>
		var local = StructNew();
		local.in = getTransactionLocal().get();

		if(NOT StructKeyExists(local, "in"))
		{
			getTransactionLocal().set(false);
		}

		return getTransactionLocal().get();
	</cfscript>
</cffunction>

<cffunction name="getTransactionLocal" access="private" returntype="any" output="false">
	<cfreturn instance.transactionLocal />
</cffunction>

<cffunction name="setTansactionLocal" access="private" returntype="void" output="false">
	<cfargument name="transactionLocal" type="any" required="true">
	<cfset instance.transactionLocal = arguments.transactionLocal />
</cffunction>

</cfcomponent>
