<!--- Helper for showing page root --->
<cffunction name="pageShowRoot" access="public" returntype="string" hint="The page root" output="false" >
	<cfreturn getSetting('sesBaseURL') & "/" & getSetting('showKey') & "/">
</cffunction>