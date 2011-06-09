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
* @hint Wiki Text feed translator
**/
component extends="coldbox.system.Interceptor" accessors="true" {

	// Dependencies
	property name="feed" inject="ioc:Feed";

	/**
	* Custom Observer when pages are translated
	*/
	function onWikiPageTranslate(event,interceptData){
		// visit the content with our feed parser
		arguments.interceptData.content.visitContent( variables.feed, arguments.interceptData);
	}
			
}