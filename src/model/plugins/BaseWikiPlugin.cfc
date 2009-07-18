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
<cfcomponent name="BaseWikiPlugin" 
			 hint="The base wiki plugin" 
			 extends="coldbox.system.plugin" 
			 output="false"
			 autowire="true">

	<!--- Autowired Dependencies --->  
	<cfproperty name="PluginService" type="ioc" scope="instance">
	<cfproperty name="ConfigService" type="ioc" scope="instance">
	<cfproperty name="WikiService" 	 type="ioc" scope="instance">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="BaseWikiPlugin" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
	  		super.Init(arguments.controller);
	  		
	  		/* Codex Plugin Marker */
	  		this.CodexPlugin = true;
	  		
	  		/* Extra Base Plugin Information */
	  		instance.pluginAuthor = "";
	  		instance.pluginAuthorURL = "";
	  		instance.pluginURL = "";
	  			 	
	  		//Return instance
	  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- UTILITY METHODS ------------------------------------------->	
	
	<!--- registerInterceptions --->
	<cffunction name="registerPluginPoints" output="false" access="public" returntype="void" hint="Register interception points for this plugin, so they can interact with Codex.  You can pass a list of plugin points the plugin implements or let the routines inspect the plugin for 'pluginpoint' metadata on functions">
		<cfargument name="pluginPoints" type="string" required="false" default="" hint="A comma-delimmitted list of interceptions to register for this plugin. It will also check the metadata of the functions for a 'pluginpoint' annotation"/>
		<cfscript>
			var points = arguments.pluginPoints;
			var fncArray = getMetadata(this).functions;
			var interceptorService = instance.controller.getInterceptorService();
			var x = 1;
			
			/* Inspect plugins functions for the pluginpoint annotation */
			for(x; x lte ArrayLen(fncArray); x++){
				if( structKeyExsits(fncArray[x], "pluginpoint") ){
					listAppend(points, fncArray[x].name);
				}
			}
			
			/* Register The interception points with ColdBox */
			interceptorService.registerInterceptor(interceptorObject=this,customPoints=points);			
		</cfscript>
	</cffunction>
	
	<!--- getPluginPath --->
	<cffunction name="getPluginPath" output="false" access="private" returntype="string" hint="The url path to this plugin">
		<cfscript>
			var baseURL = instance.controller.getSetting('sesBaseURL');
			
			return baseURL & "/plugins/wiki/" & listFirst(getFileFromPath(getPluginPath()),".");
		</cfscript>
	</cffunction>
	
	<!--- getBaseURL --->
	<cffunction name="getBaseURL" output="false" access="private" returntype="string" hint="Get the base URL path of the wiki">
		<cfreturn  instance.controller.getSetting('sesBaseURL')>
	</cffunction>
	
	<!--- Get the Rewrite Extension --->
	<cffunction name="getRewriteExtension" access="private" returntype="string" hint="Get the rewrite extension used" output="false" >
		<cfreturn instance.ConfigService.getrewriteExtension()>
	</cffunction>
	
	<!--- isUsingRewrite --->
	<cffunction name="isUsingRewrite" output="false" access="private" returntype="boolean" hint="Flag to denote if using the full url rewrite or onMissingTemplate action">
		<cfreturn instance.controller.getSetting("usingRewrite")>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<!--- renderit --->
	<cffunction name="renderit" output="false" access="public" returntype="any" hint="The way to render within wiki text">
	</cffunction>
	
	<!--- Author --->
	<cffunction name="getpluginAuthor" access="public" returntype="string" output="false">
		<cfreturn instance.pluginAuthor>
	</cffunction>
	<cffunction name="setpluginAuthor" access="public" returntype="void" output="false">
		<cfargument name="pluginAuthor" type="string" required="true">
		<cfset instance.pluginAuthor = arguments.pluginAuthor>
	</cffunction>
   
	<!--- Author URL --->
	<cffunction name="getpluginAuthorURL" access="public" returntype="string" output="false">
		<cfreturn instance.pluginAuthorURL>
	</cffunction>
	<cffunction name="setpluginAuthorURL" access="public" returntype="void" output="false">
		<cfargument name="pluginAuthorURL" type="string" required="true">
		<cfset instance.pluginAuthorURL = arguments.pluginAuthorURL>
	</cffunction>
	
	<!--- Plugin URL --->
	<cffunction name="getpluginURL" access="public" returntype="string" output="false">
		<cfreturn instance.pluginURL>
	</cffunction>
	<cffunction name="setpluginURL" access="public" returntype="void" output="false">
		<cfargument name="pluginURL" type="string" required="true">
		<cfset instance.pluginURL = arguments.pluginURL>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	<!--- Get the Wiki Service --->
	<cffunction name="getWikiService" access="private" returntype="any" output="false" hint="Get the wiki service">
		<cfreturn instance.WikiService>
	</cffunction>
	
	<!--- Get the config services --->
	<cffunction name="getConfigService" access="private" returntype="any" output="false" hint="Get the config service"> 
		<cfreturn instance.ConfigService>
	</cffunction>
	
	<!--- Get the plugin Service --->
	<cffunction name="getPluginService" access="private" returntype="any" output="false" hint="Get the plugin service">
		<cfreturn instance.PluginService>
	</cffunction>
	
</cfcomponent>