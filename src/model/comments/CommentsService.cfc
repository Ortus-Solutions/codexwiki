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
<cfcomponent hint="The Wiki Commenting layer" output="false" extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CommentsService" output="false">
	<cfargument name="transfer" 		hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="transaction" 		hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
	<cfargument name="datasource" 		hint="the datasource bean" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfargument name="wikiService" 		hint="the wiki service" type="codex.model.wiki.WikiService" required="Yes">
	<cfargument name="securityService" 	hint="the security service" type="codex.model.security.SecurityService" required="Yes">
	<cfscript>
		super.init(argumentCollection=arguments);
		
		// Dependencies
		setWikiService(arguments.wikiService);
		setConfigService(arguments.configService);
		setSecurityService(arguments.securityService);
		
		instance.codexOptions = getConfigService().getOptions();
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getComment" hint="returns a comment Object" access="public" returntype="codex.model.comments.Comment" output="false">
	<cfargument name="commentID" hint="the specific comment id" type="string" required="no">
	<cfscript>
		var comment = 0;
		// retrieve by id
		if(StructKeyExists(arguments, "commentID") AND len(arguments.commentID))
		{
			return getTransfer().get("wiki.Comment", arguments.commentID);
		}
		
		return getTransfer().new("wiki.Comment");
	</cfscript>
</cffunction>

<cffunction name="saveComment" access="public" returntype="void" hint="Save Comments" output="false" >
	<cfargument name="comment" type="codex.model.comments.Comment" required="true" default="" hint="The comment"/>
	<cfscript>
		var oUser = getSecurityService().getUserSession();
		var content = arguments.comment.getContent();
		
		// Log the IP Address
		arguments.comment.setAuthorIP(cgi.remote_addr);
		
		// Link Comment To User if not anonymous user
		if( oUser.getIsAuthorized() ){
			arguments.comment.setUser(oUser);
		}
		
		// Check if activating URL's on Comment Content
		if( instance.codexOptions.comments_urltranslations ){
			arguments.comment.setContent( getUtil().activateURL(content) );
		}
		
		// Are we moderating? Else set approved already
		if( NOT instance.codexOptions.comments_moderation ){ 
			arguments.comment.setIsApproved(true); 
		}
		// Check if user has already an approved comment. If they do, then approve them
		// Else, send email notification of comment that needs moderation.
		else if( userHasPreviousAcceptedComment(oUser) ){
			arguments.comment.setIsApproved(true);
		}
		
		// send for saving, finally phew!
		super.save(arguments.comment);	
		
		// Send Notification or Moderation Email?
		if( instance.codexOptions.comments_notify OR instance.codexOptions.comments_moderation_notify ){
			sendNotificationEmail(arguments.comment,instance.codexOptions.comments_moderation_notify);
		}
	</cfscript>
</cffunction>

<!--- sendNewCommentEmail --->
<cffunction name="sendNotificationEmail" output="false" access="public" returntype="void" hint="Send a new comment email">
	<cfargument name="comment" type="codex.model.comments.Comment" required="true" default="" hint="The comment"/>
	<cfargument name="moderationDetails" type="boolean" required="false" default="false" hint="Send also moderation emails"/>
	
	<cfset var page = arguments.comment.getPage().getName()>
	<cfset var baseURL = getConfigService().getSetting('sesBaseURL')>
	<cfset var commentURL = "#baseURL#/#getConfigService().getSetting('showKey')#/#page##getConfigService().getRewriteExtension()###pageComment_#arguments.comment.getCommentID()#">
	<cfset var deleteURL = "#baseURL#/comments/delete/commentID/#arguments.comment.getCommentID()##getConfigService().getRewriteExtension()#">
	<cfset var approveURL = "#baseURL#/comments/approve/commentID/#arguments.comment.getCommentID()##getConfigService().getRewriteExtension()#">
	<cfset var subject = "New comment posted on page: #page#">
	<cfset var email = "">
	<cfset var whoisURL = "http://ws.arin.net/cgi-bin/whois.pl?queryinput=#arguments.comment.getAuthorIP()#">
	
	<!--- Moderation Subject --->
	<cfif arguments.moderationDetails>
		<cfset subject = "New comment needs moderation on page: #page#">
	</cfif>
	
	<!--- Email --->
	<cfsavecontent variable="email">
	<cfoutput>
	A new comment has been posted on the page: <a href="#commentURL#">#page#<a/> <cfif arguments.moderationDetails>and is awaiting moderation</cfif>. 
	
	<br/><br/>
	
	Author: #arguments.comment.getAuthor()# <br/>
	Author Email: #arguments.comment.getAuthorEmail()# <br/>
	Author URL: <a href="#arguments.comment.getAuthorURL()#">#arguments.comment.getAuthorURL()#</a> <br/>
	Author IP: #arguments.comment.getAuthorIP()# <br/>
	Whois  : <a href="#whoisURL#">whoisURL</a> <br/>
	Comment:<br/>
	#arguments.comment.getContent()#
	<br/><br/>
	
	Comment URL: <a href="#commentURL#">#commentURL#</a><br/>
	Delete it: <a href="#deleteURL#">#deleteURL#</a><br/>
	<cfif arguments.moderationDetails>
	Approve it: <a href="#approveURL#">#approveURL#</a><br/>
	</cfif>	
	</cfoutput>
	</cfsavecontent>
	
	<!--- Mail It --->
	<cfmail to="#instance.codexOptions.wiki_outgoing_email#"
		    from="#instance.codexOptions.wiki_outgoing_email#"
		    subject="#subject#"
		    type="HTML">
	<cfoutput>#email#</cfoutput>
	</cfmail>
	
</cffunction>

<!--- userHasPreviousComment --->
<cffunction name="userHasPreviousAcceptedComment" output="false" access="public" returntype="boolean" hint="Checks if a user has a previous moderated accepted comment">
	<cfargument name="user" type="any" required="true" hint="The user object to check"/>
	
	<cfset var tql = "">
	<cfset var query = 0>
	<cfset var results = "">
	
	<cfsavecontent variable="tql">
	<cfoutput>
		  FROM wiki.Comment as Comment
		  OUTER JOIN security.User as CodexUser
		  WHERE Comment.isActive = :true
		  	AND Comment.isApproved = :true
		    AND CodexUser.userID = :userID
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);
		query.setCacheEvaluation(true);

		query.setParam("true", true, "boolean");
		query.setParam("userID",user.getUserID());
		
		results = getTransfer().listByQuery(query);
		
		if( results.recordcount ){ return true; }
		return false;		
	</cfscript>
</cffunction>


<cffunction name="getPendingComments" access="public" returntype="query" hint="Get the pending approval comments" output="false" >
	<cfset var q = "">
	
	<cfquery name="q" datasource="#getDataSource().getName()#">
		SELECT Page.page_id pageID,Page.page_name pageName, 
			   Comment.comment_id commentID,
			   Comment.comment_author author, Comment.comment_author_email authorEmail, 
			   Comment.comment_author_url authorURL, Comment.comment_author_ip authorIP,
			   Comment.comment_createdate createdDate, Comment.comment_isActive isActive, 
			   Comment.comment_isApproved isApproved, Comment.comment_content content,
			   CodexUser.user_fname UserFirstName, CodexUser.user_lname UserLastName, 
			   CodexUser.user_username username, CodexUser.user_email UserEmail
		  FROM wiki_comments as Comment
		  JOIN wiki_page as Page ON Comment.FKpage_id = Page.page_id
		  LEFT OUTER JOIN wiki_users as CodexUser ON Comment.FKuser_id = CodexUser.user_id
		  WHERE Comment.comment_isApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		  ORDER BY comment.comment_createdate desc 
	</cfquery>
	
	<cfreturn q>
</cffunction>

<cffunction name="getCommentsInbox" access="public" returntype="query" hint="Get the latest X comments" output="false" >
	<cfargument name="records"    type="numeric" required="true" default="50" hint="The records to retrieve in the inbox"/>
	<cfargument name="approved"   type="boolean" required="false" />
	<cfargument name="active"     type="boolean" required="false" />
	<cfargument name="criteria"   type="string" required="false" />
	
	<cfset var q = "">
	
	<cfquery name="q" datasource="#getDataSource().getName()#" maxrows="#arguments.records#">
		SELECT Page.page_id pageID,Page.page_name pageName, 
			   Comment.comment_id commentID,
			   Comment.comment_author author, Comment.comment_author_email authorEmail, 
			   Comment.comment_author_url authorURL, Comment.comment_author_ip authorIP,
			   Comment.comment_createdate createdDate, Comment.comment_isActive isActive, 
			   Comment.comment_isApproved isApproved, Comment.comment_content content,
			   CodexUser.user_fname UserFirstName, CodexUser.user_lname UserLastName, 
			   CodexUser.user_username username, CodexUser.user_email UserEmail
		  FROM wiki_comments as Comment
		  JOIN wiki_page as Page ON Comment.FKpage_id = Page.page_id
		  LEFT OUTER JOIN wiki_users as CodexUser ON Comment.FKuser_id = CodexUser.user_id
		  WHERE 1 = 1
		  <cfif structKeyExists(arguments,"approved")>
		    AND Comment.comment_isApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.approved#">
		  </cfif>
		  <cfif structKeyExists(arguments,"active")>
		    AND Comment.comment_isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.active#">
		  </cfif>
		  <cfif structKeyExists(arguments,"criteria")>
		    AND Comment.comment_content = <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.content#%">
		  </cfif>
		  ORDER BY Comment.comment_createdate desc 
	</cfquery>
	
	<cfreturn q>
</cffunction>

<cffunction name="getPageComments" access="public" returntype="query" hint="Get a page's comments" output="false" >
	<cfargument name="pageName"  	type="string" 	required="false" hint="The page name to use">
	<cfargument name="pageID"  		type="string" 	required="false" hint="The page ID to use">
	<cfargument name="moderation"  	type="boolean" 	required="false" default="false" hint="Moderation permission enabled">
	<cfargument name="active"  		type="boolean"  required="false" default="true" hint="Get all active comments">
	
	<cfset var tql = "">
	<cfset var query = 0>
	
	<cfsavecontent variable="tql">
	<cfoutput>
		  SELECT Page.pageID,Page.name, Comment.commentID,
			   Comment.author, Comment.authorEmail, Comment.authorURL, Comment.authorIP,
			   Comment.createdDate, Comment.isActive, Comment.isApproved, Comment.content,
			   CodexUser.fname as UserFirstName, CodexUser.lname as UserLastName, CodexUser.username, 
			   CodexUser.email as UserEmail
		  FROM wiki.Comment as Comment
		  JOIN wiki.Page as Page
		  OUTER JOIN security.User as CodexUser
		  WHERE Comment.isActive = :isActive
		  <cfif NOT arguments.moderation>
		  	AND Comment.isApproved = :isApproved
		  </cfif>
		  <cfif structKeyExists(arguments,"pageName")>
		  	AND Page.name = :pageName
		  <cfelseif structKeyExists(arguments,"pageID")>
		  	AND Page.pageID = :pageID
		  </cfif>
		  ORDER BY Comment.createdDate asc
	</cfoutput>
	</cfsavecontent>
	<cfscript>
		query = getTransfer().createQuery(tql);
		query.setCacheEvaluation(true);

		query.setParam("isActive", arguments.active, "boolean");
		if ( NOT arguments.moderation){
			query.setParam("isApproved",true, "boolean");
		}
		if( structKeyExists(arguments,"pageName") ){
			query.setParam("pageName",arguments.pageName);
		}
		else if( structKeyExists(arguments,"pageID") ){
			query.setParam("pageID",arguments.pageID);
		}
		
		return getTransfer().listByQuery(query);
	</cfscript>
</cffunction>


<!------------------------------------------- Dependencies ------------------------------------------->

<!--- Get/Set Security Service --->
<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
	<cfreturn instance.securityService />
</cffunction>
<cffunction name="setSecurityService" access="private" returntype="void" output="false">
	<cfargument name="securityService" type="codex.model.security.SecurityService" required="true">
	<cfset instance.securityService = arguments.securityService />
</cffunction>

<cffunction name="getwikiService" access="private" output="false" returntype="codex.model.wiki.WikiService" hint="Get wikiService">
	<cfreturn instance.wikiService/>
</cffunction>
<cffunction name="setwikiService" access="private" output="false" returntype="void" hint="Set wikiService">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true"/>
	<cfset instance.wikiService = arguments.wikiService/>
</cffunction>

<cffunction name="getConfigService" access="private" output="false" returntype="codex.model.wiki.ConfigService" hint="Get ConfigService">
	<cfreturn instance.ConfigService/>
</cffunction>
<cffunction name="setConfigService" access="private" output="false" returntype="void" hint="Set ConfigService">
	<cfargument name="ConfigService" type="codex.model.wiki.ConfigService" required="true"/>
	<cfset instance.ConfigService = arguments.ConfigService/>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>
