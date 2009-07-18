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
<cfcomponent name="VeritySearch" hint="The Search Interface" output="false" implements="codex.model.search.adapters.ISearchAdapter">
	
<!------------------------------------------- CONSTRUCTOR ------------------------------------------>

	<cffunction name="init" hint="Constructor" access="public" returntype="codex.model.search.adapters.ISearchAdapter" output="false">
		<cfargument name="configService" 	type="codex.model.wiki.ConfigService" 	required="true" 	default="" hint="The Config Service"/>
		<cfargument name="transfer"	 	 	type="transfer.com.Transfer" 			required="true" 	hint="the Transfer ORM">
		<cfargument name="datasource"    	type="transfer.com.sql.Datasource" 		required="true" 	hint="the datasource bean">
		<cfargument name="wikiService"  	type="codex.model.wiki.WikiService" 	required="true" 	default="" hint="The wiki service"/>
		<cfscript>
			
			/* Properties */
			instance.appName = arguments.configBean.getKey("appName");
			/* Properties */
			instance.transfer = arguments.transfer;
			instance.datasource = arguments.datasource;
			instance.wikiService = arguments.wikiService;
			instance.configService = arguments.configService;
			
			/* Return */
			return this;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PUBLIC ------------------------------------------>

	<cffunction name="search" hint="do a search" access="public" returntype="struct" output="false">
		<cfargument name="search" hint="the search string" type="string" required="Yes">
		<cfset var qResults = 0 />
		<cfset var status = 0 />
	
		<cfif NOT Len(arguments.search)>
			<cfset status = {error="No search query provided"} />
			<cfreturn status />
		</cfif>
	
		<cftry>
		<cfsearch collection="#instance.appName#"
					suggestions="2"
					name="qResults"
					status="status"
					criteria="#arguments.search#"
					>
			<cfcatch>
				<cfset status = {error="Search currently not available. #cfcatch.Message#"} />
				<cfreturn status />
			</cfcatch>
		</cftry>
	
		<cfset status.results = qResults />
		<cfreturn status />
	</cffunction>
	
	<cffunction name="refreshSearch" hint="refreshes the search index" access="public" returntype="void" output="false">
		<cfscript>
			var tql = "select page.name as pageName, content.content, content.createdDate from wiki.Page as page join wiki.Content as content where content.isActive = :true";
			var query = instance.transfer.createQuery(tql);
			var qContents = 0;
	
			query.setParam("true", true, "boolean");
	
			qContents = instance.transfer.listByQuery(query);
		</cfscript>
	
		<cfindex action="refresh"
				collection = "#instance.appName#"
				body = "content"
				title="pageName"
				key="pageName"
				query="qContents"
				custom1="createdDate"
				>
	</cffunction>
	
	<!--- renderSearch --->
	<cffunction name="renderSearch" output="false" access="public" returntype="any" hint="Render a search">
		<cfargument name="result" 		type="struct" required="true" hint="The search results"/>
		<cfargument name="event" 		type="coldbox.system.beans.requestContext" required="true" default="" hint="The ColdBox Event Context"/>
		<cfargument name="controller" 	type="coldbox.system.controller" required="true" default="" hint="The coldbox controller"/>
		<cfset var search = 0>
		<cfset var pageRoot = instance.configBean.getKey('sesBaseURL') & "/" & instance.configBean.getKey('showKey') & "/" >
		
		<cfsavecontent variable="search">
		<cfoutput>
			<p>
				Found #arguments.result.results.recordCount# results in #arguments.result.searched# 
				records in #arguments.result.time#ms
			</p>
		
			<cfif StructKeyExists(arguments.result, "suggestedQuery")>
				<p>
					Did you mean: <em><a href="?search_query=#arguments.result.suggestedQuery#">#arguments.result.suggestedQuery#</a></em>?
				</p>
			</cfif>
		
			<ol>
			<cfloop query="arguments.result.results">
				<li>
					#(numberFormat((score * 100), 000) + 0)#% -
					<a href="#pageRoot & title#.cfm">#replaceNoCase(title, "_", " ", "all")# </a><br/>
					#dateFormat(custom1,"long")# #dateFormat(custom1,"long")#<br/>
					#XMLFormat(summary)#
				</li>
			</cfloop>
			</ol>
		</cfoutput>
		</cfsavecontent>
		<cfreturn search>
	</cffunction>
	
</cfcomponent>