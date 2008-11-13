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
<cfcomponent name="main"			 extends="baseHandler"			 output="false"			 hint="This is our main wiki handler, all of our funky implicit invocations."			 autowire="true"			 cache="true"			 cacheTimeout="0">
	<!--- Dependencies --->
	<cfproperty name="SecurityService" 	type="ioc" scope="instance" />
	<cfproperty name="ConfigService" 	type="ioc" scope="instance" />

<!------------------------------------------- Implicit Events ------------------------------------------>

	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<!--- ON Application Start Here --->	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfset var rc = event.getCollection()>		<!--- CF Debug Mode or Not --->
		<cfsetting showdebugoutput="#getDebugMode()#">
		<cfscript>
			/* Setup the global exit handlers For the admin*/			rc.xehAdmin = "admin.main/home.cfm";			rc.xehAdminAPI = "admin.main/api.cfm";			rc.xehAdminUsers = "admin.users/list.cfm";			rc.xehAdminLookups = "admin.lookups/display.cfm";			rc.xehAdminCustomHTML = "admin.config/customhtml.cfm";			/* Setup the global exit handlers for the Profile Section */			rc.xehUserProfile = "profile.user/details.cfm";			/* Setup the global exit handlers For the public site*/			rc.xehDashboard = "wiki/Dashboard";			rc.xehSpecialHelp = "wiki/Help:Contents.cfm";			rc.xehSpecialFeeds = "wiki/Special:Feeds.cfm";
			rc.xehSpecialCategory = "wiki/Special:Categories.cfm";			rc.xehUserdoLogin = "user/doLogin.cfm";			rc.xehUserLogin = "user/Login.cfm";			rc.xehUserLogout = "user/logout.cfm";			rc.xehUserRegistration = "user/registration.cfm";			rc.xehUserReminder = "user/reminder.cfm";			/* Get a user from session */			rc.oUser = getSecurityService().getUserSession();			/* Get the wiki's custom HTML */			rc.oCustomHTML = getConfigService().getCustomHTML();			/* Printable Doctype Check */
			isPrintFormat(arguments.event);
		</cfscript>	</cffunction>	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<!--- ON Request End Here --->	</cffunction>	<cffunction name="onException" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<!--- ON Exception Handler Here --->		<cfscript>			//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			/* Log our exception to our logs */			getPlugin("logger").logErrorWithBean(exceptionBean);		</cfscript>	</cffunction>
<!------------------------------------------- DEPENDENCIES ------------------------------------------->	<!--- Security Service --->	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">		<cfreturn instance.SecurityService />	</cffunction>	<!--- Config Service --->	<cffunction name="getConfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">		<cfreturn instance.ConfigService />	</cffunction>
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="isPrintFormat" access="private" returntype="void" hint="Check for print in the event and change layout">
		<cfargument name="Event" type="any">
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