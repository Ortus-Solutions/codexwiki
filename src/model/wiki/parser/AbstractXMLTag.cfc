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

<cfcomponent hint="Abstract base class for XML tag parsing" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		//do this with Java, as it is fast
		var pattern = createObject("java", "java.util.regex.Pattern").compile("</?#getTagName()#[^>]*>");
		var loopCount = 0;

		arguments.builder = arguments.renderable.getStringBuilderContent();
		arguments.matcher = pattern.matcher(arguments.builder);
		arguments.tag = 0;
		arguments.state = {};

		doStart(argumentCollection=arguments);

		while(arguments.matcher.find())
		{
			arguments.tag = arguments.matcher.group();


			if(arguments.tag eq "</#getTagName()#>")
			{
				doEndTag(argumentCollection=arguments);
			}
			else
			{
				doStartTag(argumentCollection=arguments);
			}

			arguments.matcher.reset();

			loopCount++;

			if(loopCount > 3)
			{
				throw("codexWiki.BuilderTagNotReplacedException",
					"The builder has to have the tag that it was looking for replaced with other content",
					"The tag '#getTagName()#', still exists in content '#arguments.builder.toString()#'");
			}
		}

		return doFinish(argumentCollection=arguments);

	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="AbstractXMLTag" output="false">
	<cfargument name="tagName" 		hint="the tag this parser is looking for" type="string" required="Yes">
	<cfargument name="configBean" 	hint="the configuration beam" type="coldbox.system.beans.configBean" required="Yes">
	<cfscript>
		setTagName(arguments.tagName);
		/* Rewrite Extension */
		if( arguments.configBean.getKey("usingRewrite") ){
			setrewriteExtension('');
		}
		else{
			setrewriteExtension('.cfm');
		}
		return this;
	</cfscript>
</cffunction>

<cffunction name="doStart" hint="does start of rendering, before the tags are found" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<!--- does nothing --->
</cffunction>

<cffunction name="doStartTag" hint="does the execution of when the tag is opened" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<!--- does nothing --->
</cffunction>

<cffunction name="doEndTag" hint="does the execution of when the tag is closed" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<!--- does nothing --->
</cffunction>

<cffunction name="doFinish" hint="does final piece, after the rendering, and returns an optional Renderable / array of renderable objects" access="private" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<!--- does nothing --->
</cffunction>

<cffunction name="getTagName" access="private" returntype="string" output="false">
	<cfreturn instance.tagName />
</cffunction>

<cffunction name="setTagName" access="private" returntype="void" output="false">
	<cfargument name="tagName" type="string" required="true">
	<cfset instance.tagName = arguments.tagName />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

<!---  Get the Utility Object. --->
<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
	<cfreturn CreateObject("component","codex.model.util.utility")>
</cffunction>	

<cffunction name="getrewriteExtension" access="public" output="false" returntype="string" hint="Get rewriteExtension">
	<cfreturn instance.rewriteExtension/>
</cffunction>

<cffunction name="setrewriteExtension" access="public" output="false" returntype="void" hint="Set rewriteExtension">
	<cfargument name="rewriteExtension" type="string" required="true"/>
	<cfset instance.rewriteExtension = arguments.rewriteExtension/>
</cffunction>

</cfcomponent>