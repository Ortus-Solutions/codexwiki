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
	<cfargument name="configBean" hint="the configuration beam" type="coldbox.system.beans.configBean" required="Yes">
	<cfscript>
		variables.instance = StructNew();
		variables.static = StructNew();
		
		/* Set unique server Key */
		variables.static.SERVER_SCOPE_KEY = hash(arguments.configBean.getKey('ApplicationPath') & "6201BF9B-D46E-52D0-D7023F30A340B7B4");
		
		initJavaLoader();
	
		/* Determine Rewrite */
		if( arguments.configBean.getKey("usingRewrite") ){
			instance.rewriteExtension = "";
		}
		else{
			instance.rewriteExtension = ".cfm";
		}
	
		setWikiBase(arguments.configBean.getKey("ShowKey") & "/");
		setLinkPattern(arguments.configBean.getKey("ShowKey") & "/${title}#instance.rewriteExtension#");


		/* this will eventually get replaced when we implement images */
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
			config.addTokenTag(xmlTag, getJavaLoader().create("org.htmlcleaner.TagNode").init(xmlTag));
		</cfscript>
	</cfloop>
	<cfscript>
		//this tells the parser to ignore these XML tags
		config.addCodeFormatter("coldfusion", getJavaLoader().create("com.codexwiki.bliki.codeFilter.ColdFusionCodeFilter").init());

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

<cffunction name="initJavaLoader" hint="initialised the java loaded in the server scope" access="private" returntype="void" output="false">
	<cfscript>
		var path = getDirectoryFromPath(getMetaData(this).path) & "/lib/bliki/";
		var qFiles = 0;
		var paths = ArrayNew(1);
	</cfscript>

	<cfif NOT StructKeyExists(server, static.SERVER_SCOPE_KEY)>
		<cflock name="codex.model.wiki.parser.WikiText" throwontimeout="true" timeout="60">
			<cfif NOT StructKeyExists(server, static.SERVER_SCOPE_KEY)>
				<cfscript>
					println("putting wikitext javaloader in server scope...");
					path = getDirectoryFromPath(getMetaData(this).path) & "/lib/bliki/";
					paths = ArrayNew(1);
				</cfscript>
				<cfdirectory action="list" filter="*.jar" directory="#path#" name="qFiles">
				<cfloop query="qFiles">
					<cfset ArrayAppend(paths, directory & "/" & name) />
					<cfset println("Loading: #name#") />
				</cfloop>
				<cfset server[static.SERVER_SCOPE_KEY] = createObject("component", "coldbox.system.extras.javaloader.JavaLoader").init(paths) />
			</cfif>
		</cflock>
	</cfif>
</cffunction>
<cffunction name="println" hint="" access="private" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfscript>
		createObject("Java", "java.lang.System").out.println(arguments.str);
	</cfscript>
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldbox.system.extras.javaloader.JavaLoader" output="false">
	<cfreturn server[static.SERVER_SCOPE_KEY] />
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



</cfcomponent>