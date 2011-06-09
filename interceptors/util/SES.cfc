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
* @hint Custom Codex SES interceptor to allow for onMissingTemplate strategy
**/
component extends="coldbox.system.Interceptors.SES" accessors="true"{
	
	// Dependencies
	property name="appMapping" inject="coldbox:setting:AppMapping";
	
	/**
	* Override how CGI variables are retrieved
	*/	
	private any function getCGIElement(cgiElement,event){
		var rc = event.getCollection();
		// check if missing template is found?
		if( event.valueExists("missingTemplate") and arguments.cgiElement eq "path_info" ){
			return processMissingTemplate( event.getValue("missingTemplate") );
		}
		// We are in full rewrite ses mode
		return replace(super.getCGIElement(arguments.cgielement,arguments.event),"//","/","all");		
	}		
	
	/**
	* process missing template
	*/
	private any function processMissingTemplate(template){
		var appRoot = getAppMapping();
		
		// Make sure we have a proper root
		if( left(appRoot,1) neq "/" ){
			appRoot = "/" & appRoot;
		}
		
		// Clean the root from the app root and rip the extension to get our route.
		return reReplace(replacenocase(arguments.template, appRoot,""),"\.[^.]*$","");
	}
			
}