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
<!--- Helper for showing page root --->
<cffunction name="pageShowRoot" access="public" returntype="string" hint="The page root to use when linking wiki pages." output="false" >
	<cfargument name="page" type="string" required="false" default="" hint="The page to pre-pend the root"/>
	<cfreturn getSetting('showKey') & "/" & arguments.page>
</cffunction>
<!--- printTime --->
<cffunction name="printTime" output="false" access="private" returntype="string" hint="Print time in good format">
	<cfargument name="time" 	type="string" required="true" hint=""/>
	<cfargument name="timeType" type="string" required="false" default="NORMAL" hint="SHORT (hh:mm tt), 24 (HH:mm:ss tt), NORMAL (hh:mm:ss tt)"/>
	<cfif not isDate(arguments.time)>
		<cfreturn arguments.time>
	</cfif>
	<cfif arguments.timeType eq "SHORT">
		<cfreturn timeFormat(arguments.time, "hh:mm tt")>
	<cfelseif arguments.timeType eq "NORMAL">
		<cfreturn timeFormat(arguments.time, "hh:mm:ss tt")>
	<Cfelse>
		<cfreturn timeFormat(arguments.time, "HH:mm:ss tt")>
	</cfif>
</cffunction>
<!--- printDate --->
<cffunction name="printDate" output="false" access="private" returntype="string" hint="Print date in good format">
	<cfargument name="datetime" type="string" required="true"/>
	<cfargument name="dateType" type="string" required="false" default="SHORT" hint="SHORT (dd-mmm-yyyy), FULL (dddd, mmmm dd, yyyy)"/>
	<cfif not isDate(arguments.datetime)>
		<cfreturn arguments.datetime>
	</cfif>
	<cfif arguments.dateType eq "SHORT">
		<cfreturn dateFormat(arguments.datetime, "dd-mmm-yyyy")>
	<cfelse>
		<cfreturn dateFormat(arguments.datetime, "dddd, mmmm dd, yyyy")>
	</cfif>
</cffunction>
<!--- Deliver A File --->
<cffunction name="DeliverFile" access="private" returntype="void" hint="Cfcontent a file" output="false" >
	<cfargument name="filename" required="true" type="string" hint="">
	<cfargument name="filepath" required="true" type="string" hint="">
	<cfheader name="Content-Disposition" value="attachment; filename=#arguments.filename#">
		<cfcontent type="unknown" file="#arguments.filepath#">
		<cfabort>
</cffunction>