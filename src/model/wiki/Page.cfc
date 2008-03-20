<cfcomponent extends="transfer.com.TransferDecorator" hint="An actual wiki page" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setName" hint="stes the page name, and sets the namespace as required" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the name of the page" type="string" required="Yes">
	<cfscript>
		var nameSpace = 0;

		getTransferObject().setName(arguments.name);

		if(ListLen(arguments.name, ":") gte 2)
		{
			nameSpace = getWikiService().getNamespace(namespaceName=ListGetAt(arguments.name, 1, ":"));
		}
		else
		{
			nameSpace = getWikiService().getDefaultNameSpace();
		}

		setNamespace(namespace);
	</cfscript>
</cffunction>

<cffunction name="getCleanName" hint="name without the '_' in it" access="public" returntype="string" output="false">
	<cfreturn replaceNoCase(getName(), "_", " ") />
</cffunction>

<cffunction name="addContentVersion" hint="adds a content version" access="public" returntype="codex.model.wiki.Content" output="false">
	<cfargument name="memento" hint="the memento to populate the new content object" type="struct" required="Yes">
	<cfscript>
		var content = getWikiService().getContent();

		content.populate(arguments.memento);
		content.setPage(this);

		getWikiService().saveContentVersion(content);

		return content;
	</cfscript>
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

</cfcomponent>