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
component extends="BaseHandler"{

	// Dependencies
	property name="wikiService" 	inject;
	property name="commentsService"	inject;
	property name="showKey"			inject="coldbox:setting:showKey";

/************************************** IMPLICIT *********************************************/

	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
		// Check if Comments enabled?
		if( rc.codexOptions.comments_enabled EQ FALSE ){
			getPlugin("MessageBox").warn("Comments are not enabled in the wiki.");
			setNextEvent(getSetting("DefaultEvent"));
		}
		
		// Check if only registered users are allowed to comment 
		if( rc.codexOptions.comments_registration AND  NOT rc.oUser.getIsAuthorized() ){
		    getPlugin("MessageBox").warn("Only registered users can comment.");
			setNextEvent(getSetting("DefaultEvent"));
		}
		
		// Delete & Approve Permission
		if( listFindNoCase("approve,delete",event.getCurrentAction()) AND NOT rc.oUser.checkPermission("COMMENT_MODERATION") ){
			getPlugin("MessageBox").warn("You cannot delete or moderate comments.");
			setNextEvent(getSetting("DefaultEvent"));
		}
		
		event.setLayout("Layout.Ajax");
	}

/************************************** PUBLIC *********************************************/	
	
	function add(event,rc,prc){
		// Exit Handlers
		rc.xehSave 		= "comments.save";
		rc.xehValidate 	= "comments.validateCaptcha";
		
		// author data
		rc.author = "";
		rc.authorEmail = "";
		if( rc.oUser.getIsAuthorized() ){
			rc.author = rc.oUser.getFullName();
			rc.authorEmail = rc.oUser.getEmail();
		}
		// Comment moderation
		if( rc.codexoptions.comments_moderation ){ 
			getPlugin("MessageBox").setMessage(type="warning", message="Comment moderation is enabled!");				
		}
		
		event.setView("comments/add");
	}
	
	function validateCaptcha(event,rc,prc){
		var results = false;
		
		if( getMyPlugin("Captcha").validate(rc.captchacode) ){
			results = true;
		}
		
		event.renderData(type="json",data=results);
    }
	
	function save(event,rc,prc){	
		var errors = arraynew(1);
		
		// Get page
		rc.page = wikiService.getPage(pageid=rc.pageid);
		
		// validate incoming data
		if( NOT len(event.getTrimValue("author","")) ){
			arrayAppend(errors,"The author name was not filled out");
		}
		if( NOT len(event.getTrimValue("authorEmail","")) ){
			arrayAppend(errors,"The author email was not filled out");
		}
		if( ArrayLen(errors) ){
			getPlugin("MessageBox").setMessage(type="error",messageArray=errors);
			setNextEvent(showKey & "/" & rc.page.getName());
		}
		
		// Cleanup Comment Content
		rc.content = xmlFormat( trim(rc.content) );
		
		// Get New Comment To Save
		rc.oComment = populateModel( commentsService.getComment() );
		
		// Link it to the page.
		rc.oComment.setPage( rc.page );
		
		// Send for saving
		commentsService.saveComment( rc.oComment );
		
		// Message to show.
		rc.message = "Comment added!";
		if( rc.codexoptions.comments_moderation ){
			rc.message = rc.message & " Comment moderation is enabled, so your comment will appear when it is approved.";
		}
		
		getPlugin("MessageBox").info(message=rc.message);
		setNextEvent(event=showKey & "/" & rc.page.getName(),suffix="##pageComment_#rc.oComment.getCommentID()#");
	}
	
	function approve(event,rc,prc){
		
		event.paramValue("ajax",false);
		
		// If no comment ID kick out.
		if( NOT event.valueExists("commentID") ){ setNextEvent(getSetting("DefaultEvent")); }
		
		// Get Comment
		rc.oComment = commentsService.getComment( rc.commentID );
		// Aprove it
		rc.oComment.setIsApproved( true );
		commentsService.save( rc.oComment );
		
		// Redirect Accordingly
		if( rc.ajax ){
			event.renderData(type="json",data=true);
		}
		else{
			getPlugin("MessageBox").info(message="Comment approved successfully!");
			setNextEvent(event=showKey & "/" & rc.oComment.getPage().getName(),suffix="##pageComment_#rc.oComment.getCommentID()#");
		}
    }
	
	function delete(event,rc,prc){	
		
		event.paramValue("ajax",false);
		
		// If no comment ID kick out.
		if( NOT event.valueExists("commentID") ){ setNextEvent(getSetting("DefaultEvent")); }
		
		// Get Comment to Delete
		rc.oComment = commentsService.getComment( rc.commentID );
		
		// Ajax or not?
		if( NOT rc.ajax ){
			// Save page to redirect to with message:
			rc.pageName = rc.oComment.getPage().getName();
		}
		
		// remove Comment.
		commentsService.delete( rc.oComment );
		
		// Redirect Accordingly
		if( rc.ajax ){
			event.renderData(type="json",data=true);
		}
		else{
			getPlugin("MessageBox").info(message="Comment deleted successfully!");
			setNextEvent(event=showKey & "/" & rc.pageName);
		}
	}

}