<cfcomponent hint="A Permission" extends="transfer.com.TransferDecorator" output="false">

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
	<cffunction name="validate" access="public" returntype="Array" hint="Validate this bean">
		<cfscript>
			var errors = Arraynew(1);
			
			if( len(getPermission()) eq 0 ){
				ArrayAppend(errors,"Please set a valid permission name");
			}
			
			return errors;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator">
		<cfscript>
			/* Table Config for scaffolding*/
			var tableConfig = structnew();
			
			tableConfig.SortBy = "permission";
			tableConfig.permissionID.display = false;
			tableConfig.permission.maxlength = 100;
			tableConfig.description.maxlength = 255;
			
			/* Set the config */
			setTableConfig(tableConfig);
		</cfscript>
	</cffunction>
	
</cfcomponent>