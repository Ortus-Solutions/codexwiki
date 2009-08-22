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
<cfcomponent extends="baseHandler"			 output="false"			 hint="This is our main wiki handler, all of our funky implicit invocations."			 autowire="true"			 cache="true"			 cacheTimeout="0">
				 
	<!--- Dependencies --->
	<cfproperty name="SecurityService" 	type="ioc" scope="instance" />
	<cfproperty name="ConfigService" 	type="ioc" scope="instance" />

	<cffunction name="init" access="public" returntype="main" output="false">
		<cfargument name="controller" type="any" required="yes">
		<cfscript>
			super.init(arguments.controller);
			
			// Show Keys
			instance.showKey = getSetting('showKey');
			instance.spaceKey = getSetting('spaceKey');
			
			return this;
		</cfscript>
	</cffunction>	

<!------------------------------------------- Implicit Events ------------------------------------------>

	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>
			// Get Wiki Options
			var Options = getConfigService().getOptions();
			
			// Cache Them
			getColdboxOCM().set("CodexOptions",Options,0);
			
			// Check ShowKey
			if( getSetting("ShowKey") eq "" or getSetting("ShowKey") eq "page"){
				$throw(message="Invalid Show Key Detected",
					  detail="The ShowKey setting cannot be left blank or named 'page'. Please change it in the coldbox.xml",
					  type="Codex.InvalidShowKeyException");
			}
			
			// Check SpaceKEy
			if( getSetting("SpaceKey") eq "" or getSetting("SpaceKey") eq "page"){
				$throw(message="Invalid Space Key Detected",
					  detail="The SpaceKey setting cannot be left blank or named 'page'. Please change it in the coldbox.xml",
					  type="Codex.InvalidSpaceKeyException");
			}
		</cfscript>	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfset var rc = event.getCollection()>		<!--- CF Debug Mode or Not --->
		<cfsetting showdebugoutput="#getDebugMode()#">
		<cfscript>
			// Setup the global exit handlers For the admin
			rc.xehAdmin = "admin/main/home";
			if( reFindnocase("^admin",event.getCurrentEvent()) ){				/* Admin Menu */
				rc.xehAdminUsers = "admin/users/list";
				rc.xehAdminRoles = "admin/roles/list";
				
				/* Wiki Admin */
				rc.xehAdminNamespace = "admin/namespace/list";
				rc.xehAdminCategories = "admin/categories/list";
				rc.xehAdminComments = "admin/comments/list";
				
				/* Plugin Menu */
				rc.xehAdminPlugins = "admin/plugins/list";
				rc.xehAdminPluginDocs = "admin/plugins/docs";
				
				/* Tools Menu */
				rc.xehAdminAPI = "admin/tools/api";
				rc.xehAdminConverter = "admin/tools/converter";
				
				/* Settings Menu */
				rc.xehAdminOptions = "admin/config/options";
				rc.xehAdminCommentOptions = "admin/config/comments";
				rc.xehAdminCustomHTML = "admin/config/customhtml";
				rc.xehAdminLookups = "admin/lookups/display";
			}			/* Setup the global exit handlers for the Profile Section */			rc.xehUserProfile = "profile/user/details";			/* Setup the global exit handlers For the public site*/			rc.xehDashboard = "#instance.showKey#/Dashboard";			rc.xehSpecialHelp = "#instance.showkey#/Help:Contents";			rc.xehSpecialFeeds = "#instance.showKey#/Special:Feeds";
			rc.xehSpecialCategory = "#instance.showKey#/Special:Categories";
			rc.xehWikiSearch = "page/search";
			rc.xehPageDirectory = "page/directory";
			rc.xehSpaceDirectory = "spaces";
			
			/* Global User Exit Handlers */			rc.xehUserdoLogin = "user/doLogin";			rc.xehUserLogin = "user/login";			rc.xehUserLogout = "user/logout";			rc.xehUserRegistration = "user/registration";			rc.xehUserReminder = "user/reminder";			/* Get a user from session */			rc.oUser = getSecurityService().getUserSession();			/* Get the wiki's custom HTML */			rc.oCustomHTML = getConfigService().getCustomHTML();			/* Get the wiki's Options */
			rc.CodexOptions = getColdboxOCM().get('CodexOptions');
		</cfscript>	</cffunction>	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">	</cffunction>	<cffunction name="onException" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>
			var invalidList = "Framework.invalidEventException,Framework.EventHandlerNotRegisteredException";
						//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			/* Log our exception to our logs */			getPlugin("logger").logErrorWithBean(exceptionBean);
			
			/* Test for 404 errors */
			if( listfindnocase(invalidList,exceptionBean.getType()) ){
				setNextRoute("notfound");
			}		</cfscript>	</cffunction>
	
	<cffunction name="notfound" access="public" returntype="void" output="false" hint="A not found 404 page">
		<cfargument name="Event" type="any">
		<cfheader statuscode="404" statustext="Page Not Found" />
		<cfset event.setView("main/notFound")>
	</cffunction>
<!------------------------------------------- DEPENDENCIES ------------------------------------------->	<!--- Security Service --->	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">		<cfreturn instance.SecurityService />	</cffunction>	<!--- Config Service --->	<cffunction name="getConfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">		<cfreturn instance.ConfigService />	</cffunction>
<!------------------------------------------- PRIVATE ------------------------------------------->

	</cfcomponent>