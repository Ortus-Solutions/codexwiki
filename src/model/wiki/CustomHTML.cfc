<cfcomponent extends="transfer.com.TransferDecorator" hint="A custom HTML for the wiki" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- Get set modify Date --->
	<cffunction name="getmodifyDate" output="false" access="public" returntype="string"	hint="Returns the create date, if null it returns an empty string.">
		<cfreturn getTransferObject().getmodifyDate()>
	</cffunction>
	<cffunction name="setmodifyDate" output="false" access="public" returntype="void" hint="Set the date if found">
		<cfargument name="myDate" type="string" required="false" default=""/>
		<cfif isDate(arguments.mydate)>
			<cfset getTransferObject().setmodifyDate(arguments.mydate)>
		</cfif>
	</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->



</cfcomponent>