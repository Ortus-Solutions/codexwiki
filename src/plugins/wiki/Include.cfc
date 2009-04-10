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
<cfcomponent name="Include" 
			 hint="A plugin to include other wiki pages as content" 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="true">

	<!--- Dependencies --->  
	<cfproperty name="WikiService" type="ioc" scope="instance" />

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Include" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Include");
  		setpluginVersion("1.0");
  		setpluginDescription("A plugin to include other wiki pages as content.");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.coldbox.org");
  		setPluginURL("http://www.codexwiki.org");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="Include other pages as content, all you need is the page name to include. If the page name does not exist, it will be replaced with a message saying the page does not exist">
		<cfargument name="page" type="string" required="true" default="" hint="The page name to render content"/>
		<cfargument name="args" type="string" required="true" default="" hint="The name-value pairs for token replacements, please add the values in single quotes. Ex: name='luis',age='20'. The name will be replaced in the template by looking at {{{[name]}}} and {{{[age]}}} token."/>
		<cfscript>
			var pageContent = 0;
			var content = 0;
			var x = 1;
			
			/* Get the Page's Content */
			pageContent = instance.WikiService.getContent(pageName=trim(arguments.page));
			/* Try to see if page exists */
			if( pageContent.getIsPersisted() ){
				/* Return rendered content */
				content = pageContent.render();
				/* Do arg Replacements */
				for(x=1; x lte ListLen(args);x++){
					/* Get argument */
					thisArg = ListGetAt(args,x);
					/* replacement */
					content = replacenocase(content,"{{{[#getToken(thisArg,1,"=")#]}}}", replace(getToken(thisArg,2,"="),"'","","all"),"all");
				}
			}
			else{
				content = "Page: #arguments.page# does not exist";
			}
			/* return content */
			return content;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>