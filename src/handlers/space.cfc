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
<cfcomponent extends="baseHandler"
			 output="false"
			 hint="This is our main page handler"
			 autowire="true"
			 cache="true" cacheTimeout="0">

	<!--- dependencies --->
	<cfproperty name="WikiService" 		type="ioc" scope="instance" />


<!------------------------------------------- IMPLICIT ------------------------------------------>



<!------------------------------------------- PUBLIC ------------------------------------------>
	
	<!--- viewer --->
	<cffunction name="viewer" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			event.paramValue("namespace","");
			
			// CSS & JS
			rc.jsAppendList = 'jquery.uitablefilter';
			
			
			// Check if Default Namespace or Not?
			if( len(rc.namespace) ){
				// Get All Pages for the incoming namespace
				rc.qPages = getWikiService().getPages(namespace=rc.namespace);
			}
			else{
				// Get All Pages for the default namespace
				rc.qPages = getWikiService().getPages(defaultNamespace=true);
			}
			
			// Page Title
			rc.pageTitle = "Namespace Viewer For: #rc.namespace#";
			
			event.setView(name='space/viewer',nolayout=event.getValue("nolayout",false));
		</cfscript>
	</cffunction>
	
	<!--- directory --->
	<cffunction name="directory" access="public" returntype="void" output="false" hint="Pages Directory">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var rc = event.getCollection();
			var ids = "";
			var qDefault = 0;

			// Required
			rc.jsAppendList = 'jquery.uitablefilter';
			
			// Get All Namespaces
			rc.qNameSpaces = getWikiService().getNamespaces();
			
			event.setView('space/directory');
		</cfscript>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------>

	<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
		<cfreturn instance.wikiService />
	</cffunction>

	
</cfcomponent>