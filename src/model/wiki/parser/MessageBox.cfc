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
<cfcomponent hint="renders <messagebox> tags" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MessageBox" output="false">
	<cfscript>

		return this;
	</cfscript>
</cffunction>

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		//do this with Java, as it is fast
		var builder = arguments.renderable.getStringBuilderContent();
		var pattern = createObject("java", "java.util.regex.Pattern").compile("</?messagebox[^>]*>");
		var matcher = pattern.matcher(builder);
		var tag = 0;
		var replace = 0;

		while(matcher.find())
		{
			tag = matcher.group();
			if(tag eq "<messagebox>" OR findNoCase("info", tag))
			{
				replace = '<div class="cbox_messagebox_info"><p class="cbox_messagebox">';
			}
			else if(findNoCase("warning", tag))
			{
				replace = '<div class="cbox_messagebox_warning"><p class="cbox_messagebox">';
			}
			else if(findNoCase("error", tag))
			{
				replace = '<div class="cbox_messagebox_error"><p class="cbox_messagebox">';
			}
			else if(tag eq "</messagebox>")
			{
				replace = "</p></div>";
			}
			else
			{
				replace = "";
				//if you don't know, just delete it.
			}

			builder.replace(matcher.start(), matcher.end(), replace);

			matcher.reset();
		}


		arguments.renderable.setContent(builder.toString());

		return;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>