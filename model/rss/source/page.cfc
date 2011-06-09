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
<cfcomponent displayname="Page Listing" hint="Listings of pages" output="false" extends="codex.model.rss.AbstractSource">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!--- Constructor --->
<cffunction name="init" hint="Constructor" access="public" returntype="page" output="false">
	<cfargument name="baseURL" hint="the base feed url for the links" type="string" required="Yes">
	<cfscript>
		super.init(argumentCollection=arguments);

		return this;
	</cfscript>
</cffunction>

<!--- Pages by Category --->
<cffunction displayname="List Pages By Category"
			name="listByCategory"
			hint="Listing of pages, by a given category. Use the category query variable ex: /category/Tutorials or ?category=Tutorials. Returns xml"
			access="public"
			returntype="any"
			rss = "true"
			output="false">
	<cfargument name="category" hint="The category name, if not provided, defaults to pages with no category" type="string" required="false" default="">
	<cfscript>
		var qPages = getWikiService().getPagesByCategory(arguments.category);
		var rss = StructNew();
		var item = 0;

		rss.title = "#getWikiName()# - Pages By Category List";
		rss.link = getBaseURL() & "page/listByCategory?category=arguments.category" & getRewriteExtension();
		rss.description = "A list of all the pages, filtered by a category";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qPages">
		<cfscript>
			item = StructNew();
			item.title = replace(name, "_", " ", "all");
			item.link = getconfigService().getSetting('sesBaseURL') & "/" & getconfigService().getSetting("ShowKey") & "/" & name & getRewriteExtension();
			item.pubDate = ParseDateTime(createdDate);

			ArrayAppend(rss.item, item);
		</cfscript>
	</cfloop>
	<cffeed action="create" name="#rss#" xmlVar="rss">
	<cfreturn rss />
</cffunction>

<!--- Pages by Namespace --->
<cffunction displayname="List Pages By Namespace"
			name="listByNamespace"
			hint="Listing of pages, by a given namespace. Use the namespace query variable ex: /namespace/Help or ?namespace=Help. Returns xml"
			access="public"
			returntype="any"
			rss = "true"
			output="false">
	<cfargument name="namespace" hint="The namespace, if not provided, defaults to pages with no namespace" type="string" required="false" default="">
	<cfscript>
		var qPages = getWikiService().getPages(namespace=arguments.namespace);
		var rss = StructNew();
		var item = 0;

		rss.title = "#getWikiName()# - Pages By Namespace";
		rss.link = getBaseURL() & "page/listByNamespace?namespace=#arguments.namespace#" & getRewriteExtension();
		rss.description = "A list of all the pages, filtered by a namespace";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qPages">
		<cfscript>
			item = StructNew();
			item.title = replace(name, "_", " ", "all");
			item.link = getconfigService().getSetting('sesBaseURL') & "/" & getconfigService().getSetting("ShowKey") & "/" & name & getRewriteExtension();
			item.pubDate = ParseDateTime(createdDate);

			ArrayAppend(rss.item, item);
		</cfscript>
	</cfloop>
	<cffeed action="create" name="#rss#" xmlVar="rss">
	<cfreturn rss />
</cffunction>

<!--- All Wiki Updates --->
<cffunction displayname="Wiki Updates"
			name="listUpdates"
			hint="A list of all the latest wiki updates. Returns xml"
			access="public"
			returntype="any"
			rss = "true"
			output="false">
	<cfargument name="numberOfUpdates" hint="number of updates to retrieve, defaults to 10" type="numeric" required="No" default="10">
	<cfscript>
		var qUpdates = getWikiService().getPageUpdates(arguments.numberOfUpdates);
		var rss = StructNew();
		var item = 0;

		rss.title = "#getWikiName()# Updates";
		rss.link = getBaseURL() & "page/listUpdates" & getRewriteExtension();
		rss.description = "A list of all the latest wiki updates";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qUpdates">
		<cfscript>
			item = StructNew();
			item.title = replace(page_name, "_", " ", "all") & " edited by #user_username#";
			item.link = getconfigService().getSetting('sesBaseURL') & "/" & getconfigService().getSetting("ShowKey") & "/" & page_name & getRewriteExtension();
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

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->




</cfcomponent>