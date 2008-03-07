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
	<cffunction name="validate" access="public" returntype="Array" hint="Validate this bean">
		<cfscript>
			var errors = Arraynew(1);
			
			if( len(getRole()) eq 0 ){
				ArrayAppend(errors,"Please set a valid role");
			}
			
			return errors;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator">
		<cfscript>
			/* Table Config for scaffolding*/
			var tableConfig = structnew();
			
			tableConfig.SortBy = "role";
			tableConfig.role.maxlength = 100;
			
			/* Set the config */
			setTableConfig(tableConfig);
		</cfscript>
	</cffunction>
	
</cfcomponent>