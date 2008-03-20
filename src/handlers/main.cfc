<cfcomponent name="main"			 extends="baseHandler"			 output="false"			 hint="This is our main wiki handler, all of our funky implicit invocations."			 autowire="true"			 cache="true" cacheTimeout="0">	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Application Start Here --->	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<cfset var rc = event.getCollection()>		<!--- CF Debug Mode or Not --->
		<cfsetting showdebugoutput="#getDebugMode()#">
		<cfscript>
			/* Setup the global exit handlers For the admin*/			rc.xehAdmin = "admin.main/home.cfm";			rc.xehAdminLookups = "admin.lookups/display.cfm";			/* Profile */			rc.xehUserProfile = "profile.user/details.cfm";			/* Setup the global exit handlers For the public site*/			rc.xehDashboard = "wiki/Dashboard";			rc.xehSpecialHelp = "wiki/Help:Contents.cfm";			rc.xehSpecialFeeds = "wiki/Special:Feeds.cfm";			rc.xehUserdoLogin = "user/doLogin.cfm";			rc.xehUserLogin = "user/Login.cfm";			rc.xehUserLogout = "user/logout.cfm";			rc.xehUserRegistration = "user/registration.cfm";			rc.xehUserReminder = "user/reminder.cfm";			/* Get a user from session */			rc.oUser = getSecurityService().getUserSession();			/* Printable Doctype Check */
			isPrintFormat(arguments.event);
		</cfscript>	</cffunction>	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Request End Here --->	</cffunction>	<cffunction name="onException" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Exception Handler Here --->		<cfscript>			//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			//Place exception handler below:		</cfscript>	</cffunction>
<!------------------------------------------- DEPENDENCIES ------------------------------------------->	<!--- Security Service --->	<cffunction name="setSecurityService" access="public" returntype="void" output="false">		<cfargument name="SecurityService" type="codex.model.security.SecurityService" required="true">		<cfset instance.SecurityService = arguments.SecurityService />	</cffunction>	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">		<cfreturn instance.SecurityService />	</cffunction>
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="isPrintFormat" access="private" returntype="void" hint="Check for print in the event and change layout">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		if( not reFindNoCase("^(flashpaper|pdf|HTML)$",event.getValue("print","")) ){
			return;
		}
		else{
			/* Change Layout */
			Event.setLayout("Layout.Print");
			/* Set Extensions */
			if ( Event.getValue("print") eq "pdf" )
			{
				event.setValue("layout_extension","pdf");
			}
			else if( event.getValue("print") eq "flashpaper"){
				event.setValue("layout_extension","swf");
			}			else{				Event.setLayout("Layout.html");			}
		}
		</cfscript>
	</cffunction>
</cfcomponent>