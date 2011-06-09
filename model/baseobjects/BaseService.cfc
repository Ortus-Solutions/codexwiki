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
<cfcomponent name="BaseService" hint="A base transfer service object" output="false">

<!----------------------------------- CONSTRUCTOR ------------------------------>

	<cfscript>
	instance = structnew();
	</cfscript>

	<cffunction name="init" hint="Constructor" access="public" returntype="any" output="false">
		<!--- ************************************************************* --->
		<cfargument name="transfer" 	type="any" 		required="true"   hint="the Transfer ORM factory: transfer.com.Transfer">
		<cfargument name="transaction" 	type="any"	 	required="true"   hint="The Transfer transaction: transfer.com.sql.transaction.Transaction" >
		<cfargument name="datasource" 	type="any"	 	required="false"  default="#structnew()#"  hint="The Datasource object to use, maps to: coldbox.system.beans.datasourceBean" >
		<!--- ************************************************************* --->
		<cfscript>
			/* Setup properties */
			instance.transfer = arguments.transfer;
			instance.datasource = arguments.datasource;
			
			/* Transaction the save + deletes */
			arguments.transaction.advise(this, "^save");
			arguments.transaction.advise(this, "^cascade");
			arguments.transaction.advise(this, "^delete");
			
			return this;
		</cfscript>
	</cffunction>
	
<!----------------------------------- PUBLIC ------------------------------>
	
	<cffunction name="save" hint="Save a generic TO" access="public" output="false" returntype="void">
		<!--- ************************************************************* --->
		<cfargument name="genericTO" 	type="any" 		required="true"/>
		<!--- ************************************************************* --->
		<cfset getTransfer().save(arguments.genericTO)>
	</cffunction>
	
	<cffunction name="cascadeSave" hint="Save a generic TO and all of its children" access="public" output="false" returntype="void">
		<!--- ************************************************************* --->
		<cfargument name="genericTO" 	type="any" 		required="true"/>
		<cfargument name="depth" hint="the number of levels in which to cascade, 0 is unlimited" type="numeric" required="No" default="0">
		<!--- ************************************************************* --->
		<cfset getTransfer().cascadeSave(arguments.genericTO,arguments.depth)>
	</cffunction>
	
	<cffunction name="delete" hint="delete a generic TO" access="public" output="false" returntype="void">
		<!--- ************************************************************* --->
		<cfargument name="genericTO" 	type="any" 		required="true"/>
		<!--- ************************************************************* --->
		<cfset getTransfer().delete(arguments.genericTO)>
	</cffunction>
	
	<cffunction name="cascadeDelete" hint="Delete a generic TO and all of its children" access="public" output="false" returntype="void">
		<!--- ************************************************************* --->
		<cfargument name="genericTO" 	type="any" 		required="true"/>
		<cfargument name="depth" hint="the number of levels in which to cascade, 0 is unlimited" type="numeric" required="No" default="0">
		<!--- ************************************************************* --->
		<cfset getTransfer().cascadeDelete(arguments.genericTO,arguments.depth)>
	</cffunction>
	
<!----------------------------------- PRIVATE ------------------------------>

	<!--- Get/set Transfer --->
	<cffunction name="getTransfer" access="private" returntype="any" output="false">
		<cfreturn instance.Transfer>
	</cffunction>
	
	<!--- Get Datasource --->
	<cffunction name="getDatasource" access="public" returntype="any" output="false">
		<cfreturn instance.Datasource>
	</cffunction>

	<!---  Get the Utility Object. --->
	<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Utility Method">
		<cfreturn CreateObject("component","codex.model.util.Utility")>
	</cffunction>
	
</cfcomponent>