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
	<cfargument name="configBean" type="coldbox.system.beans.configBean" required="true">
	<cfargument name="beanInjector" hint="the bean injector" type="any" required="Yes">
	<cfscript>
		/* Stores all feed objects lazy loaded */
		setFeedCollection(StructNew());
		/* The bean injector to use */
		setBeanInjector(arguments.beanInjector);
		/* the application's base URL for link creation */
		setBaseURL(arguments.configBean.getKey("sesBaseURL") & "/feed/");
		/* Save the application's config Bean */
		setConfigBean(arguments.configBean);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getRSS" hint="returns an rss feed structure in xml. This is the entry point for all rss feeds." access="public" returntype="any" output="false">
	<cfargument name="sourceName" 	 type="string" required="Yes" hint="the name of the feed source">
	<cfargument name="feed" 		 type="string" required="Yes" hint="the name of the feed to pass back">
	<cfargument name="feedArgs" 	 type="struct" required="Yes" hint="the rss feed arguments">
	<cfscript>
		/* Get a source CFC according to name of the feed,should match the name of the cfc */
		var source = getSource(arguments.sourceName);
		var result = "<error>Feed not found</error>";
	</cfscript>
	
	<!--- Check if source is an object and if the feed argument matches to a method --->
	<cfif isObject(source) AND StructKeyExists(source, arguments.feed)>
		<cfinvoke component="#source#" method="#arguments.feed#" argumentcollection="#feedArgs#" returnvariable="result">
	</cfif>
	
	<cfreturn result>
</cffunction>

<!--- Get the temp directory for rss generations --->
<cffunction name="getTempRSSDirectory" access="public" output="false" returntype="string" hint="Get getTempRSSDirectory for rss generations">
	<cfreturn getconfigBean().getKey('RSSTempDirectory') />
</cffunction>

<!--- Get/Set Base URL --->
<cffunction name="getBaseURL" access="public" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>
<cffunction name="setBaseURL" access="public" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>

<!--- Get/set Config Bean --->
<cffunction name="getconfigBean" access="public" output="false" returntype="coldbox.system.beans.configBean" hint="Get configBean">
	<cfreturn instance.configBean/>
</cffunction>
<cffunction name="setconfigBean" access="public" output="false" returntype="void" hint="Set configBean">
	<cfargument name="configBean" type="coldbox.system.beans.configBean" required="true"/>
	<cfset instance.configBean = arguments.configBean/>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSource" hint="Returns the source CFC for feeds. If not found, this function returns a 0" access="private" returntype="any" output="false">
	<cfargument name="sourceName" hint="the name of the source cfc" type="string" required="Yes">
	<cfset var source = 0>
	
	<!--- Check if source CFC in feed collection --->
	<cfif NOT StructKeyExists(getFeedCollection(), arguments.sourceName)>
		<cflock name="codex.RssManager.getFeed.#arguments.sourceName#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT StructKeyExists(getFeedCollection(), arguments.sourceName))
			{
				/* verify file exists */
				if(NOT FileExists(getDirectoryFromPath(getMetaData(this).path) & "source/" & arguments.sourceName & ".cfc"))
				{
					return 0;
				}
				
				/* Create a rss source object */
				source = createObject("component", "codex.model.rss.source.#arguments.sourceName#").init(getBaseURL());
				/* Autowire this puppy */
				getBeanInjector().autowire(source);
				/* Cache the source object */
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

<cffunction name="getBeanInjector" access="private" returntype="any" output="false">
	<cfreturn instance.beanInjector />
</cffunction>

<cffunction name="setBeanInjector" access="private" returntype="void" output="false">
	<cfargument name="beanInjector" type="any" required="true">
	<cfset instance.beanInjector = arguments.beanInjector />
</cffunction>

</cfcomponent>