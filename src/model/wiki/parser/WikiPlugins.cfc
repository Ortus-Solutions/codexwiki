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
<cfcomponent hint="renders <plugin> tags" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	instance=structnew();
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="WikiPlugins" output="false">
	<cfargument name="ColdBoxController" type="coldbox.system.controller" required="true" hint="The coldbox Controller, needed to create plugins and settings."/>
	<cfscript>
		/* Setup the coldbox controller */
		instance.controller = arguments.ColdBoxController;
		/* Setup WikiPlugins Location */
		instance.WikiPluginsLocation = instance.controller.getSetting("MyPluginsPath") & "/wiki";
		/* Instantiation Path */
		instance.WikiPluginsBasePath = "wiki.";
				
		return this;
	</cfscript>
</cffunction>

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		//do this with Java, as it is fast
		var builder = arguments.renderable.getStringBuilderContent();
		var installedPlugins = getPlugins();
		var pattern = 0;
		var matcher = 0;
		var x = 1;
		var tag = 0;
		var tagXML = 0;
		var replace = 0;
		var pluginDef = structnew();
		var key = 0;
		
		/* Loop Over Wiki Plugins */
		
		for(x=1; x lte installedPlugins.recordcount;x+=1){
			/* This Plugin */
			pluginDef.name = ripExtension(installedPlugins.name[x]);
			/* Prepare Pattern */
			pattern = createObject("java", "java.util.regex.Pattern").compile("\{\{\{#pluginDef.name#[^\}]*\}\}\}");
			/* Match */
			matcher = pattern.matcher(builder);
			/* Loop And Parse */
			while(matcher.find()){
				/* Get Group */
				tag = matcher.group();
				tag = replace(tag,"{{{","<");
				tag = replace(tag,"}}}","/>");
				/* Quotes */
				tag = replace(tag,"&##34;",'"',"all");
				tag = replace(tag,"&##39;","'","all");
				
				try{
					/* Parse it */
					tagXML = xmlParse(tag);
					/* Default Args */
					pluginDef.args = structnew();
					/* Create Arg Collection From Attributes if any */
					if( structKeyExists(tagXML[pluginDef.name], "XMLAttributes") ){
						for(key in tagXML[pluginDef.name].XMLAttributes){
							pluginDef.args[key] = trim(tagXML[pluginDef.name].XMLAttributes[key]);
						}
					}
					/* Add the content Object to the args */
					pluginDef.args.content = arguments.visitData.content;
					/* Render Plugin Call */
					replace = instance.controller.getPlugin(plugin=instance.WikiPluginsBasePath & pluginDef.name,customPlugin=true).renderit(argumentCollection=pluginDef.args);
				}
				catch(Any e){
					replace = "Error parsing plugin definition: #e.message# #e.detail#";
				}
				
				/* Replace where we found the first one. */
				builder.replace(matcher.start(), matcher.end(), replace);
				/* Reset Matcher and Loop */
				matcher.reset();				
			}//end matcher finds.
			
		}//end looping on wiki plugins to find matchings

		/* Set our content back from our builder */
		arguments.renderable.setContent(builder.toString());

		return;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Get Plugins --->
	<cffunction name="getPlugins" access="public" returntype="query" hint="Get the installed plugins" output="false" >
		<cfset var qPlugins = 0>
		
		<cfdirectory action="list" directory="#instance.WikiPluginsLocation#" name="qPlugins" filter="*.cfc">
		
		<cfreturn qPlugins>
	</cffunction>
	
	<!--- Rip Extension --->
	<cffunction name="ripExtension" access="public" returntype="string" output="false" hint="Rip the extension of a filename.">
		<cfargument name="filename" type="string" required="true">
		<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>
	</cffunction>
	
	<!---  Get the Utility Object. --->
	<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
		<cfreturn CreateObject("component","codex.model.util.Utility")>
	</cffunction>

</cfcomponent>