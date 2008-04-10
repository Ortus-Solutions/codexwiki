<cfcomponent name="main" 
			 extends="codex.handlers.baseHandler" 
			 output="false" 
			 hint="Our main handler for the admin.">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!--- Home Page --->
	<cffunction name="home" access="public" returntype="void" output="false">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			
			event.setView('admin/home');
		</cfscript>
	</cffunction>
	
	<!--- api --->
	<cffunction name="api" access="public" returntype="void" output="false" hint="Show the API" cache="true" cacheTimeout="30">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfset var rc = event.getCollection()>
	    <cfscript>
			/* Setup the Cfc Viewer */
			rc.cfcViewer = getPlugin("cfcviewer").setup(dirpath="/codex/model",
														dirLink="#getSetting('sesBaseURL')#/admin.main/api.cfm?");
			
			/* Setup the view */
			event.setView("admin/api");
		</cfscript>    
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	

</cfcomponent>