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
<cfcomponent name="plugins"
			 extends="codex.handlers.baseHandler"
			 output="false"
			 hint="Our plugins handler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="ConfigService" type="ioc" scope="instance">
	<cfproperty name="WikiService"	 type="ioc" scope="instance">
	<cfproperty name="UserService"	 type="ioc" scope="instance">
	
<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- list --->
	<cffunction name="list" access="public" returntype="void" output="false" hint="List all installed plugins">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			/* Exit Handlers */
			rc.xehRemove = "admin.plugins.remove";
			rc.xehReload = "admin.plugins.reload";
			rc.xehUpload = "admin.plugins.upload";
			
			/* Plugin */
			rc.oWikiPlugin = getMyPlugin("wiki.WikiPlugins");
			rc.qPlugins = rc.oWikiPlugin.getPlugins();
			
			/* JS */
			rc.jsAppendList = "jquery.simplemodal,confirm";
	
			event.setView('admin/plugins/list');
		</cfscript>
	</cffunction>
	
	<!--- Docs --->
	<cffunction name="docs" access="public" returntype="void" output="false" hint="List all installed plugins">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			event.setView('admin/plugins/docs');
		</cfscript>
	</cffunction>
	
	<!--- remove --->
	<cffunction name="Remove" access="public" returntype="void" output="false" hint="Remove a plugin">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfset var oPlugin = getMyPlugin("wiki.WikiPlugins")>
		<cfscript>	
		
			/* Upload File */
			oPlugin.removePlugin(rc.plugin);
			oPlugin.loadPlugins();
			
			/* Setup */
			getPlugin("messagebox").setMessage(type="info", message="Plugin Removed Successfully");
			
			/* ReRoute */
			setNextRoute(route="admin/plugins/list");
		</cfscript>
	</cffunction>
	
	<!--- upload --->
	<cffunction name="Upload" access="public" returntype="void" output="false" hint="Upload a new plugin">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfset var oPlugin = getMyPlugin("wiki.WikiPlugins")>
		<cfscript>	
			/* Verify */
			if( len(event.getTrimValue('filePlugin')) eq 0){
				getPlugin("messagebox").setMessage(type="warning", message="Please choose a file to upload");
			}
			else if( listLast(event.getTrimValue("filePlugin"),".") neq "cfc" ){
				getPlugin("messagebox").setMessage(type="warning", message="Only cfc uploads are allowed");
			}
			else{
				/* Upload File */
				oPlugin.uploadPlugin('filePlugin');
				oPlugin.loadPlugins();
				/* Setup */
				getPlugin("messagebox").setMessage(type="info", message="Plugin Installed Successfully");
			}
			
			setNextRoute(route="admin/plugins/list");
		</cfscript>
	</cffunction>
	
	<!--- reload --->
	<cffunction name="reload" access="public" returntype="void" output="false" hint="Reload Plugins">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			getMyPlugin("wiki.WikiPlugins").loadPlugins();
			
			getPlugin("messagebox").setMessage(type="info", message="WikiPlugins has refreshed its internal plugins cache.");
			
			setNextRoute(route='admin/plugins/list');
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