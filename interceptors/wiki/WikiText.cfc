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
* @hint Wiki Text translation observer
**/
component extends="coldbox.system.Interceptor" accessors="true" {

	// Dependencies
	property name="wikiText" inject="model:WikiText";

	/**
	* Configure interceptor
	*/
	function configure(){
		// Check Properties
		if( NOT propertyExists("ignoreXMLTagList") ){
			setProperty("ignoreXMLTagList","");
		}
		if( NOT propertyExists("allowedAttributes") ){
			setProperty("allowedAttributes","");
		}
	}

	/**
	* onDIComplete - configure the wiki text parser
	*/
	function onDIComplete(){
		getWikiText().configure( getProperty("ignoreXMLTagList"), getProperty("allowedAttributes") );
	}

	/**
	* Custom Observer when pages are translated
	*/
	function onWikiPageTranslate(event,interceptData){
		// visit the content with our parser
		arguments.interceptData.content.visitContent(getWikiText(), arguments.interceptData);
	}
			
}