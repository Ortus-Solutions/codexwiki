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
component extends="BaseHandler"{

	// Dependencies
	property name="rssManager" inject;

/************************************** PUBLIC *********************************************/
	
	function show(event){
		var rc = arguments.event.getCollection();

		var data = rssManager.getRSS(rc.source, rc.feed, rc);
		
		// Render RSS
		event.renderData(data=data,contentType="text/xml;UTF-8");
	}
	
}