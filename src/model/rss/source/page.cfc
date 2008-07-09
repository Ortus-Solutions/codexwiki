<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
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

<cffunction displayname="Wiki Updates"
			name="listUpdates"
			hint="A list of all the latest wiki updates"
			access="public"
			returntype="xml"
			rss = "true"
			output="false">
	<cfargument name="numberOfUpdates" hint="number of updates to retrieve, defaults to 10" type="numeric" required="No" default="10">
	<cfscript>
		var qUpdates = getWikiService().getPageUpdates(arguments.numberOfUpdates);
		var rss = StructNew();
		var item = 0;

		rss.title = "Wiki Updates";
		rss.link = getBaseURL() & "page/listUpdates.cfm";
		rss.description = "A list of all the latest wiki updates";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qUpdates">
		<cfscript>
			item = StructNew();
			item.title = replace(page_name, "_", " ", "all");
			item.link = getColdBoxController().getSetting('sesBaseURL') & "/" & getColdBoxController().getSetting("ShowKey") & "/" & page_name & ".cfm";
			item.pubDate = ParseDateTime(pagecontent_createdate);
			item.description.value = "Page ";

			if(pagecontent_version eq 1)
			{
				item.description.value &= "created ";
			}
			else
			{
				item.description.value &= "edited ";
			}
			item.description.value &= " by " & user_username & ".<br/>";

			item.description.value &= pagecontent_comment;

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