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
<cfcomponent name="BaseGateway" hint="A base transfer gateway object" output="false">

<!----------------------------------- CONSTRUCTOR ------------------------------>

	<cfscript>
	instance = structnew();
	</cfscript>

	<cffunction name="init" hint="Constructor" access="public" returntype="any" output="false">
		<!--- ************************************************************* --->
		<cfargument name="transfer" 	type="any" 		required="true" hint="the Transfer ORM factory: transfer.com.Transfer">
		<cfargument name="datasource" 	type="any"	 	required="Yes"  hint="The Datasource object to use, maps to: coldbox.system.beans.datasourceBean" >
		<!--- ************************************************************* --->
		<cfscript>
			/* Setup properties */
			instance.transfer = arguments.transfer;
			instance.datasource = arguments.datasource;
			
			return this;
		</cfscript>
	</cffunction>
	
<!----------------------------------- PUBLIC ------------------------------>

	
<!----------------------------------- PRIVATE ------------------------------>

	<!--- Get Datasource --->
	<cffunction name="getdatasource" access="private" returntype="any" output="false">
		<cfreturn instance.datasource>
	</cffunction>
	
	<!--- Get/set Transfer --->
	<cffunction name="getTransfer" access="private" returntype="any" output="false">
		<cfreturn instance.Transfer>
	</cffunction>

	<!--- Get Utility --->
	<cffunction name="getUtility" output="false" access="private" returntype="any" hint="Utility Method">
		<cfreturn CreateObject("component","codex.util.Utility")>
	</cffunction>

</cfcomponent>