<cfcomponent hint="this is the base class for remote facades to extend" extends="coldbox.system.extras.ColdboxProxy" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getIOC" hint="return the IOC container" access="private" returntype="any" output="false">
	<cfreturn getController().getPlugin("ioc") />
</cffunction>

<!--- overwrite it, so it is private --->

<cffunction name="process" output="false" access="private" returntype="any" hint="Process a remote call and return data/objects back.">
	<cfreturn super.process() />
</cffunction>

</cfcomponent>