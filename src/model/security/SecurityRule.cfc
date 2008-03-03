<!-----------------------------------------------------------------------
Author 	 : luis5198
Date     : 6/12/2007 4:38:35 PM
Description :
	permissions Object

Modification History:
6/12/2007 - Created Template
---------------------------------------------------------------------->
<cfcomponent hint="permissionsDecorator" extends="shared.api.beta.baseobjects.baseDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- ************************************************************* --->

	<cffunction name="getTableConfig" output="false" access="public" returntype="struct">
		<cfscript>
			instance.tableConfig = structnew();
			instance.tableConfig.SortBy = "Permission";
			instance.tableConfig.ID.display = false;
			instance.tableConfig.Active.html = "radio";
			return instance.tableConfig;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

<!------------------------------------------- PRIVATE ------------------------------------------->

	
</cfcomponent>