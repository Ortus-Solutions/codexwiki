<cfcomponent hint="Remote access to wiki services" output="false">
<cfsetting showdebugoutput="false">
<cfscript>
	setWikiService(application.cbController.getPlugin("ioc").getBean("WikiService"));
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getContentHTML" hint="returns a specific content html" access="remote" returntype="string" output="false" returnFormat="plain">
	<cfargument name="contentid" hint="the id of the content item to displlay" type="string" required="Yes">
	<cfscript>
		var content = getWikiService().getContent(arguments.contentid);
		return content.render();
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