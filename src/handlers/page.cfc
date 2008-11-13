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

	<!--- dependencies --->
	<cfproperty name="WikiService" type="ioc" scope="instance" />

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="init" access="public" returntype="page" output="false">
		<cfargument name="controller" type="any" required="yes">
		<cfscript>
			super.init(arguments.controller);
			/* Show Key */
			instance.showKey = getSetting('showKey') & "/";
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="show" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = arguments.event.getCollection();
			
			/* Exit Handlers */
			rc.onEditWiki="page/edit";
			rc.onCreateWiki="page/create";
			rc.onDeleteWiki="page/delete";
			rc.onShowHistory="page/showHistory";
			
			//default page comes from the settings
			arguments.event.paramValue("page", getSetting('DefaultPage') );
			
			/* Appends CSS & JS */
			rc.cssAppendList = "wiki.show";
			rc.jsAppendList = "jquery.simplemodal-1.1.1.pack,confirm";
			
			/* Get Content For Page */
			rc.content = getWikiService().getContent(pageName=rc.page);
			
			/* Page */
			rc.urlPage = URLEncodedFormat(rc.page);
			
			/* Set views according to persistance */
			if(rc.content.getIsPersisted())
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
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			manage(arguments.event);
		</cfscript>
	</cffunction>
	
	<cffunction name="doCreate" access="public" returntype="void" output="false" hint="Create a new page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			process(arguments.event);
		</cfscript>
	</cffunction>
	
	<cffunction name="edit" access="public" returntype="void" output="false" hint="Show the edit page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			manage(arguments.event);
		</cfscript>
	</cffunction>
	
	<cffunction name="doEdit" access="public" returntype="void" output="false" hint="Update a page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			process(arguments.event);
		</cfscript>
	</cffunction>
	
	<cffunction name="renderContent" access="public" returntype="void" output="false" hint="Render Content">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var content = getWikiService().getContent(arguments.event.getValue('contentid',0));
			/* Render Data */
			event.renderData(type='PLAIN', data=content.render(),contentTYpe='text/html');
		</cfscript>
	</cffunction>	
	
	<cffunction name="renderPreview" access="public" returntype="void" output="false" hint="Render Content Previews">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var oContent = getWikiService().getContent();
			/* Get Content */
			oContent.populate(arguments.event.getCollection());
			/* Render Data */
			event.renderData(type='PLAIN', data=oContent.render(),contentTYpe='text/html');
		</cfscript>
	</cffunction>
	
	<cffunction name="showHistory" hint="shows a page's history" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var pageName = arguments.event.getValue("page");
			
			/* Get the Page */
			rc.page = getWikiService().getPage(pageName=pageName);
			/* Get the History */
			rc.History = getWikiService().getPageHistory(pageName);
	
			/* CSS & JS */
			rc.cssAppendList = "page.showHistory";
			rc.jsAppendList = "jquery.simplemodal-1.1.1.pack,confirm";
			
			/* Exit Handlers */
			rc.onReplaceActive ="page/replaceActive";
			rc.onDelete ="page/deleteContent";
			rc.onPreview = "page/renderContent";
			
			/* View */
			arguments.event.setView("wiki/showHistory");
		</cfscript>
	</cffunction>
	
	<cffunction name="deleteContent" hint="delete's a content object" access="public" returntype="string" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var content = getWikiService().getContent(arguments.event.getValue("contentid"));
			var page = content.getPage();
	
			getWikiService().deleteContent(content);
	
			setNextRoute(route="page/showHistory/" & page.getName());
		</cfscript>
	</cffunction>
	
	<cffunction name="replaceActive" hint="delete's a content object" access="public" returntype="string" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var content = getWikiService().getContent(arguments.event.getValue("contentid"));
			var page = content.getPage();
	
			content.replaceActive();
	
			setNextRoute(route="page/showHistory/" & page.getName());
		</cfscript>
	</cffunction>
	
	<cffunction name="delete" hint="delete a wiki page" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			//s'not really a content id, it's a page id
			var pageid = arguments.event.getValue("contentid");
			var page = getWikiService().getPage(pageid);
	
			getWikiService().deletePage(pageid);
	
			setNextRoute(route=instance.showKey & page.getName(), persist="page");
		</cfscript>
	</cffunction>
	
	<cffunction name="search" hint="searchs active pages" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
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
	
	<cffunction name="process" hint="processes the wiki details as a save or update" access="private" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var messages = 0;
			var oContent = 0;
			
			/* Get Page */
			rc.page = getWikiService().getPage(pageName=rc.pageName);
			/* Get Content */
			oContent = rc.page.getNewContentVersion(rc);
			/* Validate Content */
			messages = oContent.validate();
			if(ArrayLen(messages))
			{
				/* MB & content set */
				getPlugin("messagebox").setMessage(type="warning", messageArray=messages);
				rc.content = oContent;
				/* ReRoute with persistence */
				setNextRoute(route="page/edit/" & rc.pageName, persist="content");
			}
			else
			{
				rc.page.addContentVersion(oContent);
				setNextRoute(route=instance.showKey & rc.pageName, persist="page");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="manage" hint="manage a wiki page" access="private" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = arguments.event.getCollection();
			var content = 0;
			
			/* Custom JS */
			rc.jsAppendList = "jquery.simplemodal-1.1.1.pack,jquery.textarearesizer.compressed,markitup/jquery.markitup.pack,markitup/sets/wiki/set";
			/* Markitup Editor */
			rc.cssFullAppendList = "includes/scripts/markitup/skins/markitup/style,includes/scripts/markitup/sets/wiki/style";
			
			/* if no content, get for management */
			if( not arguments.event.valueExists("content") ){
				rc.content = getWikiService().getContent(pageName=rc.page);
			}
			
			/* Check Persistence and set Exit Handlers */
			if( rc.content.getPage().getIsPersisted() ) {
				rc.onSubmit = "page/doEdit";
			}
			else{
				rc.onSubmit = "page/doCreate";
			}
			rc.onPreview = "page/renderPreview";
			rc.onCancel = "wiki";
	
			/* View */
			arguments.event.setView("wiki/manage");
		</cfscript>
	</cffunction>
	
	<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
		<cfreturn instance.wikiService />
	</cffunction>
</cfcomponent>