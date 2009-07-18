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
<cfcomponent hint="This class takes care of converting html to wiki syntaxes" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cfscript>
		instance = structnew();
		
		/* Pulic constants */
		instance.WIKIPEDIA = "info.bliki.html.wikipedia.ToWikipedia";
		instance.GOOGLECODE = "info.bliki.html.googlecode.ToGoogleCode";
		instance.TRAC = "info.bliki.html.googlecode.ToTrac";
		instance.MOINMOIN = "info.bliki.html.googlecode.ToMoinMoin";
		instance.JSPWIKI = "info.bliki.html.jspwiki.ToJSPWiki";						
	</cfscript>
	
	<cffunction name="init" hint="Constructor" access="public" returntype="HTML2WikiConverter" output="false">
		<cfargument name="javaLoader" type="codex.model.util.JavaLoader" required="true" hint="The java loader object"/>
		<cfscript>
			
			/* Setup Translators */
			instance.translators = "WIKIPEDIA,GOOGLECODE,JSPWIKI,MOINMOIN,TRAC";
			
			setJavaLoader(arguments.javaLoader);
			
			return this;
		</cfscript>
	</cffunction>
	
	<!--- getTranslators --->
	<cffunction name="getTranslators" output="false" access="public" returntype="string" hint="Get the list of translators available">
		<cfreturn instance.translators>
	</cffunction>
	
	<!--- toWiki --->
	<cffunction name="toWiki" output="false" access="public" returntype="string" hint="Convert an HTML string to wiki syntax">
		<cfargument name="wikiTranslator" type="string" required="true" hint="The wiki syntax to use. It must be using a valid translator. See getTranslators()"/>
		<cfargument name="htmlString" type="string" required="true" hint="The html string to convert"/>
		<cfscript>
			var translatorRegex = replace(getTranslators(),",","|","all");
			var converter = 0;
			var translator = 0;
			
			/* Validate incoming translator syntax */
			if( NOT reFindNoCase("^(#translatorRegex#)$",arguments.wikiTranslator) ){
				getUtil().$throw(message="Invalid Wiki Translator",
								detail="The translator you sent in #arguments.wikiTranslator# is not valid.  Valid translators are #getTranslators()#",
								type="HTML2WikiConverter.InvalidTranslatorException");
			}
			
			/* create converter */
			converter = getJavaLoader().create("info.bliki.html.HTML2WikiConverter").init(arguments.htmlString);
			/* Create Syntax Translator */
			translator = getJavaLoader().create(instance[arguments.wikiTranslator]).init();
			
			return converter.toWiki(translator);
		</cfscript>		
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<!--- Get/Set Java Loader --->
	<cffunction name="getjavaLoader" access="private" returntype="codex.model.util.JavaLoader" output="false">
		<cfreturn instance.javaLoader>
	</cffunction>
	<cffunction name="setjavaLoader" access="private" returntype="void" output="false">
		<cfargument name="javaLoader" type="codex.model.util.JavaLoader" required="true">
		<cfset instance.javaLoader = arguments.javaLoader>
	</cffunction>
	
	<!--- Get/Set Config Service --->
	<cffunction name="getconfigService" access="private" returntype="codex.model.wiki.ConfigService" output="false">
		<cfreturn instance.configService>
	</cffunction>
	<cffunction name="setconfigService" access="private" returntype="void" output="false">
		<cfargument name="configService" type="codex.model.wiki.ConfigService" required="true">
		<cfset instance.configService = arguments.configService>
	</cffunction>
	
	<!---  Get the Utility Object. --->
	<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
		<cfreturn CreateObject("component","codex.model.util.Utility")>
	</cffunction>

</cfcomponent>
