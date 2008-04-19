<cfcomponent name="config"
			 extends="codex.handlers.baseHandler"
			 output="false"
			 hint="Our configuration handler"
			 autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- custom html --->
	<cffunction name="customhtml" access="public" returntype="void" output="false">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var rc = event.getCollection();
			
			rc.xehonSubmit = "admin.config/savecustomhtml.cfm"; 
			
			rc.jsAppendList = "jquery.textarearesizer.compressed";
			
			rc.oCustomHTML = getConfigService().getCustomHTML();
			
			/* Set View */
			event.setView('admin/config/customhtml');
		</cfscript>
	</cffunction>
	
	<!--- custom html --->
	<cffunction name="savecustomhtml" access="public" returntype="void" output="false">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var oCustomHTML = "";
			
			/* Get Custom HTML Object */
			oCustomHTML = getConfigService().getCustomHTML();
			/* Populate HTML */
			getPlugin("beanFactory").populateBean(oCustomHTML);
			/* Save it */
			getConfigService().saveCustomHTML(oCustomHTML);
			
			/* mb */
			getPlugin("messagebox").setMessage("info", "Custom HTML Saved!");
			
			/* Re Route */
			setNextRoute('admin.config/customhtml');
		</cfscript>
	</cffunction>

	

<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="getConfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">
		<cfreturn instance.ConfigService />
	</cffunction>

	<cffunction name="setConfigService" access="private" returntype="void" output="false">
		<cfargument name="ConfigService" type="codex.model.wiki.ConfigService" required="true">
		<cfset instance.ConfigService = arguments.ConfigService />
	</cffunction>

</cfcomponent>