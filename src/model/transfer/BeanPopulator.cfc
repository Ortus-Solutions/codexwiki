<cfcomponent hint="Uses Transfer meta data to populates beans from mementos" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanPopulator" output="false">
	<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfscript>
		setTransfer(arguments.transfer);

		return this;
	</cfscript>
</cffunction>

<cffunction name="populate" hint="populates a bean with form data" access="public" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfre object is question" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="memento" hint="the memento in question" type="struct" required="Yes">
	<cfscript>
		var object = getTransfer().getTransferMetaData(arguments.transferObject.getClassName());
		var propertyIterator = object.getPropertyIterator();
		var property = 0;
		var args = 0;
		var name = 0;
	</cfscript>
	<cfloop condition="#propertyIterator.hasNext()#">
		<cfset property = propertyIterator.next() />
		<cfset name = property.getName() />
		<cfif structKeyExists(arguments.memento, name)>
			<!--- TODO: at some point we will want to type check this, maybe also look at how to do composite object insertion? --->
			<cfset args = StructNew() />
			<cfset args[name] = arguments.memento[name] />
			<cfinvoke component="#arguments.transferObject#" method="set#property.getName()#" argumentcollection="#args#">
		</cfif>
	</cfloop>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

</cfcomponent>