<!-----------------------------------------------------------------------
Template : wiki.cfc
Author 	 : luis5198
Date     : 10/12/2007 2:49:58 PM
Description :
	This is our main wiki handler

Modification History:
10/12/2007 - Created Template
----------------------------------------------------------------------><cfcomponent name="wiki" extends="coldbox.system.eventhandler" output="false" hint="This is our main wiki handler">	<cffunction name="show" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<!--- Do Your Logic Here to prepare a view --->
		<!--- default page is the dashboard --->
		<cfset arguments.event.paramValue("page", "Dashboard") />
		<cfset arguments.event.setValue("welcomeMessage","Welcome to ColdBox!")>
		<cfset arguments.event.setValue("onEditWiki","wiki.edit")>
		<cfset arguments.event.setValue("onDeleteWiki","wiki.delete")>		<!--- Set the View To Display, after Logic --->		<cfset Event.setView("wiki/show")>	</cffunction></cfcomponent>