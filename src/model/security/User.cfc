<cfcomponent hint="User Decorator" extends="transfer.com.TransferDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- getter and setter for Permissions structure --->
	<cffunction name="setPermissions" output="false" access="public" returntype="void" hint="Set a user's permissions struct">
		<cfargument name="permissions" required="true" type="struct">
		<cfset instance.permissions = arguments.permissions>
	</cffunction>
	<cffunction name="getPermissions" output="false" access="public" returntype="struct" hint="Get the user's permissions structure">
		<cfreturn instance.permissions>
	</cffunction>

	<!--- ************************************************************* --->

	<!--- getter and setter for Authorized --->
	<cffunction name="getisAuthorized" access="public" returntype="boolean" output="false">
		<cfreturn instance.isAuthorized>
	</cffunction>
	<cffunction name="setisAuthorized" access="public" returntype="void" output="false">
		<cfargument name="isAuthorized" type="boolean" required="true">
		<cfset instance.isAuthorized = arguments.isAuthorized>
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- cHECK FOR A permission --->
	<cffunction name="checkPermission" output="false" access="public" returntype="boolean" hint="Returns wether a user has permission to the passed in argument or not.">
		<!--- ************************************************************* --->
		<cfargument name="Permission" type="string" required="true" hint="The permission to check."/>
		<!--- ************************************************************* --->
		<cfscript>
			var results = false;
			/* Check */
			if ( structKeyExists(instance.permissions,arguments.Permission) ){
				results = instance.permissions[arguments.permission];
			}
			return results;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- OVerride set Memento --->
	<cffunction name="setMemento" access="public" returntype="void" default="void" hint="Decorated setMemento" output="false">
		<!--- ************************************************************* --->
		<cfargument name="memento" type="struct" required="true">
		<!--- ************************************************************* --->
		<cfscript>
			var userPermsTQL = "";
			var tql = "";
			var oQuery = "";
			var qPerms = "";
						
			/* Call Memento */
			getTransferObject().setMemento(argumentCollection=arguments);	
		</cfscript>
		
		<!--- Create TQL --->
		<cfsavecontent variable="tql">
		<cfoutput>
			select UserPermissions.Permission as UserPermission, RolePermissions.Permission as RolePermission
			from
				security.User as Users 
			outer join security.Permission as UserPermissions on Users.Permission
			join security.Role as Roles on Users.Role
			outer join security.Permission as RolePermissions on Roles.Permission
			where
				Users.userID = :user_id
		</cfoutput>
		</cfsavecontent>		
		<cfscript>
			oQuery = getTransfer().createQuery(tql);
			oQuery.setCacheEvaluation(true);
			oQuery.setParam("user_id", getTransferObject().getUserID(), "string");
			/* Get Perms */
			qPerms = getTransfer().listByQuery(oQuery);
		</cfscript>
		<cfloop query="qPerms">
			<cfif UserPermission neq "" and not structKeyExists(getPermissions(), UserPermission)>
				<cfset StructInsert(getPermissions(),UserPermission,true)>
			</cfif>
			<cfif RolePermission neq "" and not structKeyExists(getPermissions(), RolePermission)>
				<cfset StructInsert(getPermissions(),RolePermission,true)>
			</cfif>
		</cfloop>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Configure --->
	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator">
		<cfscript>

			/* Permission structure */
			setPermissions(structNew());
			/* User are not authed by default */
			setisAuthorized(false);
			/* A user is active by default */
			getTransferObject().setisActive(true);
			/* user is not confirmed by default */
			getTransferObject().setisConfirmed(false);

		</cfscript>
	</cffunction>

</cfcomponent>