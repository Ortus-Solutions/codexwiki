<!-----------------------------------------------------------------------
Template : wiki.cfc
Author 	 : luis5198
Date     : 10/12/2007 2:49:58 PM
Description :
	This is our main wiki handler

Modification History:
10/12/2007 - Created Template
----------------------------------------------------------------------><cfcomponent name="wiki" extends="coldbox.system.eventhandler" output="false" hint="This is our main wiki handler">		<cffunction name="dspPage" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- Do Your Logic Here to prepare a view --->		<cfset Event.setValue("welcomeMessage","Welcome to ColdBox!")>			<!--- Set the View To Display, after Logic --->		<cfset Event.setView("home")>	</cffunction>		</cfcomponent>