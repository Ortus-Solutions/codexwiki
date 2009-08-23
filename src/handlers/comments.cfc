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
<cfcomponent extends="baseHandler"
			 output="false"
			 hint="Our wiki comments handler"
			 autowire="true">

	<!--- dependencies --->
	<cfproperty name="WikiService" 		type="ioc" scope="instance" />
	<cfproperty name="CommentsService"	type="ioc" scope="instance" />

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->


<!------------------------------------------- IMPLICIT ------------------------------------------>

	<!--- preHandler --->
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			// Check if Comments enabled?
			if( rc.codexOptions.comments_enabled EQ FALSE ){
				getPlugin("messagebox").setMessage(type="warning", message="Comments are not enabled in the wiki.");
				setNextEvent(getSetting("DefaultEvent"));
			}
			
			// Check if only registered users are allowed to comment 
			if( rc.codexOptions.comments_registration AND  NOT rc.oUser.getIsAuthorized() ){
			    getPlugin("messagebox").setMessage(type="warning", message="Only registered users can comment.");
				setNextEvent(getSetting("DefaultEvent"));
			}
			
			// Delete & Approve Permission
			if( listFindNoCase("approve,delete",event.getCurrentAction()) AND NOT rc.oUser.checkPermission("COMMENT_MODERATION") ){
				getPlugin("messagebox").setMessage(type="warning", message="You cannot delete or moderate comments.");
				setNextEvent(getSetting("DefaultEvent"));
			}
			
			event.setLayout("Layout.Ajax");
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------>
	
	<!--- newComment --->
	<cffunction name="add" access="public" returntype="void" output="false" hint="New Comment Screen">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			// Exit Handlers
			rc.xehSave = "comments.save";
			rc.xehValidate = "comments.validateCaptcha";
			
			// author data
			rc.author = "";
			rc.authorEmail = "";
			if( rc.oUser.getIsAuthorized() ){
				rc.author = rc.oUser.getFullName();
				rc.authorEmail = rc.oUser.getEmail();
			}
			
			if( rc.codexoptions.comments_moderation ){ 
				getPlugin("MessageBox").setMessage(type="warning", message="Comment moderation is enabled!");				
			}
			
			event.setView("wiki/addComments");
		</cfscript>
	</cffunction>
	
	<!--- validateCaptcha --->
    <cffunction name="validateCaptcha" access="public" returntype="void" output="false">
    	<cfargument name="Event" type="any" required="yes">
    	<cfscript>	
    		var rc = event.getCollection();
    		var results = false;
			
			if( getMyPlugin("captcha").validate(rc.captchacode) ){
				results = true;
			}
			
			event.renderData(type="json",data=results);
    	</cfscript>
    </cffunction>
	
	<!--- saveComment --->
	<cffunction name="save" access="public" returntype="void" output="false" hint="Save a comment">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>	
			var errors = arraynew(1);
			var rc = event.getCollection();
			
			// Get page
			rc.page = instance.wikiService.getPage(pageid=rc.pageid);
			
			if( NOT len(event.getTrimValue("author","")) ){
				arrayAppend(errors,"The author name was not filled out");
			}
			if( NOT len(event.getTrimValue("authorEmail","")) ){
				arrayAppend(errors,"The author email was not filled out");
			}
			if( ArrayLen(errors) ){
				getPlugin("MessageBox").setMessage(type="error",messageArray=errors);
				setNextRoute(route=getSetting('showKey') & "/" & rc.page.getName());
			}
			
			// Get New Comment To Save
			rc.oComment = instance.CommentsService.getComment();
			
			// Cleanup Comment Content
			rc.content = xmlFormat(trim(rc.content));
			
			// Populate The comment with the data.
			getPlugin("beanFactory").populateBean(rc.oComment);
			// Link it to the page.
			rc.oComment.setPage(rc.page);
			
			// Send for saving
			instance.commentsService.saveComment(rc.oComment);
			
			// Message to show.
			rc.message = "Comment added!";
			if( rc.codexoptions.comments_moderation ){
				rc.message = rc.message & " Comment moderation is enabled, so your comment will appear when it is approved.";
			}
			
			getPlugin("MessageBox").setMessage(type="info", message=rc.message);
			setNextRoute(route=getSetting('showKey') & "/" & rc.page.getName(),suffix="##pageComment_#rc.oComment.getCommentID()#");
		</cfscript>
	</cffunction>
	
	<cffunction name="approve" access="public" returntype="void" output="false">
    	<cfargument name="Event" type="any" required="yes">
    	<cfscript>	
    		var rc = event.getCollection();
			
			event.paramValue("ajax",false);
			
			// If no comment ID kick out.
			if( NOT event.valueExists("commentID") ){ setNextEvent(getSetting("DefaultEvent")); }
			
			// Get Comment
			rc.oComment = instance.commentsService.getComment(rc.commentID);
			// Aprove it
			rc.oComment.setIsApproved(true);
			instance.commentsService.save(rc.oComment);
			
			// Redirect Accordingly
			if( rc.ajax ){
				event.renderData(type="json",data=true);
			}
			else{
				getPlugin("MessageBox").setMessage(type="info", message="Comment approved successfully!");
				setNextRoute(route=getSetting('showKey') & "/" & rc.oComment.getPage().getName(),suffix="##pageComment_#rc.oComment.getCommentID()#");
			}
    	</cfscript>
    </cffunction>
	
	<cffunction name="delete" access="public" returntype="void" output="false">
    	<cfargument name="Event" type="any" required="yes">
    	<cfscript>	
    		var rc = event.getCollection();
			
			event.paramValue("ajax",false);
			
			// If no comment ID kick out.
			if( NOT event.valueExists("commentID") ){ setNextEvent(getSetting("DefaultEvent")); }
			
			// Get Comment to Delete
			rc.oComment = instance.CommentsService.getComment(rc.commentID);
			
			// Ajax or not?
			if( NOT rc.ajax ){
				// Save page to redirect to with message:
				rc.pageName = rc.oComment.getPage().getName();
			}
			
			// remove Comment.
			instance.commentsService.delete(rc.oComment);
			
			// Redirect Accordingly
			if( rc.ajax ){
				event.renderData(type="json",data=true);
			}
			else{
				getPlugin("MessageBox").setMessage(type="info", message="Comment deleted successfully!");
				setNextRoute(route=getSetting('showKey') & "/" & rc.pageName);
			}
    	</cfscript>
    </cffunction>

</cfcomponent>