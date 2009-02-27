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
<cfcomponent name="tools"
			 extends="codex.handlers.baseHandler"
			 output="false"
			 hint="Our tools handler for the admin.">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!---  --->
	<cffunction name="index" access="public" returntype="void" output="false" hint="Main handler event">
		<cfargument name="Event" type="any" required="yes">
		<!--- Home is the main event. --->
		<cfset api(event)>
	</cffunction>
	
	<!--- api --->
	<cffunction name="api" access="public" returntype="void" output="false" hint="Show the API" cache="true" cacheTimeout="30">
		<cfargument name="Event" type="any" required="yes">
	    <cfset var rc = event.getCollection()>
	    <cfscript>
			/* Setup the Cfc Viewer */
			rc.cfcViewer = getPlugin("cfcViewer").setup(dirpath="/codex/model",
														dirLink="#getSetting('sesBaseURL')#/admin.main/api#event.getRewriteExtension()#?");

			/* Setup the view */
			event.setView("admin/tools/api");
		</cfscript>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->



</cfcomponent>