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
<cfcomponent hint="Central management CFCs for all the RSS feeds that come off the wiki" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RssManager" output="false">
	<cfargument name="coldBoxController" type="coldbox.system.controller" required="true">
	<cfargument name="beanInjector" hint="the bean injector" type="any" required="Yes">
	<cfscript>
		setFeedCollection(StructNew());
		setBeanInjector(arguments.beanInjector);

		setBaseURL(arguments.coldBoxController.getSetting("sesBaseURL") & "/feed/");

		return this;
	</cfscript>
</cffunction>

<cffunction name="getRSS" hint="returns an rss feed structure" access="public" returntype="xml" output="false">
	<cfargument name="sourceName" hint="the name of the feed source" type="string" required="Yes">
	<cfargument name="feed" hint="the name of the feed to pass back" type="string" required="Yes">
	<cfargument name="feedArgs" hint="the rss feed arguments" type="struct" required="Yes">
	<cfscript>
		var source = getSource(arguments.sourceName);
		var result = "<error>Feed not found</error>";
	</cfscript>

	<cfif isObject(source) AND StructKeyExists(source, arguments.feed)>
		<cfinvoke component="#source#" method="#arguments.feed#" argumentcollection="#feedArgs#" returnvariable="result">
	</cfif>

	<cfscript>
		return result;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSource" hint="Returns the source CFC" access="private" returntype="any" output="false">
	<cfargument name="sourceName" hint="the name of the souce" type="string" required="Yes">
	<cfscript>
		var source = 0;
	</cfscript>
	<cfif NOT StructKeyExists(getFeedCollection(), arguments.sourceName)>
		<cflock name="codex.RssManager.getFeed.#arguments.sourceName#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT StructKeyExists(getFeedCollection(), arguments.sourceName))
			{
				if(NOT FileExists(getDirectoryFromPath(getMetaData(this).path) & "source/" & arguments.sourceName & ".cfc"))
				{
					return 0;
				}

				source = createObject("component", "codex.model.rss.source.#arguments.sourceName#").init(getBaseURL());
				getBeanInjector().autowire(source);

				StructInsert(getFeedCollection(), arguments.sourceName, source);
			}
		</cfscript>
		</cflock>
	</cfif>
	<cfreturn StructFind(getFeedCollection(), arguments.sourceName) />
</cffunction>

<cffunction name="getFeedCollection" access="private" returntype="struct" output="false">
	<cfreturn instance.feedCollection />
</cffunction>

<cffunction name="setFeedCollection" access="private" returntype="void" output="false">
	<cfargument name="feedCollection" type="struct" required="true">
	<cfset instance.feedCollection = arguments.feedCollection />
</cffunction>

<cffunction name="getBaseURL" access="private" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>

<cffunction name="setBaseURL" access="private" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>

<cffunction name="getBeanInjector" access="private" returntype="any" output="false">
	<cfreturn instance.beanInjector />
</cffunction>

<cffunction name="setBeanInjector" access="private" returntype="void" output="false">
	<cfargument name="beanInjector" type="any" required="true">
	<cfset instance.beanInjector = arguments.beanInjector />
</cffunction>

</cfcomponent>