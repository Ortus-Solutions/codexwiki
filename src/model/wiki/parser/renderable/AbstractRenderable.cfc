<cfcomponent hint="Abstract base class for renderable objects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getIsDynamic" access="public" returntype="boolean" output="false">
	<cfreturn instance.isDynamic />
</cffunction>

<cffunction name="render" hint="renders the output" access="public" returntype="string" output="false">
	<cfthrow type="transfer.VirtualMethodException" message="This method is virtual and must be overwritten">
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

</cfcomponent>