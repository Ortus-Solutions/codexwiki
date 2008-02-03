<cfcomponent hint="Wiki Text translation observer" extends="coldbox.system.interceptor" output="false" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="onWikiPageTranslate" access="public" returntype="void" hint="Intercept Wiki Page Translation" output="false" >
	<cfargument name="event" required="true" type="coldbox.system.beans.requestContext" hint="The event object.">
	<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
	<cfscript>
		arguments.interceptData.content.visitContent(getFeed(), arguments.interceptData);
	</cfscript>
</cffunction>

<cffunction name="setFeed" access="public" returntype="void" output="false">
	<cfargument name="feed" type="codex.model.wiki.parser.Feed" required="true">
	<cfset instance.feed = arguments.feed />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getFeed" access="private" returntype="codex.model.wiki.parser.Feed" output="false">
	<cfreturn instance.feed />
</cffunction>


</cfcomponent>
