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
<cfcomponent displayname="Namespace Listing" hint="Listings of namespaces and the such" output="false" extends="codex.model.rss.AbstractSource">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!--- Constructor --->
<cffunction name="init" hint="Constructor" access="public" returntype="namespace" output="false">
	<cfargument name="baseURL" hint="the base feed url for the links" type="string" required="Yes">
	<cfscript>
		super.init(argumentCollection=arguments);

		return this;
	</cfscript>
</cffunction>

<!--- List Method --->
<cffunction name="list" displayname="Namespace Listing"
						hint="Listing of all the Namespaces in the system. Returns xml"
						access="public"
						returntype="any"
						rss="true"
						output="false">
	<cfscript>
		var qNamespaces = getWikiService().getNamespaces();
		var rss = StructNew();
		var item = 0;

		rss.title = "#getWikiName()# - Namespaces";
		rss.link = getBaseURL() & "namespace/list" & getRewriteExtension();
		rss.description = "A list of all the namespaces in this wiki";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>
	<cfloop query="qNamespaces">
		<cfscript>
			item = StructNew();
			item.title = replace(name, "_", " ", "all");
			item.link = getconfigService().getSetting('sesBaseURL') & "/" & getconfigService().getSetting("SpaceKey") & "/" & URLEncodedFormat(name) & getRewriteExtension();
			item.pubDate = ParseDateTime(createdDate);

			ArrayAppend(rss.item, item);
		</cfscript>
	</cfloop>
	<cffeed action="create" name="#rss#" xmlVar="rss">
	<cfreturn rss />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->





</cfcomponent>