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
<cfcomponent hint="renders <messagebox> tags" extends="AbstractXMLTag" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MessageBox" output="false">
	<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfscript>
		super.init("messagebox",arguments.configService);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="doStartTag" hint="does the execution of when the tag is opened" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		var replace = "";

		if(arguments.tag eq "<messagebox>" OR findNoCase("info", arguments.tag))
		{
			replace = '<div class="cbox_messagebox_info"><p class="cbox_messagebox">';
		}
		else if(findNoCase("warning", arguments.tag))
		{
			replace = '<div class="cbox_messagebox_warning"><p class="cbox_messagebox">';
		}
		else if(findNoCase("error", arguments.tag))
		{
			replace = '<div class="cbox_messagebox_error"><p class="cbox_messagebox">';
		}

		arguments.builder.replace(arguments.matcher.start(), arguments.matcher.end(), replace);
	</cfscript>
</cffunction>

<cffunction name="doEndTag" hint="does the execution of when the tag is closed" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		var replace = "</p></div>";

		arguments.builder.replace(arguments.matcher.start(), arguments.matcher.end(), replace);
	</cfscript>
</cffunction>

<cffunction name="doFinish" hint="does final piece, after the rendering, and returns an optional Renderable / array of renderable objects" access="private" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		arguments.renderable.setContent(builder.toString());
	</cfscript>
</cffunction>


</cfcomponent>