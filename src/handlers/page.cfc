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
<cfcomponent name="page"
			 extends="baseHandler"
			 output="false"
			 hint="This is our main page handler"
			 autowire="true"
			 cache="true" cacheTimeout="0">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" access="public" returntype="page" output="false">
	<cfargument name="controller" type="any" required="yes">
	<cfscript>
		super.init(arguments.controller);

		return this;
	</cfscript>
</cffunction>

<cffunction name="show" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = 0;

		//default page is the dashboard
		arguments.event.paramValue("page", getSetting('DefaultPage') );

		arguments.event.setValue("cssAppendList", "uni-form,wiki.show");
		arguments.event.setValue("jsAppendList", "jquery.simplemodal-1.1.1.pack,confirm");

		content = getWikiService().getContent(pageName=arguments.event.getValue("page"));
		arguments.event.setValue("content", content);
		arguments.event.setValue("onEditWiki","page/edit");
		arguments.event.setValue("onCreateWiki","page/create");
		arguments.event.setValue("onDeleteWiki","page/delete");
		arguments.event.setValue("onShowHistory","page/showHistory");

		/* Set views according to persistance */
		if(content.getIsPersisted())
		{
			arguments.event.setView("wiki/show");
		}
		else
		{
			arguments.event.setView("wiki/create");
		}
	</cfscript>
</cffunction>

<cffunction name="create" access="public" returntype="void" output="false" hint="Show the Create a new page">
	<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
    <cfscript>
		/* Dispatch manage */
		manage(arguments.event);
	</cfscript>
</cffunction>

<cffunction name="doCreate" access="public" returntype="void" output="false" hint="Create a new page">
	<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
    <cfscript>
		/* Dispatch manage */
		process(arguments.event);
	</cfscript>
</cffunction>

<cffunction name="edit" access="public" returntype="void" output="false" hint="Show the edit page">
	<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
    <cfscript>
		/* Dispatch manage */
		manage(arguments.event);
	</cfscript>
</cffunction>

<cffunction name="doEdit" access="public" returntype="void" output="false" hint="Update a page">
	<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
    <cfscript>
		/* Dispatch manage */
		process(arguments.event);
	</cfscript>
</cffunction>

<cffunction name="showHistory" hint="shows a page's history" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var pageName = arguments.event.getValue("page");
		var page = getWikiService().getPage(pageName=pageName);
		var qHistory = getWikiService().getPageHistory(pageName);

		arguments.event.setValue("cssAppendList", "page.showHistory");
		arguments.event.setValue("jsAppendList", "jquery.simplemodal-1.1.1.pack,confirm");

		arguments.event.setValue("onReplaceActive", "page/replaceActive");
		arguments.event.setValue("onDelete", "page/deleteContent");
		arguments.event.setValue("page", page);

		arguments.event.setValue("history", qHistory);

		arguments.event.setView("wiki/showHistory");
	</cfscript>
</cffunction>

<cffunction name="deleteContent" hint="delete's a content object" access="public" returntype="string" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = getWikiService().getContent(arguments.event.getValue("contentid"));
		var page = content.getPage();

		getWikiService().deleteContent(content);

		setNextRoute(route="page/showHistory/" & page.getName());
	</cfscript>
</cffunction>

<cffunction name="replaceActive" hint="delete's a content object" access="public" returntype="string" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = getWikiService().getContent(arguments.event.getValue("contentid"));
		var page = content.getPage();

		content.replaceActive();

		setNextRoute(route="page/showHistory/" & page.getName());
	</cfscript>
</cffunction>

<cffunction name="delete" hint="delete a wiki page" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		//s'not really a content id, it's a page id
		var pageid = arguments.event.getValue("contentid");
		var page = getWikiService().getPage(pageid);

		getWikiService().deletePage(pageid);

		setNextRoute(route="wiki/" & page.getName(), persist="page");
	</cfscript>
</cffunction>

<cffunction name="search" hint="searchs active pages" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var search_query = arguments.event.getValue("search_query", "");
		var result = getWikiService().searchWiki(search_query);

		arguments.event.setValue("result", result);

		/* Messagebox when search is not available */
		if ( StructKeyExists(arguments.event.getValue("result"), "error") ){
			getPlugin("messagebox").setMessage("warning", arguments.event.getValue("result").error );
		}

		arguments.event.setView("wiki/search");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="process" hint="processes the wiki details" access="private" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var pageName = arguments.event.getValue("pageName");
		var page = getWikiService().getPage(pageName=pageName);
		var content = page.getNewContentVersion(arguments.event.getCollection());
		var messages = 0;

		messages = content.validate();

		if(ArrayLen(messages))
		{
			getPlugin("messagebox").setMessage(type="error", messageArray=messages);

			arguments.event.setValue("content", content);

			setNextRoute(route="page/edit/" & pageName, persist="content");
		}
		else
		{
			page.addContentVersion(content);
			setNextRoute(route="wiki/" & pageName, persist="page");
		}
	</cfscript>
</cffunction>

<cffunction name="manage" hint="manage a wiki page" access="private" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var rc = arguments.event.getCollection();
		var content = 0;

		if(arguments.event.valueExists("content"))
		{
			content = arguments.event.getValue("content");
		}
		else
		{
			content = getWikiService().getContent(pageName=arguments.event.getValue("page"));
			arguments.event.setValue("content", content);
		}

		arguments.event.setValue("cssAppendList", "");
		arguments.event.setValue("jsAppendList", "jquery.simplemodal-1.1.1.pack,jquery.textarearesizer.compressed");

		if( content.getPage().getIsPersisted() ) {
			arguments.event.setValue("onSubmit","page/doEdit");
		}
		else{
			arguments.event.setValue("onSubmit","page/doCreate");
		}

		arguments.event.setValue("onCancel","wiki");

		arguments.event.setView("wiki/manage");
	</cfscript>
</cffunction>

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>
<cffunction name="setWikiService" access="private" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>
</cfcomponent>