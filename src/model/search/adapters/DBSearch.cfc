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
<cfcomponent name="DBSearch" hint="The Search Interface" output="false" implements="codex.model.search.adapters.ISearchAdapter">
	
<!------------------------------------------- CONSTRUCTOR ------------------------------------------>

	<cffunction name="init" hint="Constructor" access="public" returntype="codex.model.search.adapters.ISearchAdapter" output="false">
		<cfargument name="configService" 	type="codex.model.wiki.ConfigService" 	required="true" 	default="" hint="The Config Service"/>
		<cfargument name="transfer"	 	 	type="transfer.com.Transfer" 			required="true" 	hint="the Transfer ORM">
		<cfargument name="datasource"    	type="transfer.com.sql.Datasource" 		required="true" 	hint="the datasource bean">
		<cfargument name="wikiService"  	type="codex.model.wiki.WikiService" 	required="true" 	default="" hint="The wiki service"/>
		<cfscript>
			
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
		<cfset var qResults = 0>
		<cfset var qTemp = 0>
		<cfset var status = structnew()>
		<cfset var sTime = getTickCount()>
		
		<cfif NOT Len(arguments.search)>
			<cfset status = {error="No search query provided"} />
			<cfreturn status />
		</cfif>
		
		<!--- Get Total Records --->
		<cfquery name="qTemp" datasource="#instance.datasource.getName()#">
		select count(*) as TotalPages
		from wiki_page
		</cfquery>
		<cfset status.searched = qTemp.TotalPages>
		
		<!--- Get Search --->
		<cfquery name="qResults" datasource="#instance.datasource.getName()#">
		select *
		from wiki_page 
		inner join wiki_pagecontent on wiki_page.page_id = wiki_pagecontent.FKpage_id
		where pagecontent_isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> AND
			 (
			  wiki_page.page_name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%"> OR
			  wiki_pagecontent.pagecontent_content like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
			  )
		</cfquery>
		<cfset status.results = qResults />
		
		<!--- Total Time --->
		<cfset status.time = getTickCount()-stime>
		
		<!--- Return Results --->
		<cfreturn status>
	</cffunction>
	
	<cffunction name="refreshSearch" hint="refreshes the search index" access="public" returntype="void" output="false">
		 <!--- Not IMplemented by this implementation --->
	</cffunction>
	
	<!--- renderSearch --->
	<cffunction name="renderSearch" output="false" access="public" returntype="any" hint="Render a search">
		<cfargument name="result" 		type="struct" required="true" hint="The search results"/>
		<cfargument name="event" 		type="coldbox.system.beans.requestContext" required="true" default="" hint="The ColdBox Event Context"/>
		<cfargument name="controller" 	type="coldbox.system.controller" required="true" default="" hint="The coldbox controller"/>
		<cfset var search = 0>
		<cfset var pageRoot = instance.configService.getSetting('sesBaseURL') & "/" & instance.configService.getSetting('showKey') & "/" >
		
		<cfsavecontent variable="search">
		<cfoutput>
			<style>
			.highlight { background-color: yellow; font-weight:bold }
			cite {color: green; }
			</style>
			<p>
				Found #arguments.result.results.recordCount# results in #arguments.result.searched# 
				records in #arguments.result.time#ms
			</p>
		
			<ol>
			<cfloop query="arguments.result.results">
				<li>
					<a href="#pageRoot & page_name & instance.configService.getRewriteExtension()#">#replaceNoCase(page_name, "_", " ", "all")# </a><br/>
					#highlightSearchTerm(arguments.event.getValue("search_query",''),pagecontent_content)#
				</li>
				<cite>#pageRoot#<strong>#page_name#</strong>#instance.configService.getRewriteExtension()#</cite>
				<br /><br />
			</cfloop>
			</ol>
		</cfoutput>
		</cfsavecontent>
		<cfreturn search>
	</cffunction>
	
	<!--- highlightSearchTerm --->
	<cffunction name="highlightSearchTerm" output="false" access="private" returntype="any" hint="Highlight a search term">
		<cfargument name="term" type="string" required="true" hint="The term"/>
		<cfargument name="content" type="string" required="true"  hint="The content"/>
		<!--- highlight search terms --->
		<cfset var match = findNoCase(arguments.term, arguments.content)>
		<cfset var end = 0>
		<cfset var excerpt = "">
		
		<cfif match lte 250>
			<cfset match = 1>
		</cfif>
		<cfset end = match + len(arguments.term) + 500>

		<cfif len(arguments.content) gt 500>
			<cfif match gt 1>
				<cfset excerpt = "..." & mid(arguments.content, match-250, end-match)>
			<cfelse>
				<cfset excerpt = left(arguments.content,end)>
			</cfif>
			<cfif len(arguments.content) gt end>
				<cfset excerpt = excerpt & "...">
			</cfif>
		<cfelse>
			<cfset excerpt = arguments.content>
		</cfif>	
		<!---
		We switched to regular expressions to highlight our search terms. However, it is possible for someone to search 
		for a string that isn't a valid regex. So if we fail, we just don't bother highlighting.
		--->
		<cftry>
			<cfset excerpt = reReplaceNoCase(excerpt, "(#arguments.term#)", "<span class='highlight'>\1</span>","all")>
			<cfcatch></cfcatch>
		</cftry>
		
		<cfreturn excerpt>
	</cffunction>
</cfcomponent>