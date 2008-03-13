<cfcomponent name="main" 
			 extends="codex.handlers.baseHandler" 
			 output="false" 
			 hint="Our main handler for the admin.">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<cffunction name="home" access="public" returntype="void" output="false">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			
			event.setView('admin/home');
		</cfscript>
	</cffunction>
	
	

<!------------------------------------------- PRIVATE ------------------------------------------->

	

</cfcomponent>