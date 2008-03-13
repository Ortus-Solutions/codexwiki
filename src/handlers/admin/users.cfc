<cfcomponent name="users" output="false" hint="Users Controller" extends="basehandler" cache="true" cachetimeout="10">

	<!--- ************************************************************* --->
	
	<cffunction name="list" output="false" access="public" returntype="void" hint="User listing">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var startRow = 1;
			var rowlimit = 1;
			
			try{
				/* Search Criteria */
				event.paramValue("search_criteria","");
				event.paramValue("active",true);
				event.paramValue("page","1");
				event.paramValue("role_id","0");
				
				//Calculate the start row
				startRow = ((rc.page * rc.qSystemOptions.ShowHowManyRecords) - rc.qSystemOptions.ShowHowManyRecords)+1;
				//Setup the max rows
				rowLimit = startRow + rc.qSystemOptions.ShowHowManyRecords;
				
				/* Get all the roles */
				rc.qRoles = getPlugin("ioc").getBean("lookupService").getListing("lookups.roles");
				
				/* Get Users */
				rc.qUsers = getplugin("ioc").getBean("userService").fullUserSearch(criteria=rc.search_criteria,
																				   active=rc.active,
																				   role_id=rc.role_id,
																				   startrow = startRow,
																				   limit = rowLimit);
				
				//Param sort Order
				if ( event.getValue("sortOrder","") eq "")
					event.setValue("sortOrder","ASC");
				else{
					if ( rc.sortOrder eq "ASC" )
						rc.sortOrder = "DESC";
					else
						rc.sortOrder = "ASC";
				}
				//Test for Sorting
				if ( event.getValue("sortby","") neq "" )
					rc.qUsers = getPlugin("queryHelper").sortQuery(rc.qUsers,"[#rc.sortby#]",rc.sortOrder);
				else
					rc.sortby = "";
					
				/* Set View */
				event.setView('users/list');
			}
			catch(Any e){
				handleException("User Listing : #e.message#","users.list",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="new" output="false" access="public" returntype="void" hint="new user editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
				
			try{
				/* Get all the roles */
				rc.qRoles = getPlugin("ioc").getBean("lookupService").getListing("lookups.roles");
				
				/* Set View */
				event.setView("users/add");
			}
			catch(Any e){
				handleException("New User : #e.message#","users.new",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="User Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getPlugin("ioc").getBean("userService");
			var oUser = "";
			
			try{
				//create new user object.
				oUser = oUserService.getUser();
				//Populate it
				getPlugin("beanFactory").populateBean(oUser);
				//set relation
				oUser.setRole(getPlugin("ioc").getBean("lookupService").getListingObject("security.roles", rc.role_id));
				//Save it
				oUserService.save(oUser);
				//set message box
				getMyPlugin("com.esri.messagebox.messagebox").setMessage("info","User added successfully");
				//relocate
				setNextEvent('users.list');
			}
			catch(Any e){
				handleException("User Create : #e.message#","users.doCreate",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="edit" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			try{
				/* Get all the roles */
				rc.qRoles = getPlugin("ioc").getBean("lookupService").getListing("lookups.roles");
				rc.oUser =  getPlugin("ioc").getBean("userService").getUser(user_id=rc.user_id,useActiveBit=false);
				/* Set View */
				event.setView("users/edit");
			}
			catch(Any e){
				handleException("User editor : #e.message#","users.edit",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="User do edit">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getPlugin("ioc").getBean("userService");
			var oUser = "";
			try{
				//get user object.
				oUser = oUserService.getUser(user_id=rc.user_id,useActiveBit=false);
				//Populate it
				getPlugin("beanFactory").populateBean(oUser);
				//set relation
				oUser.setRole(getPlugin("ioc").getBean("lookupService").getListingObject("security.roles", rc.role_id));
				//Save it
				oUserService.save(oUser);
				//set message box
				getMyPlugin("com.esri.messagebox.messagebox").setMessage("info","User updated!");
				//relocate
				setNextEvent('users.list');
			}
			catch(Any e){
				handleException("User do edit : #e.message#","users.doEdit",e,1);
			}
		</cfscript>
	</cffunction>
	
	<!--- ************************************************************* --->
	
	<cffunction name="permissions" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			try{
				/* Get all the roles */
				rc.oUser =  getPlugin("ioc").getBean("userService").getUser(user_id=rc.user_id,useActiveBit=false);
				rc.qPermissions = getplugin("ioc").getBean("lookupService").getListing("lookups.permissions");
				
				/* Get Role Perms */
				rc.RolePermissions = rc.oUser.getRole().getPermissionsArray();
				/* Get User Perms */
				rc.UserPermissions = rc.oUser.getPermissionsArray();
				
				/* Set View */
				event.setView("users/permissions");
			}
			catch(Any e){
				handleException("User permissions : #e.message#","users.permissions",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="addPermission" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getPlugin("ioc").getBean("userService");
			try{
				/* Get all the roles */
				oUser = oUserService.getUser(user_id=rc.user_id,useActiveBit=false);
				oPerm = getPlugin("ioc").getBean("lookupService").getListingObject('lookups.permissions',rc.permission_id);
				
				/* Add Perm */
				oUser.addPermissions(oPerm);
				oUserService.save(oUser);
				
				/* relocate */
				setNextEvent('users.permissions','user_id=#rc.user_id#');
			}
			catch(Any e){
				handleException("User permissions : #e.message#","users.permissions",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="removePermission" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getPlugin("ioc").getBean("userService");
			try{
				/* get Permission_id and user_id */
				oUser = oUserService.getUser(user_id=rc.user_id,useActiveBit=false);
				oPerm = getPlugin("ioc").getBean("lookupService").getListingObject('lookups.permissions',rc.permission_id);
				
				/* Remove Permission */
				oUser.removePermissions(oPerm);
				oUserService.save(oUser);
				
				/* relocate */
				setNextEvent('users.permissions','user_id=#rc.user_id#');
			}
			catch(Any e){
				handleException("User permissions : #e.message#","users.permissions",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doRemove" output="false" access="public" returntype="void" hint="User do Delete">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getPlugin("ioc").getBean("userService");
			var oUser = "";
			try{
				//Get new user obj
				oUser = oUserService.getUser(user_id=rc.user_id,useActiveBit=false);
				//Remove it.
				oUserService.delete(oUser);
				//set message box
				getMyPlugin("com.esri.messagebox.messagebox").setMessage("info","User removed");
				//relocate
				setNextEvent('users.list');
			}
			catch(Any e){
				handleException("User delete : #e.message#","users.doRemove",e,1);
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	
	
	
	
</cfcomponent>