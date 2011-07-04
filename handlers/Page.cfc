/**
********************************************************************************
* Copyright Since 2011 CodexPlatform
* www.codexplatform.com | www.coldbox.org | www.ortussolutions.com
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
*********************************************************************************/
component extends="BaseHandler" singleton{

	// Dependencies
	property name="WikiService" 	inject;
	property name="CommentsService"	inject;
	property name="SearchEngine" 	inject;
	property name="SecurityService" inject;
	property name="showKey"			inject="coldbox:setting:showKey";

	// Implicit Properties
	this.prehandler_only = "show";

/************************************** ONDICOMPLETE *********************************************/

	function onDIComplete(){
		showKey &= "/";
	}

/************************************** IMPLICIT EVENTS *********************************************/
	
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
		
		//default page comes from the settings
		event.paramValue("page", rc.CodexOptions.wiki_defaultpage );
		// Get Content For Page To Try To Display
		rc.content = wikiService.getContent(pageName=rc.page);
		// Page Security Handling
		if( rc.content.getPage().isProtected() AND NOT securityService.isPageViewable(rc.content.getPage()) ){
			event.overrideEvent('page.protected');
		}
		// Printable Doctype Check
		isPrintFormat(arguments.event,rc);
	}
	
/************************************** PUBLIC EVENTS *********************************************/
	
	/**
	* Show wiki pages
	*/
	function show(event,rc,prc){

		// Exit Handlers
		rc.onEditWiki		="page/edit";
		rc.onCreateWiki		="page/new";
		rc.onDeleteWiki		="page/delete";
		rc.onShowHistory	="page/showHistory";
		rc.xehComments 		= "comments.add";
		rc.xehCommentRemove = "comments.delete";
		rc.xehCommentStatus = "comments.approve";

		// Custom CSS & JS
		rc.jsAppendList = "simplemodal.helper,jquery.simplemodal,confirm,formvalidation";
		
		// Decode Page
		rc.urlPage = URLEncodedFormat(rc.page);
		
		// Get Comments if activated
		if( rc.codexoptions.comments_enabled ){
			rc.qComments = commentsService.getPageComments(pageID=rc.content.getPage().getPageID(),moderation=rc.oUser.checkPermission("COMMENT_MODERATION"));
		}
		
		// Change view if persisted
		if( rc.content.getIsPersisted() ){
			// Normal Display
			arguments.event.setView("wiki/show");
		}
		else{
			// Just creation page by default
			rc.onCreateWiki="page/create";
			arguments.event.setView("wiki/create");
		}
	}
	
	/**
	* Protected pages
	*/
	function protected(event,rc,prc){	
		// JS
		rc.jsAppendList = "formvalidation";
		// Exit Handler
		rc.xehPasswordCheck = "page/passwordCheck";
		// View
		arguments.event.setView("wiki/protected");
	}
	
	/**
	* Page Password checks
	*/
	function passwordCheck(event,rc,prc){
		// Get The Page submitted
		var page = wikiService.getPage(pageID=event.getValue("pageID",""));
		
		// Check page exists 
		if( page.getIsPersisted() ){
			// Check if password is valid?
			if( NOT securityService.authorizePage(page, event.getTrimValue("PagePassword","")) ){
				// Invalid Message
				getPlugin("MessageBox").setMessage(type="warning", message="The password you entered is incorrect.");				
			}
			
			// Take to Page
			setNextEvent(showKey & page.getName());
		}
		else{
			// Message and take home
			getPlugin("MessageBox").setMessage(type="error", message="Page not found in our system");
			setNextEvent(showKey);
		}			
	}
	
	/**
	* New pages
	*/
	function new(event,rc,prc){
    	// exit handlers
    	rc.xehCreate = "page.create";
		
		// check if I can create pages
		if( NOT rc.oUser.checkPermission("WIKI_CREATE") ){
			getPlugin("MessageBox").setMessage(type="warning", message="You do not have permission to create new pages");
			setNextEvent(showKey);
			return;
		}
		
		// Get namespaces
		rc.qNameSpaces = wikiService.getNamespaces();
		// new page
		event.setView("wiki/new");
	}

	/**
	* Page Creation Editor
	*/
	function create(event,rc,prc){
		// Dispatch manage
		manage(arguments.event,arguments.rc,arguments.prc);
	}
	
	/**
	* Create a new page
	*/
	function doCreate(event,rc,prc){
		// Dispatch manage
		process(arguments.event,arguments.rc,arguments.prc);
	}

	/**
	* Edit a page
	*/
	function edit(event,rc,prc){
		// Dispatch manage
		manage(arguments.event,arguments.rc,arguments.prc);
	}

	/**
	* Save an edited page
	*/
	function doEdit(event,rc,prc){
		// Dispatch manage
		process(arguments.event,arguments.rc,arguments.prc);
	}

	/**
	* Render Content on history or other previews by content ID
	*/
	function renderContent(event,rc,prc){
		var content = wikiService.getContent( arguments.event.getValue('contentid',0) );
		// Render out content
		event.renderData(type='HTML',data=content.render());
	}
	
	/**
	* Render Content on history or other previews by Page Name
	*/
	function renderPage(event,rc,prc){
		var content = wikiService.getContent(pageName=event.getValue("page",""));
		// Render out content
		event.renderData(type='HTML',data=content.render());
	}
	
	/**
	* Render wiki markup previews
	*/
	function renderPreview(event,rc,prc){
	    // get new cotent object
	    var oContent 	= wikiService.getContent();
		var tmpContent 	= 0;
		
		if( event.valueExists("pagename") )
		{
			// Get and set it for preview rendering.
			oContent.setPage( wikiService.getPage(pageName=rc.pageName) );
			// Put User also
			tmpContent = wikiService.getContent(pageName=rc.pageName);
			// may not be persisted, so do a check for a user, if it exists
			if( tmpContent.hasUser() ){
				oContent.setUser( tmpContent.getUser() );
			}
		}
		
		// Get Content from incoming form
		oContent.populate( rc );
		// Render the content
		event.renderData(data=oContent.render(),type="HTML");
	}

	/**
	* Show page history
	*/
	function showHistory(event,rc,prc){
		var pageName = arguments.event.getValue("page");

		// Get the Page
		rc.page = wikiService.getPage(pageName=pageName);
		// Get the History
		rc.history = wikiService.getPageHistory( pageName );

		// custom css js
		rc.cssAppendList = "page.showHistory";
		rc.jsAppendList = "jquery.simplemodal,confirm";

		// Exit Handlers
		rc.onReplaceActive 	= "page/replaceActive";
		rc.onDelete 		= "page/deleteContent";
		rc.onPreview 		= "page/renderContent";
		rc.onDiff 			= "page/diff";

		// view
		arguments.event.setView("wiki/showHistory");
	}

	/**
	* History Diffs
	*/
	function diff(event,rc,prc){
	   	var pageName = arguments.event.getValue("page");
		var oDiffer = getMyPlugin("Diff");

		/* Validate Versions */
		if( not event.valueExists("version") OR not event.valueExists("old_version") ){
			getPlugin("MessageBox").setMessage(type="warning", message="No version information passed in.");
			setNextEvent('page/showHistory/#rc.page#');
		}

		/* CSS & JS */
		rc.cssAppendList = "page.showHistory";
		rc.jsAppendList = "jquery.simplemodal,confirm";

		/* Exit Handler */
		rc.onShowHistory = "page/showHistory";

		/* Get the Page content */
		rc.page = wikiService.getPage(pageName=pageName);
		rc.CurrentContent = wikiService.getContentByPageVersion(pageName=pagename,version=rc.version);
		rc.oldContent = wikiService.getContentByPageVersion(pageName=pagename,version=rc.old_version);

		/* Diff Setup */
		rc.diff = oDiffer.DiffArrays(listToArray(rc.oldContent.getContent(),chr(10)), listToArray(rc.CurrentContent.getContent(),chr(10)));
		rc.parallel = oDiffer.parallelize(rc.diff,listToArray(rc.oldContent.getContent(),chr(10)), listToArray(rc.CurrentContent.getContent(),chr(10)));
		
		/* Diff CSS */
		rc.diffcss = structnew();
		rc.diffcss["+"] = "ins";
		rc.diffcss["-"] = "del";
		rc.diffcss["!"] = "upd";
		rc.diffcss[""] = "";

		/* View */
		event.setView("wiki/showDiff");
	}

	/**
	* Delete page content
	*/
	function deleteContent(event,rc,prc){
		var content = wikiService.getContent(arguments.event.getValue("contentid"));
		var page 	= content.getPage();

		wikiService.deleteContent(content);

		setNextEvent("page/showHistory/" & page.getName());
	}

	/**
	* Replace the active page
	*/
	function replaceActive(event,rc,prc){
		var content = wikiService.getContent(arguments.event.getValue("contentid"));
		var page = content.getPage();

		content.replaceActive();

		setNextEvent("page/showHistory/" & page.getName());
	}

	/**
	* Delete the entire page
	*/
	function delete(event,rc,prc){
		//s'not really a content id, it's a page id
		var pageid = arguments.event.getValue("contentid");
		var page = wikiService.getPage(pageid);

		wikiService.deletePage(pageid);

		setNextEvent(event=showKey & page.getName(), persist="page");
	}

	/**
	* search content
	*/
	function search(event,rc,prc){
		var search_query = arguments.event.getValue("search_query", "");
		var result = searchEngine.search(search_query);

		/* Messagebox when search is not available */
		if ( StructKeyExists(result, "error") ){
			getPlugin("MessageBox").setMessage("error", result.error );
		}
		else{
			/* Render Results */
			rc.searchResults = searchEngine.renderSearch(result,arguments.event,getController());
		}
		/* Set View to render */
		arguments.event.setView("wiki/search");
	}

	/**
	* Space page directory
	*/
	function directory(event,rc,prc){
		var ids = "";
		var qDefault = 0;

		/* Required */
		rc.jsAppendList = 'jquery.uitablefilter';
		
		/* Get All Pages */
		rc.qPages = wikiService.getPages();
		/* Get All Namespaces */
		rc.qNameSpaces = wikiService.getNamespaces();
		/* Filter the default Namespace */
		qDefault = getPlugin("queryHelper").filterQuery(qry=rc.qPages,field="isDefault",value=1,cfsqltype="cf_sql_integer");

		/* Filter */
		ids = event.getValue("namespaces",qDefault.namespace_id);
		if( right(ids,1) eq "," ){
			ids = left(ids, len(ids)-1 );
		}
		rc.qPages = getPlugin("queryHelper").filterQuery(qry=rc.qPages,field="namespace_id",value=ids,list=true);

		/* View */
		if( event.valueExists('pagesTable') ){

			/* View */
			event.setView('wiki/directoryPagesTable',true);
		}
		else{
			event.setView('wiki/directory');
		}
	}

/************************************** PRIVATE *********************************************/

	/**
	* process saving
	*/
	private function process(event,rc,prc){
		var messages = 0;
		var oContent = 0;
		var activeContent = 0;
		var x =1;
		var thisCategory = 0;
		
		/* Param Values */
		event.paramValue("isReadOnly",false);
		event.paramValue("RenamePageName","");
		
		/* Get the page we are working with */
		rc.page = wikiService.getPage(pageName=rc.pageName);
		/* Get new Content object */
		oContent = rc.page.getNewContentVersion(rc);
		/* Get the currently active Content if any*/
		oActiveContent = wikiService.getContent(pageName=rc.pageName);
		
		/* Validate Content */
		messages = oContent.validate(isCommentsMandatory=rc.CodexOptions.wiki_comments_mandatory);
		if(ArrayLen(messages)){
			/* MB & content set */
			getPlugin("MessageBox").setMessage(type="warning", messageArray=messages);
			rc.content = oContent;
			/* Save Version for non dirty edits */
			rc.content.setVersion(oActiveContent.getVersion());
			/* ReRoute with persistence */
			setNextEvent(event="page/edit/" & rc.pageName, persist="content");
		}
		
		
		/* Check for Version Modifications just before saving */
		if( oActiveContent.getVersion() neq rc.pageVersion ){
			getPlugin("MessageBox").setMessage(type="warning", message="Page was not saved as you where editing an old version of the page. Displaying current version");
			/* ReRoute */
			setNextEvent(showKey & rc.pageName);
		}
		
		/* Populate content with Categories from select */
		if( len(event.getTrimValue("contentCategories","")) ){
			oContent.clearCategory();
			for(x=1; x lte listLen(rc.contentCategories); x=x+1){
				thisCategory = wikiService.getCategory(categoryID=listGetAt(rc.contentCategories,x));
				oContent.addCategory(thisCategory);
			}
		}
		
		/* Save New Content to page */
		rc.page.addContentVersion(oContent);
		
		/* Check for Page Renaming */
		if( rc.page.getIsPersisted() and len(event.getTrimValue("renamePageName","")) ){
			rc.page.setName(rc.RenamePageName);
			rc.pageName = rc.RenamePageName;
		}
		
		/* Set Page Extra Properties */
		rc.page.setTitle(event.getTrimValue("title"));
		rc.page.setPassword(event.getTrimValue("PagePassword"));
		rc.page.setDescription(event.getTrimValue("Description"));
		rc.page.setKeywords(event.getTrimValue("Keywords"));
		rc.page.setAllowComments(event.getValue("allowComments","false"));
		
		/* Save this Page */
		wikiService.savePage(rc.page);
		
		/* Re Route */
		setNextEvent(event=showKey & rc.pageName,persist="page");
	}

	/**
	* Manage create/editor
	*/
	private function manage(event,rc,prc){
		var content = 0;

		/* Custom JS */
		rc.jsAppendList = "simplemodal.helper,jquery.simplemodal,jquery.textarearesizer.compressed,markitup/jquery.markitup.pack,markitup/sets/wiki/set";
		/* Markitup Editor */
		rc.cssFullAppendList = "includes/scripts/markitup/skins/markitup/style,includes/scripts/markitup/sets/wiki/style";

		/* if no content, get for management */
		if( not arguments.event.valueExists("content") ){
			rc.content = wikiService.getContent(pageName=rc.page);
		}

		/* Check Persistence and set Exit Handlers */
		if( rc.content.getPage().getIsPersisted() ) {
			rc.onSubmit = "page/doEdit";
		}
		else{
			rc.onSubmit = "page/doCreate";
		}
		rc.onPreview = "page/renderPreview";
		rc.onPageRender = "page/renderPage";
		rc.onCancel = "wiki";
		rc.onCheatSheet = "Help:Cheatsheet";
		
		/* Categories */
		rc.qCategories = wikiService.listCategories();

		/* View */
		arguments.event.setView("wiki/manage");
	}
	
	/**
	* Checks if pages need printing layouts
	*/
	private function isPrintFormat(event,rc){
		// Regex of valid print options
		if( NOT reFindNoCase("^(pdf|HTML|markup|word)$",event.getValue("print","")) ){
			return;
		}
		
		// Print Layout Selection
		event.setLayout("Layout.Print");
		
		// Print Options
		switch(rc.print){
			case "pdf"			:{ rc.layout_extension = "pdf"; break; }
			case "markup"		:{ event.setLayout("Layout.MarkupExport"); break; }
			case "word"			:{ event.setLayout("Layout.word"); break; }
			default 			:{ event.setLayout("Layout.html"); }
		}
	}
	
}