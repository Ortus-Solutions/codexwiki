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

	<!--- activateURL --->
	<cffunction name="activateURL" output="false" access="public" returntype="any" hint="Activate URL's">
		<cfargument name="text" type="string">
		<cfreturn REReplaceNoCase(arguments.text, "((https?|ftp):\/\/)([^\s]*)\s?","<a href=""\1\3"">\1\3</a> ", "ALL")>
	</cffunction>

	<cffunction name="sleeper" access="public" returntype="void" output="false" hint="Make the main thread of execution sleep for X amount of seconds.">
		<!--- ************************************************************* --->
		<cfargument name="milliseconds" type="numeric" required="yes" hint="Milliseconds to sleep">
		<!--- ************************************************************* --->
		<cfset CreateObject("java", "java.lang.Thread").sleep(arguments.milliseconds)>
	</cffunction>
	
	<!--- Get File Last Modified --->
	<cffunction name="FileLastModified" access="public" returntype="string" output="false" hint="Get the last modified date of a file">
		<!--- ************************************************************* --->
		<cfargument name="filename" type="string" required="yes">
		<!--- ************************************************************* --->
		<cfscript>
		var objFile =  createObject("java","java.io.File").init(JavaCast("string",arguments.filename));
		// Calculate adjustments fot timezone and daylightsavindtime
		var Offset = ((GetTimeZoneInfo().utcHourOffset)+1)*-3600;
		// Date is returned as number of seconds since 1-1-1970
		return DateAdd('s', (Round(objFile.lastModified()/1000))+Offset, CreateDateTime(1970, 1, 1, 0, 0, 0));
		</cfscript>
	</cffunction>
	
	<!--- Get Absolute Path --->
	<cffunction name="getAbsolutePath" access="public" output="false" returntype="string" hint="Turn any system path, either relative or absolute, into a fully qualified one">
		<!--- ************************************************************* --->
		<cfargument name="path" type="string" required="true" hint="Abstract pathname">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.path));
		if(FileObj.isAbsolute()){
			return arguments.path;
		}
		else{
			return ExpandPath(arguments.path);
		}
		</cfscript>
	</cffunction>
	
<!------------------------------------------- UTILITY METHODS ------------------------------------------->

	<cffunction name="$throw" access="public" hint="Facade for cfthrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="message" 		type="string" 	required="yes">
		<cfargument name="detail" 		type="string" 	required="no" default="">
		<cfargument name="type"  		type="string" 	required="no" default="">
		<cfargument name="extendedinfo" type="any"		required="no" default="">
		<!--- ************************************************************* --->
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#" extendedinfo="#arguments.extendedinfo#">
	</cffunction>
	
	<!--- ReThrow --->
	<cffunction name="$rethrow" access="public" hint="Facade for rethrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="exception" type="any" required="true" hint="The exception object"/>
		<!--- ************************************************************* --->
		<cfthrow object="#arguments.exception#">
	</cffunction>

	
	<cffunction name="$dump" access="public" hint="Facade for cfmx dump" returntype="void">
		<cfargument name="var" required="yes" type="any">
		<cfargument name="abort" type="boolean" required="false" default="false"/>
		<cfdump var="#var#"><cfif arguments.abort><cfabort></cfif>
	</cffunction>

	
	<cffunction name="$abort" access="public" hint="Facade for cfabort" returntype="void" output="false">
		<cfabort>
	</cffunction>

	
<!------------------------------------------- PRIVATE ------------------------------------------->

	

</cfcomponent>