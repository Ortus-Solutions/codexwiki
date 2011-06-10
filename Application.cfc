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
* @hint Codex Platform Application.cfc
**/
component{
	
	// Application Setup
	this.name = "CodexPlatform-" & hash(getCurrentTemplatePath());
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,1,0,0);
	this.setClientCookies = true;

	// Mappings
	this.mappings["/"] 			= getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings["/codex"] 	= this.mappings["/"];
	//this.mappings["/coldbox"] 	= "";
	
	// ColdBox Settings
	import coldbox.system.*;
	COLDBOX_APP_ROOT_PATH = this.mappings["/"];
	COLDBOX_APP_MAPPING   = "/";
	COLDBOX_CONFIG_FILE   = "";
	COLDBOX_APP_KEY 	  = "";
	
	/**
	* On Application Start
	*/
	boolean function onApplicationStart(){
		//Load ColdBox
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
		application.cbBootstrap.loadColdbox();
		return true;
	}
	/**
	* On Application End
	*/
	void function onApplicationEnd(appScope){
		arguments.appScope.cbBootstrap.onApplicationEnd(argumentCollection=arguments);
	}
	
	/**
	* On Request Start
	*/
	boolean function onRequestStart(targetPage){
		// BootStrap Reinit Check
		if ( NOT structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit() ){
			lock name="coldbox.bootstrap_#hash(getCurrentTemplatePath())#" type="exclusive" timeout="5" throwontimeout="true"{
				structDelete(application,"cbBootStrap");
				onApplicationStart();
			}
		}
			
		// Process A ColdBox Request Only
		if( findNoCase('index.cfm', listLast(arguments.targetPage, '/')) ){
			// On Request Start via ColdBox
			application.cbBootstrap.onRequestStart(arguments.targetPage);
		}
		return true;
	} // end of onRequestStart
	
	/**
	* On MissingTemplate
	*/
	any function onMissingTemplate(template){
		return application.cbBootstrap.onMissingTemplate(argumentCollection=arguments);
	}
	
	/**
	* On Session Start
	*/
	void function onSessionStart(){
		application.cbBootstrap.onSessionStart(argumentCollection=arguments);
	}
	
	/**
	* On Session End
	*/
	void function onSessionEnd(sessionScope,appScope){
		arguments.appScope.cbBootstrap.onSessionEnd(argumentCollection=arguments);
	}
	
}