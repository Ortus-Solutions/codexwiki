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
<cfinterface displayname="ISearchAdapter" hint="The Search Interface">
	
	<!--- Constructor --->
	<cffunction name="init" hint="Constructor" access="public" returntype="codex.model.search.adapters.ISearchAdapter" output="false">
		<cfargument name="configService" 	type="codex.model.wiki.ConfigService" 	required="true" 	default="" hint="The Config Service"/>
		<cfargument name="transfer"	 	 	type="transfer.com.Transfer" 			required="true" 	hint="the Transfer ORM">
		<cfargument name="datasource"    	type="transfer.com.sql.Datasource" 		required="true" 	hint="the datasource bean">
		<cfargument name="wikiService"  	type="codex.model.wiki.WikiService" 	required="true" 	default="" hint="The wiki service"/>
	</cffunction>
	
	<!--- search --->
	<cffunction name="search" output="false" access="public" returntype="struct" hint="Search">
		<cfargument name="search" hint="the search string" type="string" required="Yes">	
	</cffunction>

	<!--- Refresh Search --->
	<cffunction name="refreshSearch" hint="refreshes the search index" access="public" returntype="void" output="false">
	</cffunction>
	
	<!--- renderSearch --->
	<cffunction name="renderSearch" output="false" access="public" returntype="any" hint="Render a search">
		<cfargument name="result" 		type="struct" 								required="true" hint="The search results"/>
		<cfargument name="event" 		type="coldbox.system.beans.requestContext" 	required="true" default="" hint="The ColdBox Event Context"/>
		<cfargument name="controller" 	type="coldbox.system.controller" 			required="true" default="" hint="The coldbox controller"/>
	</cffunction>
	
</cfinterface>
