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
<cfcomponent name="utility" hint="A utility component for developer usage." output="false">

<!------------------------------------------- TIMER METHODS ------------------------------------------->

	<cffunction name="timerStart" access="public" returntype="void" output="false" hint="Start the timer with label.">
		<cfargument name="Label" 	 required="true" type="string">
		<!--- Create request timer --->
		<cfset var timerStruct = structnew()>
		<cfset timerStruct.stime = getTickcount()>
		<cfset timerStruct.label = arguments.label>
		<!--- Place in request scope --->
		<cfset request[hash(arguments.label)] = timerStruct>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="timerStop" access="public" returntype="void" output="false" hint="Stop the timer with label">
		<cfargument name="Label" 	 required="true" type="string">
		<cfset var stopTime = getTickcount()>
		<cfset var timerStruct = "">
		<cfset var labelhash = hash(arguments.label)>

		<!--- Check if the label exists --->
		<cfif StructKeyExists(request,labelhash)>
			<cfset timerStruct = request[labelhash]>
			<cfset addRow(timerStruct.label,stopTime - timerStruct.stime)>
		<cfelse>
			<cfset addRow("#arguments.label# invalid",0)>
		</cfif>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="logTime" access="public" returntype="void" output="false" hint="Use this method to add a new timer entry to the timers.">
		<cfargument name="Label" 	 required="true" type="string" hint="The lable of the timer.">
		<cfargument name="Tickcount" required="true" type="string" hint="The tickcounts of the time.">
		<cfset addRow(arguments.label,arguments.tickcount)>
	</cffunction>
	
	<!--- ************************************************************* --->
	
	<cffunction name="getTimerScope" access="public" returntype="query" output="false">
		<!---Get the timer scope if it exists, else create it --->
		<cfif not structKeyExists(request,"DebugTimers")>
			<cfset request.DebugTimers = QueryNew("Method,Time,Timestamp")>
		</cfif>
		<cfreturn request.DebugTimers>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="addRow" access="public" returntype="void" output="false">
		<cfargument name="Label" 	 required="true" type="string" hint="The lable of the timer.">
		<cfargument name="Tickcount" required="true" type="string" hint="The tickcounts of the time.">
		<cfscript>
		var qTimer = getTimerScope();
		QueryAddRow(qTimer,1);
		QuerySetCell(qTimer, "Method", arguments.Label);
		QuerySetCell(qTimer, "Time", arguments.Tickcount);
		QuerySetCell(qTimer, "Timestamp", now());
		</cfscript>
	</cffunction>

<!------------------------------------------- UTILITY METHODS ------------------------------------------->

	<cffunction name="throw" access="public" hint="Facade for cfthrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="message" 		type="string" 	required="yes">
		<cfargument name="detail" 		type="string" 	required="no" default="">
		<cfargument name="type"  		type="string" 	required="no" default="">
		<cfargument name="extendedinfo" type="any"		required="no" default="">
		<!--- ************************************************************* --->
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#" extendedinfo="#arguments.extendedinfo#">
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="dump" access="public" hint="Facade for cfmx dump" returntype="void">
		<cfargument name="var" required="yes" type="any">
		<cfdump var="#var#">
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="abort" access="public" hint="Facade for cfabort" returntype="void" output="false">
		<cfabort>
	</cffunction>

	<!--- ************************************************************* --->

	
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	

</cfcomponent>