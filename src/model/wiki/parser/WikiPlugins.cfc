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
		instance.WikiPluginsLocation = "wiki.";
		return this;
	</cfscript>
</cffunction>

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		//do this with Java, as it is fast
		var builder = arguments.renderable.getStringBuilderContent();
		var pattern = createObject("java", "java.util.regex.Pattern").compile("(</?plugin[^>]*/>)");
		var matcher = pattern.matcher(builder);
		var tag = 0;
		var tagXML = 0;
		var replace = 0;
		var pluginDef = structnew();
		var oPlugin = 0;
		
		/* Plugin Declaration <plugin />
			Arguments:
				name = Name of Plugin
				core = true or false for core coldbox plugin
				invoker= the method arg combination
		 */
		
		while(matcher.find())
		{
			tag = matcher.group();
			/* XML Parse it */
			try{
				tagXML = xmlParse(tag);
			}
			catch(Any e){
				getUtil().dump(tag);
				getUtil().dump(e,1);
			}
			getUtil().dump(tag,1);
			/* Verify the name of the plugin, else return nothing */
			if( structKeyExists(tagXML,"XMLAttributes") and 
				structKeyExists(tagXML.XMLAttributes,"name") and 
				structKeyExists(tagXML.XMLAttributes,"invoke")){
				/* Get Core Definition */
				if( structKeyExists(tagXML.XMLAttributes,"core") ){
					pluginDef.core = trim(tagXML.XMLAttributes.core);
					pluginDef.name = trim(tagXML.XMLAttributes.name);
				}
				else{
					pluginDef.core = false;
					pluginDef.name = instance.WikiPluginsLocation & trim(tagXML.XMLAttributes.name);
				}
				/* Get Invoke Definition */
				pluginDef.invoke = trim(tagXML.XMLAttributes.invoke);
				
				/* Get Plugin Object */
				if( pluginDef.core ){
					oPlugin = instance.controller.getPlugin(pluginDef.name);
				}
				else{
					oPlugin = instance.controller.getMyPlugin(pluginDef.name); 
				}
				/* Invoker */
				replace = evaluate('oPlugin.#pluginDef.invoke#');
			}//end if name and method found.
			else{
				replace = "";
			}
			
			/* Replace where we found the first one. */
			builder.replace(matcher.start(), matcher.end(), replace);
			/* Reset the matcher */
			matcher.reset();
		}

		/* Set our content back from our builder */
		arguments.renderable.setContent(builder.toString());

		return;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


<!---  Get the Utility Object. --->
<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
	<cfreturn CreateObject("component","codex.model.util.utility")>
</cffunction>

</cfcomponent>