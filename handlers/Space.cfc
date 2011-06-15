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
**/
component extends="BaseHandler" accessors="true"{

	// Dependencies
	property name="WikiService" inject;

/************************************** PUBLIC *********************************************/
	
	function viewer(event){
		var rc = event.getCollection();
		
		event.paramValue("namespace","");
		
		// CSS & JS
		rc.jsAppendList = 'jquery.uitablefilter';
		
		
		// Check if Default Namespace or Not?
		if( len(rc.namespace) ){
			// Get All Pages for the incoming namespace
			rc.qPages = wikiService.getPages(namespace=rc.namespace);
		}
		else{
			// Get All Pages for the default namespace
			rc.qPages = wikiService.getPages(defaultNamespace=true);
		}
		
		// Page Title
		rc.pageTitle = "Namespace Viewer For: #rc.namespace#";
		
		event.setView(name='space/viewer',nolayout=event.getValue("nolayout",false));
	}
	
	function directory(event){
		var rc 			= event.getCollection();
		var ids 		= "";
		var qDefault 	= 0;

		// Required
		rc.jsAppendList = 'jquery.uitablefilter';
		
		// Get All Namespaces
		rc.qNameSpaces = wikiService.getNamespaces();
		
		event.setView('space/directory');
	}

}