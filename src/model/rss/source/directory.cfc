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
<cfcomponent displayname="RSS Feed List" hint="RSS Feeds for Codex" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="directory" output="false">
	<cfargument name="baseURL" hint="the base feed url for the links" type="string" required="Yes">
	<cfscript>
		setBaseURl(arguments.baseURL);

		return this;
	</cfscript>
</cffunction>

<cffunction name="list"
			displayname="RSS Feed List"
			hint="A list of all the feeds currently available in this wiki"
			access="public"
			returntype="xml"
			rss = "true"
			output="false">
	<cfscript>
		var rss = StructNew();
		var meta = 0;
		var func = 0;
		var qCFCs = getRSSCFCs();
		var item = 0;

		rss.title = "Rss Feed list";
		rss.link = getBaseURL() & "directory/list.cfm";
		rss.description = "A list of all the feeds currently available in this wiki";
		rss.version = "rss_2.0";

		rss.item = ArrayNew(1);
	</cfscript>

	<cfloop query="qCFCs">
		<cfscript>
			meta = getComponentMetaData("codex.model.rss.source." & Left(name, Len(name) - 4));
		</cfscript>
		<cfloop array="#meta.functions#" index="func">
			<cfscript>
				//if not 'rss=true' annotation, then it doesn't display
				if((NOT StructKeyExists(func, "access")
						OR func.access eq "public"
					)
					AND StructKeyExists(func, "rss")
					AND func.rss)
				{
					item = StructNew();

					item.title = func.displayName;
					item.description.value = buildFeedDescription(func);

					item.link = getBaseURL() & ListGetAt(meta.name, ListLen(meta.name, "."), ".") & "/" & func.name & ".cfm";

					ArrayAppend(rss.item, item);
				}
			</cfscript>
		</cfloop>
	</cfloop>

	<cffeed action="create" name="#rss#" xmlVar="rss">

	<cfreturn rss />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildFeedDescription" hint="builds the feed description from the functionmeta" access="private" returntype="string" output="false">
	<cfargument name="functionMeta" hint="the function meta" type="struct" required="Yes">
	<cfscript>
		var description = createObject("java", "java.lang.StringBuffer").init(arguments.functionMeta.hint);
		var len = arrayLen(arguments.functionMeta.parameters);
		var counter = 1;
		var arg = 0;

		if(len)
		{
			description.append("<p>URL Parameters: <ul>");

			for(; counter <= len; counter++)
			{
				arg = arguments.functionMeta.parameters[counter];
				description.append("<li>#arg.name# - #arg.hint#</li>");
			}

			description.append("</ul></p>");
		}

		return description.toString();
	</cfscript>
</cffunction>

<cffunction name="getRSSCFCs" hint="returns a query of all the rss cfcs" access="public" returntype="query" output="false">
	<cfscript>
		var qCFCs = 0;
	</cfscript>
	<cfdirectory action="list" directory="#getDirectoryFromPath(getMetaData(this).path)#" filter="*.cfc" name="qCFCs">
	<cfreturn qCFCs />
</cffunction>

<cffunction name="getBaseURL" access="private" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>

<cffunction name="setBaseURL" access="private" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>

</cfcomponent>