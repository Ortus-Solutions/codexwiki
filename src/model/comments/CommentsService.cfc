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
		else{
			// Check if user has already an approved comment. If they do, then approve them
			// Else, send email notification of comment that needs moderation.
			
			// send comment moderation email
		}
		
		// send a comment made notification.
		
		// send for saving.
		super.save(arguments.comment);	
	</cfscript>
</cffunction>

<cffunction name="getAllComments" access="public" returntype="query" hint="Get All Comments" output="false" >
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
