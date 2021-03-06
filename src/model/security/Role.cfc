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
<cfcomponent hint="A Role" extends="transfer.com.TransferDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!--- Scaffolding Table Config --->
	<cffunction name="gettableConfig" access="public" returntype="struct" output="false" hint="Get the table config for scaffolding">
		<cfreturn instance.tableConfig>
	</cffunction>
	<cffunction name="settableConfig" access="public" returntype="void" output="false" hint="Set the table config for scaffolding">
		<cfargument name="tableConfig" type="struct" required="true">
		<cfset instance.tableConfig = arguments.tableConfig>
	</cffunction>
	
	<!--- Validate this bean --->
	<cffunction name="validate" access="public" returntype="Array" hint="Validate this bean" output="false">
		<cfscript>
			var errors = Arraynew(1);
			
			if( len(getRole()) eq 0 ){
				ArrayAppend(errors,"Please set a valid role");
			}
			
			return errors;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator" output="false">
		<cfscript>
			/* Table Config for scaffolding*/
			var tc = structnew();
			
			tc.SortBy = "role";
			
			tc.role.maxlength = 100;
			tc.role.helptext = "The role name to use";
			
			tc.description.helptext = "A basic role description";
			tc.description.html = "richtext";
			tc.description.maxlength = 255;
			
			/* Set the config */
			setTableConfig(tc);
		</cfscript>
	</cffunction>
	
</cfcomponent>