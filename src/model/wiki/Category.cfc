<cfcomponent extends="transfer.com.TransferDecorator" hint="An category for a wiki page" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!---
In case we need them later
<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>
--->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!---
<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>
--->

</cfcomponent>