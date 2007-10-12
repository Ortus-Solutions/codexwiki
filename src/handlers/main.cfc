<!-----------------------------------------------------------------------
Template : main.cfc
Author 	 : Luis Majano
Date     : 10/12/2007 2:49:05 PM
Description :
	This is our main wiki handler, all of our funky implicit invocations.

Modification History:
10/12/2007 - Created Template
---------------------------------------------------------------------->
<cfcomponent name="wiki" extends="coldbox.system.eventhandler" output="false" hint="This is our main wiki handler, all of our funky implicit invocations.">	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Application Start Here --->	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- On Request Start Code Here --->	</cffunction>	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Request End Here --->	</cffunction>	<cffunction name="onException" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Exception Handler Here --->		<cfscript>			//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			//Place exception handler below:		</cfscript>	</cffunction></cfcomponent>