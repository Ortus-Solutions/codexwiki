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
<cfcomponent name="Config"
			 output="false"
			 hint="Config Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="ConfigService" type="ioc" scope="instance">
	<cfproperty name="WikiService"	 type="ioc" scope="instance">
	<cfproperty name="UserService"	 type="ioc" scope="instance">
	
<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- custom html --->
	<cffunction name="customhtml" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			rc.xehonSubmit = "admin/config/savecustomhtml"; 
			
			rc.jsAppendList = "jquery.textarearesizer.compressed";
			
			rc.oCustomHTML = getConfigService().getCustomHTML();
			
			/* Set View */
			event.setView('admin/config/customhtml');
		</cfscript>
	</cffunction>
	
	<!--- custom html --->
	<cffunction name="savecustomhtml" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any">
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
			setNextRoute('admin/config/customhtml');
		</cfscript>
	</cffunction>

	<!--- options --->
	<cffunction name="options" access="public" returntype="void" output="false" hint="Wiki options">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var rc = event.getCollection();	
			
			/* Exit Handlers */
			rc.xehOnSubmit = "admin/config/saveoptions";
			
			/* Required */
			rc.jsAppendList = 'formvalidation,jquery.uitablefilter';
			/* Get All Pages */
			rc.qPages = getWikiService().getPages();	
			/* Get All Roles */
			rc.qRoles = getUserService().getAllRoles();
			
			/* Set View */
			event.setview('admin/config/options');	
		</cfscript>    
	</cffunction>
	
	<!--- saveOptions --->
	<cffunction name="saveOptions" access="public" returntype="void" output="false" hint="Save wiki options">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>	
			var rc = event.getCollection();
			var oOption = 0;
			var newOptions = structnew();
			
			/* Loop and Save Options */
			for(key in rc.CodexOptions){
				/* Get Option */
				oOption = instance.ConfigService.getOption(name=key);
				/* Populate it */
				if( structKeyExists(rc,key) ){
					oOption.setValue(rc[key]);
					newOptions[key] = rc[key];
					/* Save */
					instance.ConfigService.save(oOption);	
				}
				else
				{
					//need an else, otherwise, settings can go missing
					newOptions[key] = oOption.getValue();
				}
				
			}
			/* Re-Cache */
			getColdboxOCM().set("CodexOptions",newOptions,0);
			/* Mb */
			getPlugin("messagebox").setMessage(type="info", message="Options Saved and Re-Cached");
			/* Re-Route */
			setNextRoute(route="admin/config/options");
		</cfscript>
	</cffunction>
	
	<!--- comments --->
	<cffunction name="comments" access="public" returntype="void" output="false" hint="Wiki Comment Options">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var rc = event.getCollection();	
			
			/* Exit Handlers */
			rc.xehOnSubmit = "admin/config/savecomments";
			
			/* Required */
			rc.jsAppendList = 'formvalidation,jquery.uitablefilter';
			
			/* Set View */
			event.setview('admin/config/comments');	
		</cfscript>    
	</cffunction>
	
	<!--- saveOptions --->
	<cffunction name="savecomments" access="public" returntype="void" output="false" hint="Save comment wiki options">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>	
			var rc = event.getCollection();
			var oOption = 0;
			var newOptions = structnew();
			
			/* Loop and Save Options */
			for(key in rc.CodexOptions)
			{
				/* Get Option */
				oOption = instance.ConfigService.getOption(name=key);

				/* Populate it */
				if(StructKeyExists(rc, key))
				{
					oOption.setValue(rc[key]);
					newOptions[key] = rc[key];
				}
				else
				{
					newOptions[key] = oOption.getValue();
				}
				
					/* Save */
				instance.ConfigService.save(oOption);	
			}
			/* Re-Cache */
			getColdboxOCM().set("CodexOptions",newOptions,0);
			/* Mb */
			getPlugin("messagebox").setMessage(type="info", message="Options Saved and Re-Cached");
			/* Re-Route */
			setNextRoute(route="admin/config/comments");
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="getConfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">
		<cfreturn instance.ConfigService />
	</cffunction>
	
	<cffunction name="getWikiService" access="public" returntype="codex.model.wiki.WikiService" output="false">
		<cfreturn instance.WikiService>
	</cffunction>
	
	<cffunction name="getUserService" access="public" output="false" returntype="codex.model.security.UserService" hint="Get UserService">
		<cfreturn instance.UserService/>
	</cffunction>

</cfcomponent>