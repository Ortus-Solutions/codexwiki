<cfcomponent name="baseHandler" extends="coldbox.system.eventhandler" output="false" hint="This is our main base handler" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

	<cffunction name="setNextRoute" access="package" returntype="void" hint="Relocate to the next wiki page" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="route"  			hint="The route to relocate to, do not prepend the baseURL or /." type="string" required="yes" >
		<cfargument name="persist" 			hint="What request collection keys to persist in the relocation" required="false" type="string" default="">
		<!--- ************************************************************* --->
		<cfset var newRoute = arguments.route & ".cfm">
		<cfset getController().setNextRoute(route=newRoute,persist=arguments.persist)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>