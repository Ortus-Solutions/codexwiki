<cfcomponent hint="handler for wiki rss feeds" extends="baseHandler" autowire="true" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="show" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var rc = arguments.event.getCollection();

		rc.rss = getRssManager().getRSS(rc.source, rc.feed, rc);

		setDebugMode(false);

		arguments.event.setLayout("Layout.xml");

		arguments.event.setView("rss/rss");
	</cfscript>
</cffunction>

<cffunction name="setRssManager" access="public" returntype="void" output="false">
	<cfargument name="rssManager" type="codex.model.rss.RSSManager" required="true">
	<cfset instance.rssManager = arguments.rssManager />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getRssManager" access="private" returntype="codex.model.rss.RSSManager" output="false">
	<cfreturn instance.rssManager />
</cffunction>

</cfcomponent>