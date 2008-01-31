<cfcomponent hint="The Wiki Service layer" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiService" output="false">
	<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfscript>
		instance = StructNew();

		setTransfer(arguments.transfer);

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

<cffunction name="saveContent" hint="saves the content, and cascades to the page" access="public" returntype="void" output="false">
	<cfargument name="content" hint="The content object" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		var iterator = content.getCategoryIterator();
		var category = 0;
	</cfscript>
	<cftransaction>
	<cfscript>
		getTransfer().save(arguments.content.getPage(),false);

		while(iterator.hasNext())
		{
			//TODO: when creating a category, need to create a default page for it.
			category = iterator.next();
			getTransfer().save(category, false);
		}

		getTransfer().save(arguments.content,false);
	</cfscript>
	</cftransaction>
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

</cfcomponent>
