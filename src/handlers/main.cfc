<cfcomponent name="main" 			 extends="baseHandler" 			 output="false" 			 hint="This is our main wiki handler, all of our funky implicit invocations."			 autowire="true"			 cache="true" cacheTimeout="0">	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Application Start Here --->	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- CF Debug Mode or Not --->
		<cfsetting showdebugoutput="#getDebugMode()#">
		<cfscript>
						/* Get a user from session */									/* Printable Doctype Check */
			isPrintFormat(arguments.event);	
		</cfscript>	</cffunction>	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Request End Here --->	</cffunction>	<cffunction name="onException" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Exception Handler Here --->		<cfscript>			//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			//Place exception handler below:		</cfscript>	</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->	<cffunction name="setUserService" access="public" returntype="void" output="false">		<cfargument name="userService" type="codex.model.security.UserService" required="true">		<cfset instance.userService = arguments.userService />	</cffunction>	
<!------------------------------------------- PACKAGE ------------------------------------------->
		
<!------------------------------------------- PRIVATE ------------------------------------------->
	<cffunction name="getUserService" access="private" returntype="codex.model.security.userService" output="false">		<cfreturn instance.userService />	</cffunction>
	
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