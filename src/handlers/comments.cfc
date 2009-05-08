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
			 extends="baseHandler"
			 output="false"
			 hint="Our wiki comments handler"
			 autowire="true"
			 cache="true">

	<!--- dependencies --->
	<cfproperty name="WikiService" 		type="ioc" scope="instance" />
	<cfproperty name="CommentsService"	type="ioc" scope="instance" />
	<cfproperty name="SecurityService" 	type="ioc" scope="instance" />

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->


<!------------------------------------------- IMPLICIT ------------------------------------------>

	<!--- preHandler --->
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			/* Check if Comments enabled? */
			if( rc.codexOptions.comments_enabled EQ FALSE ){
				getPlugin("messagebox").setMessage(type="warning", message="Comments are not enabled in the wiki.");
				setNextEvent(getSetting("DefaultEvent"));
			}
			/* Check if only registered users are allowed to comment */
			if( rc.codexOptions.comments_registration AND
			    NOT rc.oUser.getIsAuthorized() ){
			    getPlugin("messagebox").setMessage(type="warning", message="Only registered users can comment.");
				setNextEvent(getSetting("DefaultEvent"));
			}
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------>
	
	<!--- newComment --->
	<cffunction name="newComment" access="public" returntype="void" output="false" hint="New Comment Screen">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			/* Exit Handlers */
			rc.xehSaveComment = "comments.saveComment";
			
			/* Get Content Just in Case */
			rc.oContent = instance.wikiService.getContent(pageName=rc.page);
			rc.oPage = oContent.getPage();
			
			event.setView("wiki/addComments");
		</cfscript>
	</cffunction>
	
	<!--- saveComment --->
	<cffunction name="saveComment" access="public" returntype="void" output="false" hint="Save a comment">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
	
		</cfscript>
	</cffunction>
</cfcomponent>