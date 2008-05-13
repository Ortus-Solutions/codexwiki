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