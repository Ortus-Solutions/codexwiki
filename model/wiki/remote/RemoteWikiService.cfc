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
<cfcomponent hint="Remote access to wiki services" extends="codex.model.remote.AbstractRemoteFacade" output="false">
<cfsetting showdebugoutput="false">
<cfscript>
	setWikiService(getBean("WikiService"));
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getContentHTML" hint="returns a specific content html" access="remote" returntype="string" output="false" returnFormat="plain">
	<cfargument name="contentid" hint="the id of the content item to displlay" type="string" required="Yes">
	<cfscript>
		var content = getWikiService().getContent(arguments.contentid);
		return content.render();
	</cfscript>
</cffunction>

<cffunction name="getPreviewHTML" hint="the previous html" access="remote" returntype="string" output="false" returnFormat="plain">
	<cfargument name="content" hint="the contenxt text" type="string" required="Yes">
	<cfscript>
		var oContent = getWikiService().getContent();
		oContent.populate(arguments);

		return oContent.render();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

<cffunction name="setWikiService" access="private" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

</cfcomponent>