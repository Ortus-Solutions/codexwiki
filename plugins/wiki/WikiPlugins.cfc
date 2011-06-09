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
<cfcomponent name="WikiPlugins" 
			 hint="A wiki plugin to interact with installed plugins." 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="WikiPlugins" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("WikiPlugins");
  		setpluginVersion("1.0");
  		setpluginDescription("This plugin will help you document all the installed wiki plugins in the system. It is also used to install and remove wiki plugins.");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.coldbox.org");
  		setPluginURL("http://www.codexwiki.org");
  		
  		/* Prepare Properties */
  		instance.wikiPluginsPath = getSetting("MyPluginsPath") & "/wiki";
  		instance.loadedPlugins = 0;
  		
  		/* Load Plugins */
  		loadPlugins();
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		<cfargument name="title" type="string" required="true" default="Installed Plugins" hint="A default title for the h2"/>
		<cfset var qPlugins = instance.loadedPlugins>
		<cfset var content = "" />
		<cfset var thisPlugin = "">
		<cfset var thisMD = "">
		<cfset var oPlugin = 0>
		<Cfset var args = ArrayNew(1)>
				
		
		<cfsavecontent variable="content">
		<cfoutput>
		<h2>#arguments.title#</h2>
		<p>Below is a listing of all installed plugins that can be found in the following directory:
			<em>#instance.wikiPluginsPath#</em>
		</p>
		<ul>
		<cfloop query="qPlugins">
			<cfset thisPlugin = "wiki." & ripExtension(name)>
			<cfset oPlugin = getMyPlugin(thisPlugin)>
			<cfset thisMD = getMetadata(oPlugin.renderit)>
			<cfset args = thisMD.parameters>
			
			<li><strong>#ripExtension(name)#</strong><br />
				<ul>
					<li><strong>Version:</strong> #oPlugin.getpluginVersion()# </li>
					<li><strong>Description:</strong> #oPlugin.getPluginDescription()#</li>
					<li><strong>Hint: </strong> <cfif structKeyExists(thisMD,"hint")>#thisMD.hint#<cfelse>N/A</cfif></li>
					<li><strong>Renderit Arguments: </strong>
						<cfif ArrayLen(args)>
							<table class="tablelisting" width="95%">
								<tr>
									<th>Argument</th>
									<th>Type</th>
									<th>Required</th>
									<th>Default Value</th>
									<th>Hint</th>
								</tr>
							<cfloop array="#args#" index="i">
								<tr>
									<td>#i.name#</td>
									<td><cfif structKeyExists(i,"type")>#i.type#<cfelse>Any</cfif></td>
									<td><cfif structKeyExists(i,"required")>#i.required#<cfelse>true</cfif></td>
									<td><cfif structKeyExists(i,"default")>#i.default#</cfif></td>
									<td><cfif structKeyExists(i,"hint")>#i.hint#</cfif></td>
								</tr>
							</cfloop>
							</table>
						<cfelse>
							No arguments defined
						</cfif>	
					</li>
				</ul>
			</li>
			<br />
		</cfloop>
		</ul>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content> 
	</cffunction>
	
	<!--- loadPlugins --->
	<cffunction name="loadPlugins" output="false" access="public" returntype="void" hint="Load the plugins">
		
		<cflock name="wikiPlugins.loadPlugins" timeout="5" throwontimeout="true">
			<cfset instance.loadedPlugins = getPlugins()>
		</cflock>
		
	</cffunction>
	
	<!--- getPlugins --->
	<cffunction name="getPlugins" output="false" access="public" returntype="query" hint="Get the installed plugins query.">
		<cfset var qPlugins = 0>
		<cfdirectory action="list" name="qPlugins" directory="#instance.wikiPluginsPath#" filter="*.cfc" sort="asc">
		<cfreturn qPlugins>
	</cffunction>
	
	<!--- uploadPlugin --->
	<cffunction name="uploadPlugin" output="false" access="public" returntype="void" hint="Upload a new wiki plugin">
		<cfargument name="fileField" type="string" required="true" default="" hint="The field name for the file to upload"/>
		
		<cfset var pluginDestination = instance.wikiPluginsPath>
		
		<cffile action="upload"
			    destination="#pluginDestination#"
			    filefield="#arguments.fileField#"
			    nameConflict="Overwrite">
	</cffunction>
	
	<!--- removePlugin --->
	<cffunction name="removePlugin" output="false" access="public" returntype="boolean" hint="Remove the passed in plugin">
		<cfargument name="pluginName" type="string" required="true" default="" hint="The name of the plugin to remove"/>
		<cfset var pluginPath = instance.wikiPluginsPath & "/" & arguments.pluginName & ".cfc">
		
		<!--- Verify it --->
		<cfif fileExists(pluginPath)>
			<cfset fileDelete(pluginPath)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	<!--- Rip Extension --->
	<cffunction name="ripExtension" access="public" returntype="string" output="false" hint="Rip the extension of a filename.">
		<cfargument name="filename" type="string" required="true">
		<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>
	</cffunction>
	
</cfcomponent>