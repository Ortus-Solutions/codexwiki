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
<cfcomponent hint="Wiki Text translation observer" extends="coldbox.system.interceptor" output="false" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="onDIComplete" hint="the configuration of the wiki" access="public" returntype="void" output="false">
	<cfscript>
		var ignoreXMLTagList = "";
		var allowedAttributes = "";

		if(propertyExists("ignoreXMLTagList"))
		{
			ignoreXMLTagList = getProperty("ignoreXMLTagList");
		}

		if(propertyExists("allowedAttributes"))
		{
			allowedAttributes = getProperty("allowedAttributes");
		}

		getWikiText().configure(ignoreXMLTagList, allowedAttributes);
	</cfscript>
</cffunction>

<cffunction name="onWikiPageTranslate" access="public" returntype="void" hint="Intercept Wiki Page Translation" output="false" >
	<cfargument name="event" required="true" type="coldbox.system.beans.requestContext" hint="The event object.">
	<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
	<cfscript>
		arguments.interceptData.content.visitContent(getWikiText(), arguments.interceptData);
	</cfscript>
</cffunction>

<cffunction name="setWikiText" access="public" returntype="void" output="false">
	<cfargument name="WikiText" type="codex.model.wiki.parser.WikiText" required="true">
	<cfset instance.WikiText = arguments.WikiText />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiText" access="private" returntype="codex.model.wiki.parser.WikiText" output="false">
	<cfreturn instance.WikiText />
</cffunction>

</cfcomponent>