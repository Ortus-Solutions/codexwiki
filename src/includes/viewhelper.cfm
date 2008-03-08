<!--- Helper for showing page root --->
<cffunction name="pageShowRoot" access="public" returntype="string" hint="The page root" output="false" >
	<cfreturn getSetting('sesBaseURL') & "/" & getSetting('showKey') & "/">
</cffunction>

<!--- printTime --->
<cffunction name="printTime" output="false" access="private" returntype="string" hint="Print time in good format">
	<cfargument name="time" 	type="string" required="true" hint=""/>
	<cfargument name="timeType" type="string" required="false" default="NORMAL" hint="SHORT (hh:mm tt), 24 (HH:mm:ss tt), NORMAL (hh:mm:ss tt)"/>
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
	<cfargument name="dateType" type="string" required="false" default="SHORT" hint="SHORT (mmm/dd/yyyy), FULL (dddd, mmmm dd, yyyy)"/>
	<cfif arguments.dateType eq "SHORT">
		<cfreturn dateFormat(arguments.datetime, "mmm/dd/yyyy")>
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