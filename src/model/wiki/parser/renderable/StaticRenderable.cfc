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
<cfcomponent hint="Renders static content" extends="AbstractRenderable" output="false">
<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="StaticRenderable" output="false">
	<cfargument name="content" hint="the content to initialise this with" type="string" required="Yes">
	<cfscript>
		super.init(false);

		setContent(arguments.content);

		return this;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders the output" access="public" returntype="string" output="false">
	<cfreturn getContent() />
</cffunction>

<cffunction name="getContent" access="public" returntype="string" output="false">
	<cfreturn instance.Content />
</cffunction>

<cffunction name="setContent" access="public" returntype="void" output="false">
	<cfargument name="Content" type="string" required="true">
	<cfset instance.Content = arguments.Content />
</cffunction>

<cffunction name="getStringBuilderContent" hint="gets the Content in a java.lang.StringBuffer" access="public" returntype="any" output="false">
	<cfscript>
		return createObject("java", "java.lang.StringBuffer").init(getContent());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>