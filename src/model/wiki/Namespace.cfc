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
<cfcomponent hint="BO for a page namespace" extends="transfer.com.TransferDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!--- Validate this bean --->
	<cffunction name="validate" access="public" returntype="Array" hint="Validate this bean">
		<cfscript>
			var errors = Arraynew(1);
			
			if( len(getName()) eq 0 ){
				ArrayAppend(errors,"Please set a valid name");
			}
			if( len(getDescription()) eq 0 ){
				ArrayAppend(errors,"Please set a valid description");
			}
			
			return errors;
		</cfscript>
	</cffunction>
	
	<!--- Get set create Date --->
	<cffunction name="getcreatedDate" output="false" access="public" returntype="string"	hint="Returns the create date, if null it returns an empty string.">
		<cfreturn getTransferObject().getcreatedDate()>
	</cffunction>
	<cffunction name="setcreatedDate" output="false" access="public" returntype="void" hint="Set the date if found">
		<cfargument name="myDate" type="string" required="false" default=""/>
		<cfif isDate(arguments.mydate)>
			<cfset getTransferObject().setcreatedDate(arguments.mydate)>
		</cfif>
	</cffunction>
	
	<!--- Scaffolding Table Config --->
	<cffunction name="gettableConfig" access="public" returntype="struct" output="false" hint="Get the table config for scaffolding">
		<cfreturn instance.tableConfig>
	</cffunction>
	<cffunction name="settableConfig" access="public" returntype="void" output="false" hint="Set the table config for scaffolding">
		<cfargument name="tableConfig" type="struct" required="true">
		<cfset instance.tableConfig = arguments.tableConfig>
	</cffunction>
	
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator">
		<cfscript>
			/* Table Config for scaffolding*/
			var tc = structnew();
			
			tc.SortBy = "name";
			
			tc.name.maxlength = 255;
			tc.description.maxlength = 255;
			tc.description.html = "richtext";
						
			/* Set the config */
			setTableConfig(tc);
		</cfscript>
	</cffunction>
	
</cfcomponent>