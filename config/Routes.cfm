<cfscript>
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
**/	

	// Directives
	setUniqueURLS(false);
	
	if ( len(getSetting("AppMapping")) lte 1 ){
		setBaseURL("http://#cgi.HTTP_HOST#");
	}
	else{
		setBaseURL("http://#cgi.HTTP_HOST#/#getSetting('AppMapping')#");
	}

	// Codex Platform Routes
	// 404 errors
	addRoute(pattern="notfound/",handler="main",action="notfound");
	// Main wiki URl's
	addRoute(pattern="#getSetting('ShowKey')#/:page?/:print?",handler="page",action="show");
	// Namespace Visualizer
	addRoute(pattern="#getSetting('SpaceKey')#/:namespace?",handler="space",action="viewer");
	// Namespace Directory
	addRoute(pattern="spaces",handler="space",action="directory");
	// Feed URLs
	addRoute(pattern="feed/:source/:feed",handler="feed",action="show");
	// User Management
	addRoute(":handler/:action/sort/:sortby/:sortOrder/:page");
	addRoute(":handler/:action/user_id/:user_id/permissionID/:permissionID");
	addRoute(":handler/:action/user_id/:user_id");
	// Page actions with page name and id
	addRoute(pattern="page/:action/id/:contentid",handler="page");
	addRoute(pattern="page/:action/:page",handler="page");

	// Standard ColdBox Route
	addRoute(":handler/:action?");
		
</cfscript>