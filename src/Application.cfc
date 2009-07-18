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
<cfcomponent output="false">	<!--- Modify the Name of the application--->	<cfset this.name = "codeXwiki_" & hash(getCurrentTemplatePath())>	<cfset this.sessionManagement = true>	<cfset this.sessionTimeout = createTimeSpan(0,1,0,0)>	<cfset this.setClientCookies = true>	<!--- codex mapping --->	<cfset this.mappings["/codex"] = getDirectoryFromPath(getCurrentTemplatePath()) />	<!--- <cfset this.mappings["/coldbox"] = expandPath("/coldbox")> --->	
	<!--- COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP --->	<cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath())>	<!--- COLDBOX PROPERTIES --->	<cfset COLDBOX_CONFIG_FILE = "">
	
	<!--- on Application Start --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfscript>
			//Load ColdBox
			application.cbBootstrap = CreateObject("component","coldbox.system.coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH);
			application.cbBootstrap.loadColdbox();
			return true;
		</cfscript>
	</cffunction>
		<!--- on Request Start --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true" />
		<!--- ************************************************************* --->
		<cfsetting enablecfoutputonly="yes">
		
		<!--- Remove onMissingTemplate for Railo for now --->
		<cfif structKeyExists(server,"railo")>
			<cfset structDelete(this,"onMissingTemplate")>
			<cfset structDelete(variables,"onMissingTemplate")>
		</cfif>
		
		<!--- BootStrap Reinit Check --->
		<cfif not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit()>
			<cflock name="coldbox.bootstrap_#this.name#" type="exclusive" timeout="5" throwontimeout="true">
				<cfset structDelete(application,"cbBootStrap")>
				<cfset application.cbBootstrap = CreateObject("component","coldbox.system.coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH)>
			</cflock>
		</cfif>
		
		<!--- Reload Checks --->
		<cfset application.cbBootstrap.reloadChecks()>
		
		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<cfset application.cbBootstrap.processColdBoxRequest()>
		</cfif>
			
		<!--- WHATEVER YOU WANT BELOW --->
		<cfsetting enablecfoutputonly="no">
		<cfreturn true>
	</cffunction>
		<!--- on Missing Template End --->
	<cffunction name="onMissingTemplate" returnType="boolean" output="true">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true">
		<!--- ************************************************************* --->
		<cfreturn _onMissingTemplate(argumentCollection=arguments)>
	</cffunction>	
	<!--- On Error for Railo --->
	<cffunction name="onError" output="true" access="public" returntype="void">
		<cfargument name="Exception" required="true" type="any" />
   		<cfargument name="EventName" required="true" type="String" />
		<cfsetting enablecfoutputonly="yes">
		<cfif structKeyExists(server,"railo")>
			<cfif structKeyExists(exception,"type") and exception.type eq "missinginclude">
				<cfset _onMissingTemplate(targetPage=exception.missingFileName_rel)>
			<cfelse>
				<cfthrow object="#arguments.Exception#">
			</cfif>
		<cfelse>
			<cfthrow object="#arguments.Exception#">
		</cfif>
		<cfsetting enablecfoutputonly="no">
	</cffunction>
	
	<!--- on Missing Template End --->
	<cffunction name="_onMissingTemplate" returnType="boolean" output="true" access="private">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true">
		<!--- ************************************************************* --->
		<cfset var route = "">
		<!--- We go directly to app scope because onApplicationStart executes first. --->
		<cfset var appRoot = application.cbController.getSetting('AppMapping')>
		<cfsetting enablecfoutputonly="yes">
		
		<!--- Make sure we have a proper root --->
		<cfif left(appRoot,1) neq "/">
			<cfset appRoot = "/" & appRoot>
		</cfif>

		<!--- Clean the root from the app root and rip the extension to get our route. --->
		<cfset route = reReplace(replacenocase(arguments.targetPage,appRoot,""),"\.[^.]*$","")>

		<!--- This route is our new cgi.path_info --->
		<cfset request.ses = {path_info = route, script_name = appRoot & "index.cfm"}>
		
		<!--- Now process the ColdBox Request --->
		<cfset onRequestStart('index.cfm')>
		
		<cfsetting enablecfoutputonly="no">
		<cfreturn true>
	</cffunction>
</cfcomponent>