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
			/* Lazy Load Check */
			loadPermissions();
			/* Check */
			if ( structKeyExists(instance.permissions,arguments.Permission) ){
				results = instance.permissions[arguments.permission];
			}
			return results;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<!--- catch an update of a role, so we can reset the permissions --->
	<cffunction name="actionAfterUpdateTransferEvent" hint="catch an update of a role, so we can reset the permissions" access="public" returntype="void" default="void" output="false">
		<cfargument name="event" type="transfer.com.events.TransferEvent" hint="Transfer action event" required="true">
		<cfscript>
			var object = event.getTransferObject();

			getTransferObject().actionAfterUpdateTransferEvent(event);

			if(hasRole() AND getRole().equalsTransfer(object))
			{
				clearPermissions();
			}
		</cfscript>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Configure --->
	<cffunction name="configure" access="private" returntype="void" hint="Constructor code for my decorator">
		<cfscript>

			clearPermissions();
			/* User are not authed by default */
			setisAuthorized(false);
			/* A user is active by default */
			getTransferObject().setisActive(true);
			/* user is not confirmed by default */
			getTransferObject().setisConfirmed(false);

		</cfscript>
	</cffunction>

	<!--- clear permissions --->
	<cffunction name="clearPermissions" hint="clear the permissions off, so we can reload them as neccessary" access="private" returntype="void" output="false">
		<cfscript>
			/* Permission structure */
			setPermissions(structNew());
		</cfscript>
	</cffunction>

	<!--- Load Permissions --->
	<cffunction name="loadPermissions" access="private" returntype="void" hint="Load permissions lazy loaded." output="false">
		<cfscript>
			var tql = "";
			var oQuery = "";
			var qPerms = "";
		</cfscript>

		<cfif structIsEmpty(getPermissions())>
			<cflock name="user_#getTransferObject().getuserID()#.permissionsLoad" type="exclusive" timeout="30" throwontimeout="true">
				<cfif structIsEmpty(getPermissions())>
					<!--- Create TQL --->
					<cfsavecontent variable="tql">
					<cfoutput>
						SELECT UserPermissions.Permission as UserPermission,
							   RolePermissions.Permission as RolePermission
						FROM
							   security.User as Users
						OUTER JOIN security.Permission as UserPermissions on Users.Permission
						JOIN  security.Role as Roles on Users.Role
						OUTER JOIN security.Permission as RolePermissions on Roles.Permission
						WHERE
							Users.userID = :user_id
					</cfoutput>
					</cfsavecontent>

					<!--- Execute TQL --->
					<cfscript>
						oQuery = getTransfer().createQuery(tql);
						oQuery.setCacheEvaluation(true);
						oQuery.setParam("user_id", getTransferObject().getUserID(), "string");
						/* Get Perms */
						qPerms = getTransfer().listByQuery(oQuery);
					</cfscript>

					<!--- Set Permissions --->
					<cfloop query="qPerms">
						<cfif UserPermission neq "" and not structKeyExists(getPermissions(), UserPermission)>
							<cfset StructInsert(getPermissions(),UserPermission,true)>
						</cfif>
						<cfif RolePermission neq "" and not structKeyExists(getPermissions(), RolePermission)>
							<cfset StructInsert(getPermissions(),RolePermission,true)>
						</cfif>
					</cfloop>
				</cfif>
			</cflock>
		</cfif>
	</cffunction>

</cfcomponent>