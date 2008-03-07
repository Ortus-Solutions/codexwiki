<cfcomponent name="baseHandler" extends="coldbox.system.eventhandler" output="false" hint="This is our main base handler" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

	<cffunction name="setNextRoute" access="package" returntype="void" hint="Relocate to the next wiki page" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="route"  	hint="The route to relocate to, do not prepend the baseURL or /." type="string" required="yes" >
		<cfargument name="persist" 	hint="What request collection keys to persist in the relocation" required="false" type="string" default="">
		<cfargument name="qs"  		hint="The query string to append" type="string" required="false" default="" >
		
		<!--- ************************************************************* --->
		<cfset var newRoute = arguments.route & ".cfm">
		<cfif len(qs)>
			<cfset newRoute = newRoute & "?" & arguments.qs>
		</cfif>
		<cfset getController().setNextRoute(route=newRoute,persist=arguments.persist)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>