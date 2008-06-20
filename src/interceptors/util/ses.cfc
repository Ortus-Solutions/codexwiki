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
<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	9/28/2007
Description :
	This is an interceptor for ses support. This code is based almost totally on
	Adam Fortuna's ColdCourse cfc, which is an AMAZING SES component
	All credits go to him: http://coldcourse.riaforge.com
----------------------------------------------------------------------->
<cfcomponent name="ses"
			 hint="This is a ses support internceptor"
			 output="false"
			 extends="coldbox.system.interceptors.ses">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="This is where the ses plugin configures itself." output="false" >
		<cfscript>
			super.configure();
		</cfscript>
	</cffunction>

<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->


	<!--- Pre execution process --->
	<cffunction name="preProcess" access="public" returntype="void" hint="This is the course dispatch" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<!--- ************************************************************* --->
		<cfscript>
			/* Find which route this URL matches */
			var acourse = "";
			var key = "";
			var cleanedPathInfo = getSESElement('path_info');
			var cleanedScriptName = trim(replacenocase(getSESElement('script_name'),"/index.cfm",""));

			/* Clean again */
			cleanedScriptName = trim(replacenocase(getSESElement('script_name'),"\index.cfm",""));

			/* Check if active */
			if ( not getEnabled() )
				return;

			/* Check for invalid URL */
			checkForInvalidURL( getSESElement('path_info') , getSESElement('script_name'), arguments.event );

			/* Clean up the path_info */
			if( len(cleanedScriptName) gt 0)
				cleanedPathInfo = replaceNocase(getSESElement('path_info'),cleanedScriptName,'');

			/* Find a course */
			acourse = findCourse( cleanedPathInfo, event );

			/* Now course should have all the key/pairs from the URL we need to pass to our event object */
			for( key in acourse ){
				event.setValue( key, acourse[key] );
			}

			/* Route to destination */
			routeToDestination(acourse,event);

			/* Execute Cache Test now that routing has been done */
			getController().getRequestService().EventCachingTest(event);
			/* SES */
			event.setisSES(true);
		</cfscript>
	</cffunction>


<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getSESElement" access="private" returntype="string" hint="The request element facade method" output="false" >
		<cfargument name="seselement" required="true" type="string" hint="">
		<cfscript>
			/* Are we in request ses mode? */
			if ( structKeyExists(request,"ses") ){
				return request.ses[arguments.seselement];
			}
			/* We are in cgi ses mode. */
			else{
				return getCGIElement(arguments.seselement);
			}
		</cfscript>
	</cffunction>

</cfcomponent>