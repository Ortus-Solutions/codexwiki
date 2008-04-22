<cfcomponent name="page"
			 extends="codex.handlers.baseHandler"
			 output="false"
			 hint="runs scheduled tasks"
			 autowire="true"
			 cache="true" cacheTimeout="0">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="refreshSearch" hint="refreshes the search index" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		getWikiService().refreshSearch();

		arguments.event.noRender(true);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>
<cffunction name="setWikiService" access="private" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

</cfcomponent>