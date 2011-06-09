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
<cfcomponent name="AbstractSource" output="false" hint="A base rss source object">


<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractSource" output="false">
	<cfargument name="baseURL" hint="the base feed url for the links" type="string" required="Yes">
	<cfscript>
		setBaseURL(arguments.baseURL);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PUBLIC DEPENDENCY SETTERS ------------------------------------------->

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<cffunction name="setConfigService" access="public" returntype="void" output="false">
	<cfargument name="configService" type="codex.model.wiki.ConfigService" required="true">
	<cfset instance.configService = arguments.configService />
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiName" access="public" returntype="string" output="false" hint="Get the name used for this wiki.">
	<cfreturn getConfigService().getOption(name="wiki_name").getValue() />
</cffunction>

<cffunction name="getconfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">
	<cfreturn instance.configService />
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

<cffunction name="getRewriteExtension" access="public" returntype="string" hint="Get the rewrite extension" output="false" >
	<cfreturn getConfigService().getrewriteExtension()>
</cffunction>

</cfcomponent>