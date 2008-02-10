<cfcomponent displayname="RSS Feed List" hint="RSS Feeds for Codex" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="directory" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="list" displayname="RSS Feed List" hint="A list of all the feeds currently available in this wiki" access="public" returntype="struct" output="false">
	<cfscript>
		var rss = StructNew();
		rss.title = "Rss Feed list";
		rss.link = "/feed/directory/list.cfm";
		rss.description = "A list of all the feeds currently available in this wiki";
		rss.version = "rss_2.0";


		return rss;
	</cfscript>
</cffunction>

<!--- <cfset meta.title = "Art Orders">
<cfset meta.link = "http://feedlink">
<cfset meta.description = "Orders at the art gallery">
<cfset meta.version = "rss_2.0">
 --->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>