<cfcomponent extends="transfer.com.TransferDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

</cfcomponent>