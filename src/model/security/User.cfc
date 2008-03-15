<cfcomponent hint="User Decorator" extends="transfer.com.TransferDecorator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!--- Get set create Date --->
	<cffunction name="getcreateDate" output="false" access="public" returntype="string"	hint="Returns the create date, if null it returns an empty string.">
		<cfreturn getTransferObject().getcreateDate()>
	</cffunction>
	<cffunction name="setcreateDate" output="false" access="public" returntype="void" hint="Set the date if found">
		<cfargument name="myDate" type="string" required="false" default=""/>
		<cfif isDate(arguments.mydate)>
			<cfset getTransferObject().setcreateDate(arguments.mydate)>
		</cfif>
	</cffunction>
	
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
			var userPermIterator = "";
			var rolePermIterator = "";
			var item = "";
		</cfscript>
		
		<!--- Double Locking for race conditions --->
		<cfif structIsEmpty(getPermissions())>
			<cflock name="user_#getTransferObject().getuserID()#.permissionsLoad" type="exclusive" timeout="30" throwontimeout="true">
			<cfscript>
				if( structIsEmpty(getPermissions()) ){
					/* Get Perms Iterators */
					userPermIterator = getTransferObject().getPermissionIterator();
					rolePermIterator = getTransferObject().getRole().getPermissionIterator();
					
					/* Get Role Perms */
					while( rolePermIterator.hasNext() ){
						item = rolePermIterator.next();
						/* Check & Insertion */
						if( not structKeyExists(getPermissions(),item.getPermission()) ){
							StructInsert(getPermissions(),item.getPermission(),true);
						}
					}
					
					/* Get User a la carte perms */
					while( userPermIterator.hasNext() ){
						item = userPermIterator.next();
						/* Check & Insertion */
						if( not structKeyExists(getPermissions(),item.getPermission()) ){
							StructInsert(getPermissions(),item.getPermission(),true);
						}
					}
					
				}//end double lock
			</cfscript>
			</cflock>
		</cfif>
	</cffunction>

</cfcomponent>