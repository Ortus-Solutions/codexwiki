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
<cfcomponent hint="handler for wiki rss feeds" extends="baseHandler" autowire="true" output="false">

	<!--- Dependencies --->
	<cfproperty name="rssManager" type="ioc" scope="instance" />
	
<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="show" access="public" returntype="void" output="false">
		<cfargument name="event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var rc = arguments.event.getCollection();
	
			rc.rss = getRssManager().getRSS(rc.source, rc.feed, rc);
			
			/* Just render, no need for layout or view. */
			event.renderData(data=rc.rss,contentType="text/xml;UTF-8");
		</cfscript>
	</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getRssManager" access="private" returntype="codex.model.rss.RSSManager" output="false">
		<cfreturn instance.rssManager />
	</cffunction>

</cfcomponent>