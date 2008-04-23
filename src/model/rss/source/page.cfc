<cfcomponent displayname="Page Listing" hint="Listings of pages" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="page" output="false">
	<cfargument name="baseURL" hint="the base feed url for the links" type="string" required="Yes">
	<cfscript>
		setBaseURl(arguments.baseURL);

		return this;
	</cfscript>
</cffunction>

<cffunction displayname="List Pages By Category"
			name="listByCategory"
			hint="Listing of pages, by a given category"
			access="public"
			returntype="xml"
			rss = "true"
			output="false">
	<cfargument name="category" hint="The category name, if not provided, defaults to pages with no category" type="string" required="false" default="">
	<cfscript>
		var qPages = getWikiService().getPagesByCategory(arguments.category);
		var rss = StructNew();
		var item = 0;

		rss.title = "Page By Category List";
		rss.link = getBaseURL() & "page/listByCategory.cfm";
		rss.description = "A list of all the pages, filtered by a category";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qPages">
		<cfscript>
			item = StructNew();
			item.title = replace(name, "_", " ", "all");
			item.link = getColdBoxController().getSetting('sesBaseURL') & "/" & getColdBoxController().getSetting("ShowKey") & "/" & name & ".cfm";
			item.pubDate = ParseDateTime(createdDate);

			ArrayAppend(rss.item, item);
		</cfscript>
	</cfloop>
	<cffeed action="create" name="#rss#" xmlVar="rss">
	<cfreturn rss />
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<cffunction name="setColdBoxController" access="public" returntype="void" output="false">
	<cfargument name="coldBoxController" type="coldbox.system.controller" required="true">
	<cfset instance.coldBoxController = arguments.coldBoxController />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getColdBoxController" access="private" returntype="coldbox.system.controller" output="false">
	<cfreturn instance.coldBoxController />
</cffunction>

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

<cffunction name="getBaseURL" access="private" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>

<cffunction name="setBaseURL" access="private" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>



</cfcomponent>