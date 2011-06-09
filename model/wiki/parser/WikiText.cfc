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
<cfcomponent hint="the media wiki parser" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiText" output="false">
	<cfargument name="configService" hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfargument name="javaLoader" type="codex.model.util.JavaLoader" required="true" hint="The java loader object"/>
	<cfscript>
		variables.instance = StructNew();
		instance.configService = arguments.configService;
		instance.javaLoader = arguments.javaLoader;
		instance.rewriteExtension = instance.configService.getRewriteExtension();
		
		// Setup the parser patterns
		setWikiBase(arguments.configService.getSetting("ShowKey") & "/");
		setLinkPattern(arguments.configService.getSetting("ShowKey") & "/${title}#instance.rewriteExtension#");
		setCodexBase(arguments.configService.getSetting('sesBaseURL'));
		
		// this will eventually get replaced when we implement images
		setImagePattern("image/${image}#instance.rewriteExtension#");

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configuration method for configuraiton by the listener" access="public" returntype="void" output="false">
	<cfargument name="ignoreXMLTagList" hint="the list of xml tags to ignore" type="string" required="No" default="">
	<cfargument name="allowedAttributes" hint="the list of extra attributes that are allowed in html tags" type="string" required="No" default="">
	<cfscript>
		var config = getJavaLoader().create("info.bliki.wiki.model.Configuration").init();
		var TagNode = getJavaLoader().create("info.bliki.wiki.tags.HTMLTag");
		var xmlTag = 0;
		var attrib = 0;
	</cfscript>

	<cfloop list="#arguments.allowedAttributes#" index="attrib">
		<cfscript>
			TagNode.addAllowedAttribute(attrib);
		</cfscript>
	</cfloop>
	<cfloop list="#arguments.ignoreXMLTagList#" index="xmlTag">
		<cfscript>
			config.addTokenTag(xmlTag, getJavaLoader().create("info.bliki.htmlcleaner.TagNode").init(xmlTag));
		</cfscript>
	</cfloop>
	<cfscript>
		//this tells the parser to ignore these XML tags
		config.addCodeFormatter("coldfusion", getJavaLoader().create("com.codexwiki.bliki.codeFilter.ColdFusionCodeFilter").init());
		
		/* Interwiki link to itself */
		config.addInterwikiLink("codex",getCodexBase() & "/${title}");
		
		setConfiguration(config);
	</cfscript>
</cffunction>

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		var model = createModel(arguments.visitData.content);
		var contentToRender = arguments.renderable.getContent();
		
		/* Cleanup {{{ }}} for <nowiki> */
		contentToRender = REplace(contentToRender,"{{{","<nowiki>{{{","all");
		contentToRender = REplace(contentToRender,"}}}","}}}</nowiki>","all");
		
		/* Here is where the magic happens, we render the wiki text */
		arguments.renderable.setContent(model.render(contentToRender));

		if(NOT StructKeyExists(arguments.visitData, "categories"))
		{
			arguments.visitData.categories = createObject("java", "java.util.ArrayList").init();
		}

		//use java, it's fast
		//bastards changed the category collectin from a Set to a Map.
		arguments.visitData.categories.addAll(model.getCategories().keySet());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getjavaLoader" access="private" returntype="codex.model.util.JavaLoader" output="false">
	<cfreturn instance.javaLoader>
</cffunction>
<cffunction name="setjavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="codex.model.util.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader>
</cffunction>

<cffunction name="createModel" hint="creates a info.bliki.model.WikiModel" access="private" returntype="any" output="false">
	<cfargument name="content" hint="the content that this page is being created for" type="codex.model.wiki.Content" required="Yes">
	<cfreturn getJavaLoader().create("com.codexwiki.bliki.model.WikiModel").init(getConfiguration(), "/${image}", getLinkPattern(),
																				getWikiBase() & arguments.content.getPage().getName() & instance.rewriteExtension) />
</cffunction>

<cffunction name="getLinkPattern" access="private" returntype="string" output="false">
	<cfreturn instance.linkPattern />
</cffunction>

<cffunction name="setLinkPattern" access="private" returntype="void" output="false">
	<cfargument name="linkPattern" type="string" required="true">
	<cfset instance.linkPattern = arguments.linkPattern />
</cffunction>

<cffunction name="getImagePattern" access="private" returntype="string" output="false">
	<cfreturn instance.imagePattern />
</cffunction>

<cffunction name="setImagePattern" access="private" returntype="void" output="false">
	<cfargument name="imagePattern" type="string" required="true">
	<cfset instance.imagePattern = arguments.imagePattern />
</cffunction>

<!--- wiki parser java config object --->
<cffunction name="getConfiguration" access="private" returntype="any" output="false">
	<cfreturn instance.Configuration />
</cffunction>

<cffunction name="setConfiguration" access="private" returntype="void" output="false">
	<cfargument name="Configuration" type="any" required="true">
	<cfset instance.Configuration = arguments.Configuration />
</cffunction>

<cffunction name="getWikiBase" access="private" returntype="string" output="false">
	<cfreturn instance.wikiBase />
</cffunction>

<cffunction name="setWikiBase" access="private" returntype="void" output="false">
	<cfargument name="wikiBase" type="string" required="true">
	<cfset instance.wikiBase = arguments.wikiBase />
</cffunction>

<cffunction name="getCodexBase" access="private" returntype="string" output="false">
	<cfreturn instance.CodexBase>
</cffunction>
<cffunction name="setCodexBase" access="private" returntype="void" output="false">
	<cfargument name="CodexBase" type="string" required="true">
	<cfset instance.CodexBase = arguments.CodexBase>
</cffunction>

</cfcomponent>