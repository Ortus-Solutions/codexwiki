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
<cfcomponent hint="The Wiki Search Factory" output="false">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------>
	
	<cfscript>
		instance = structnew();
	</cfscript>
	
	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="SearchFactory" hint="The search Factory">
		<cfargument name="configBean" 	 hint="the configuration beam" 	type="coldbox.system.beans.configBean" required="Yes">
		<cfargument name="configService" type="codex.model.wiki.ConfigService" required="true" default="" hint="The Config Service"/>
		<cfargument name="transfer"	 	 hint="the Transfer ORM" 		type="transfer.com.Transfer" required="Yes">
		<cfargument name="datasource"    hint="the datasource bean" 		type="transfer.com.sql.Datasource" required="Yes">
		<cfargument name="wikiService"   type="codex.model.wiki.WikiService" required="true" default="" hint="The wiki service"/>
		<cfscript>
				for(key in arguments){
					instance[key] = arguments[key];
				}
				return this;
			</cfscript>
		</cffunction>
	
	<!------------------------------------------- PUBLIC ------------------------------------------>
	
	<!--- getSearchEngine --->
	<cffunction name="getSearchEngine" output="false" access="public" returntype="codex.model.search.adapters.ISearchAdapter" hint="Get a search manager">
		<cfscript>
			var Options = instance.configService.getOptions();
		
			/* Setup Engine */
			return createObject("component",options.wiki_search_engine).init(argumentCollection=instance);	
		</cfscript>
	</cffunction>
	
</cfcomponent>
