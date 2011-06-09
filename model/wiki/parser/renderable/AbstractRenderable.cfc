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
<cfcomponent hint="Abstract base class for renderable objects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getIsDynamic" access="public" returntype="boolean" output="false">
	<cfreturn instance.isDynamic />
</cffunction>

<cffunction name="render" hint="renders the output" access="public" returntype="string" output="false">
	<cfthrow type="codex.VirtualMethodException" message="This method is virtual and must be overwritten">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="AbstractRenderable" output="false">
	<cfargument name="isDynamic" hint="is this dynamic content" type="boolean" required="Yes">
	<cfscript>
		setIsDynamic(arguments.isDynamic);

		return this;
	</cfscript>
</cffunction>

<cffunction name="setIsDynamic" access="private" returntype="void" output="false">
	<cfargument name="isDynamic" type="boolean" required="true">
	<cfset instance.isDynamic = arguments.isDynamic />
</cffunction>

<!---  Get the Utility Object. --->
<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
	<cfreturn CreateObject("component","codex.model.util.Utility")>
</cffunction>

</cfcomponent>