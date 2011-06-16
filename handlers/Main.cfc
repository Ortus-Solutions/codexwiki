/**
********************************************************************************
* Copyright Since 2011 CodexPlatform
* www.codexplatform.com | www.coldbox.org | www.ortussolutions.com
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
* @author Luis Majano
* @hint This is our main wiki handler
**/
component extends="BaseHandler" accessors="true" singleton{

	// Dependencies
	property name="securityService" inject;
	property name="configService" 	inject;
	property name="showKey"			inject="coldbox:setting:showKey";
	property name="spaceKey"		inject="coldbox:setting:spaceKey";

/************************************** PUBLIC *********************************************/

	function onAppInit(event,rc,prc){
		// Cache Wiki Options at startup
		getColdboxOCM().set("CodexOptions", configService.getOptions() , 0);
		
		// TODO: Why these checks?
		// Check ShowKey
		if( NOT len(showKey) OR showKey eq "page"){
			$throw(message="Invalid Show Key Detected",
				  detail="The ShowKey setting cannot be left blank or named 'page'. Please change it in the configuration file.",
				  type="Codex.InvalidShowKeyException");
		}
		
		// Check SpaceKey
		if( NOT len(SpaceKey) or SpaceKey eq "page"){
			$throw(message="Invalid Space Key Detected",
				  detail="The SpaceKey setting cannot be left blank or named 'page'. Please change it in the configuration file",
				  type="Codex.InvalidSpaceKeyException");
		}
	}

	function onRequestStart(event,rc,prc){
		// Setup the global exit handlers For the admin
		rc.xehAdmin = "admin/main/home";
		// TODO: move this to admin module once created
		// Only if in admin
		if( reFindnocase("^admin",event.getCurrentEvent()) ){
			// Admin Menu */
			rc.xehAdminUsers = "admin/users/list";
			rc.xehAdminRoles = "admin/roles/list";
			
			// Wiki Admin */
			rc.xehAdminNamespace = "admin/namespace/list";
			rc.xehAdminCategories = "admin/categories/list";
			rc.xehAdminComments = "admin/comments/list";
			
			// Plugin Menu */
			rc.xehAdminPlugins = "admin/plugins/list";
			rc.xehAdminPluginDocs = "admin/plugins/docs";
			
			// Tools Menu */
			rc.xehAdminAPI = "admin/tools/api";
			rc.xehAdminConverter = "admin/tools/converter";
			
			// Settings Menu */
			rc.xehAdminOptions = "admin/config/options";
			rc.xehAdminCommentOptions = "admin/config/comments";
			rc.xehAdminCustomHTML = "admin/config/customhtml";
			rc.xehAdminLookups = "admin/lookups/display";
		}

		// Setup the global exit handlers for the Profile Section */
		rc.xehUserProfile = "profile/user/details";

		// Setup the global exit handlers For the public site*/
		rc.xehDashboard = "#showKey#/Dashboard";
		rc.xehSpecialHelp = "#showKey#/Help:Contents";
		rc.xehSpecialFeeds = "#showKey#/Special:Feeds";
		rc.xehSpecialCategory = "#showKey#/Special:Categories";
		rc.xehWikiSearch = "page/search";
		rc.xehPageDirectory = "page/directory";
		rc.xehSpaceDirectory = "spaces";
		
		// Global User Exit Handlers */
		rc.xehUserdoLogin = "user/doLogin";
		rc.xehUserLogin = "user/login";
		rc.xehUserLogout = "user/logout";
		rc.xehUserRegistration = "user/registration";
		rc.xehUserReminder = "user/reminder";

		// Get a user from session
		rc.oUser = securityService.getUserSession();
		
		// Get the wiki's custom HTML
		rc.oCustomHTML = configService.getCustomHTML();
		
		// Get the wiki's Options
		rc.CodexOptions = getColdboxOCM().get('CodexOptions');
	}	
	function onMissingTemplate(event,rc,prc){
		// If we get here then no resource was hit and we DO have a missing template
		notFound(arguments.event);
	}
	
	function onRequestEnd(event,rc,prc){}
	
	function notFound(event,rc,prc){
		event.setHTTPHeader(statusCode=404,statusText="PageNotFound")
			.setView("main/notFound");	
	}
	
}