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
<cfcomponent extends="transfer.com.TransferDecorator" hint="A category for a wiki page" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="createCategoryPage" hint="creates the category special page, if it doesn't exist" access="public" returntype="void" output="false">
	<cfscript>
		var content = getWikiService().getContent(pageName="Category:#getName()#");
		var wikiText = 0;
	</cfscript>

	<cfif NOT content.getIsPersisted()>
		<cfsavecontent variable="wikiText">
		<cfoutput>
== Category: #getName()# ==

All pages under the Category ''#getName()#'':<br/>
<feed url="/feed/page/listByCategory#getConfigService().getRewriteExtension()#?category=#getName()#" display="numbered" />
		</cfoutput>
		</cfsavecontent>
		<cfscript>
			content.setContent(wikiText);
			content.setIsActive(true);
			getWikiService().saveContent(content);
		</cfscript>
	</cfif>
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!--- setConfigService --->
<cffunction name="setConfigService" output="false" access="public" returntype="void" hint="">
	<cfargument name="configService" type="codex.model.wiki.ConfigService" required="true">
	<cfset instance.configService = arguments.configService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

<cffunction name="getconfigService" access="public" returntype="codex.model.wiki.ConfigService" output="false">
	<cfreturn instance.configService>
</cffunction>

</cfcomponent>