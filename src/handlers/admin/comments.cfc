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
<cfcomponent name="comments"
			 output="false"
			 hint="comments Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="CommentsService" 	 type="ioc" scope="instance">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List comments --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="comments">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			rc.xehListing 	= "admin/comments/list";
			rc.xehCreate 	= "admin/comments/new";
			rc.xehEdit 		= "admin/comments/edit";
			rc.xehDelete 	= "admin/comments/doDelete";
			rc.xehStatus    = "admin/comments/changeStatus";
			
			event.setValue("jsAppendList", "simplemodal.helper,jquery.simplemodal,confirm,jquery.metadata,jquery.tablesorter.min,jquery.uitablefilter");
			event.setValue("cssFullAppendList","includes/lookups/styles/sort");
			
			//Filters
			event.paramValue("filter","all");
			switch(rc.filter){
				case "all" : {
					rc.qComments = instance.CommentsService.getCommentsInbox();
					break;
				}
				case "pending" : {
					rc.qComments = instance.CommentsService.getCommentsInbox(approved=false);
					break;
				}
				case "approved" : {
					rc.qComments = instance.CommentsService.getCommentsInbox(approved=true);
					break;
				}
			}
			
			event.setView('admin/comments/Listing');
		</cfscript>
	</cffunction>
	
	<cffunction name="changeStatus" output="false" access="public" returntype="void" hint="change status">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var i=1;
			var thisID = "";
			
			for(i=1; i lte listlen(rc.commentID); i=i+1){
				thisID = listGetAt(rc.commentID,i);
				// Get Comment
				rc.oComment = instance.commentsService.getComment(thisID);
				// Aprove it
				if( rc.status eq "approve"){
					rc.oComment.setIsApproved(true);
				}
				else{
					rc.oComment.setIsApproved(false);
				}
				//Save it
				instance.commentsService.save(rc.oComment);
			}
			
			getPlugin("MessageBox").setMessage(type="info", message="Comment(s) Status Modified!");
			setNextRoute("admin/comments/list");
		</cfscript>
	</cffunction>

	
	<!--- Edit Panel --->
	<cffunction name="edit" output="false" access="public" returntype="void" hint="Namespace editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			rc.xehListing = "admin/comments/list";
			rc.xehUpdate = "admin/comments/doEdit";
			
			rc.jsAppendList = "formvalidation";
			
			rc.oComment =  instance.commentsService.getComment(rc.commentID);

			event.setView("admin/comments/edit");
		</cfscript>
	</cffunction>

	<!--- Do Edit --->
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="Edit a namespace">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oComment = "";
			var oClonedComment = "";
			var errors = ArrayNew(1);
			
			oComment = instance.commentsService.getComment(rc.commentID);
			oClonedComment = oComment.clone();
			getPlugin("beanFactory").populateBean(oClonedComment);
			
			errors = oClonedComment.validate();
			if( ArrayLen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				edit(event);
			}
			else{
				instance.commentsService.save(oClonedComment);
				getPlugin("messagebox").setMessage("info","Comment updated!");
				setNextRoute(route="admin/comments/list");
			}
		</cfscript>
	</cffunction>

	<!--- Delete User --->
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete comments.">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var thisID = "";
			var i = 1;
			event.paramValue("commentID","");
			for(i=1; i lte listlen(rc.commentID); i=i+1){
				thisID = listGetAt(rc.commentID,i);
				// Get Comment
				rc.oComment = instance.commentsService.getComment(thisID);
				// Delete IT
				instance.commentsService.delete(rc.oComment);
			}
			if( NOT len(rc.commentID) ){
				getPlugin("MessageBox").setMessage(type="warning", message="Please select a comment(s) to delete!");
			}
			else{
				getPlugin("MessageBox").setMessage(type="info", message="Comment(s) Delete!");
			}
			setNextRoute("admin/comments/list");
		</cfscript>
	</cffunction>


<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>