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
<cfcomponent extends="transfer.com.TransferDecorator" hint="An actual wiki page" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setName" hint="stes the page name, and sets the namespace as required" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the name of the page" type="string" required="Yes">
	<cfscript>
		var nameSpace = 0;

		getTransferObject().setName(arguments.name);

		if(ListLen(arguments.name, ":") gte 2)
		{
			nameSpace = getWikiService().getNamespace(namespaceName=ListGetAt(arguments.name, 1, ":"));
		}
		else
		{
			nameSpace = getWikiService().getDefaultNameSpace();
		}

		setNamespace(namespace);
	</cfscript>
</cffunction>

<cffunction name="getCleanName" hint="name without the '_' in it" access="public" returntype="string" output="false">
	<cfreturn replaceNoCase(getName(), "_", " ", "all") />
</cffunction>

<cffunction name="getNewContentVersion" hint="validates a content version" access="public" returntype="codex.model.wiki.Content" output="false">
	<cfargument name="memento" hint="the memento to populate the new content object" type="struct" required="Yes">
	<cfscript>
		var content = getWikiService().getContent();
			
		content.setPage(this);
		content.populate(arguments.memento);
		
		return content;
	</cfscript>
</cffunction>

<cffunction name="addContentVersion" hint="adds a content version" access="public" returntype="void" output="false">
	<cfargument name="content" hint="the content to add as a new version" type="codex.model.wiki.Content" required="Yes">
	<cfscript>
		getWikiService().saveContentVersion(arguments.content);
	</cfscript>
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

</cfcomponent>