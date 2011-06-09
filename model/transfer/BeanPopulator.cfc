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
<cfcomponent hint="Uses Transfer meta data to populates beans from mementos" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanPopulator" output="false">
	<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="serviceMap" hint="the map of service objects to map composite transfer class names to" type="struct" required="No" default="#StructNew()#">
	<cfscript>
		setTransfer(arguments.transfer);
		setServiceMap(arguments.serviceMap);

		return this;
	</cfscript>
</cffunction>

<cffunction name="populate" hint="populates a bean with form data" access="public" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfre object is question" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="memento" hint="the memento in question" type="struct" required="Yes">
	<cfscript>
		arguments.object = getTransfer().getTransferMetaData(arguments.transferObject.getClassName());
		populateProperties(argumentCollection=arguments);
		populateManyToOne(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="populateProperties" hint="populates propery values" access="private" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfre object is question" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="object" hint="the transfer object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="memento" hint="the memento in question" type="struct" required="Yes">
	<cfscript>
		var iterator = arguments.object.getPropertyIterator();
		var property = 0;
		var args = 0;
		var name = 0;
	</cfscript>
	<cfloop condition="#iterator.hasNext()#">
		<cfset property = iterator.next() />
		<cfset name = property.getName() />
		<cfif structKeyExists(arguments.memento, name)>
			<cfset args = StructNew() />
			<cfset args[name] = arguments.memento[name] />
			<cfinvoke component="#arguments.transferObject#" method="set#property.getName()#" argumentcollection="#args#">
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="populateManyToOne" hint="populates many to one values" access="private" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfre object is question" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="object" hint="the transfer object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="memento" hint="the memento in question" type="struct" required="Yes">
	<cfscript>
		var iterator = arguments.object.getManyToOneIterator();
		var manytoone = 0;
		var compositeObject = 0;
		var keyName = 0;
		var args = 0;
		var key = 0;
	</cfscript>
	<cfloop condition="#iterator.hasNext()#">
		<cfset manytoone = iterator.next() />
		<cfset compositeObject = manytoone.getLink().getToObject() />
		<cfset keyName = compositeObject.getObjectName() & "ID"/>
		<cfif structKeyExists(arguments.memento, keyName)>
			<cfset key =  arguments.memento[keyName]/>
			<cfif Len(key) AND key neq 0>
				<cfset args = StructNew() />
				<cfset args.transfer = getComposite(compositeObject.getClassName(), key) />
				<cfinvoke component="#arguments.transferObject#" method="set#manytoone.getName()#" argumentcollection="#args#">
			<cfelse>
				<cfinvoke component="#arguments.transferObject#" method="remove#manytoone.getName()#">
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="getComposite" hint="returns a composite object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="class" hint="the class to be retrieving" type="string" required="Yes">
	<cfargument name="key" hint="the key to be looking for" type="string" required="Yes">
	<cfset var transfer = 0 />
	<cfif StructKeyExists(getServiceMap(), arguments.class)>
		<cfinvoke component="#StructFind(getServiceMap(), arguments.class)#" method="get#compositeObject.getObjectName()#" argumentcollection="#arguments#" returnvariable="transfer">
	<cfelse>
		<cfinvoke component="#getTransfer()#" method="get" argumentcollection="#arguments#" returnvariable="transfer">
	</cfif>
	<cfreturn transfer />
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

<cffunction name="getServiceMap" access="private" returntype="struct" output="false">
	<cfreturn instance.serviceMap />
</cffunction>

<cffunction name="setServiceMap" access="private" returntype="void" output="false">
	<cfargument name="serviceMap" type="struct" required="true">
	<cfset instance.serviceMap = arguments.serviceMap />
</cffunction>

</cfcomponent>