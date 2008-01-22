<cfcomponent hint="Wiki Text translation observer" extends="coldbox.system.interceptor" output="false" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="onWikiPageTranslate" access="public" returntype="void" hint="Intercept Wiki Page Translation" output="false" >
        <cfargument name="event" required="true" type="coldbox.system.beans.requestContext" hint="The event object.">
        <cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<cfscript>
			arguments.interceptData.content = getWikiText().render(arguments.interceptData.content);
		</cfscript>
</cffunction>

<cffunction name="setWikiText" access="public" returntype="void" output="false">
	<cfargument name="WikiText" type="codex.model.wiki.parser.WikiText" required="true">
	<cfset instance.WikiText = arguments.WikiText />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiText" access="private" returntype="codex.model.wiki.parser.WikiText" output="false">
	<cfreturn instance.WikiText />
</cffunction>

</cfcomponent>