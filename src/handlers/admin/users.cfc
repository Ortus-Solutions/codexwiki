<cfcomponent name="users" 
			 output="false" 
			 hint="Users Controller" 
			 extends="codex.handlers.baseHandler"
			 autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List Users --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="User listing">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var rc = event.getCollection();
			var startRow = 1;
			var maxRows = 1;
			
			/* Exit Handlers */
			rc.xehUserListing = "admin.users/list.cfm";
			rc.xehUserCreate = "admin.users/new.cfm";
			rc.xehUserEdit = "admin.users/edit.cfm";
			rc.xehUserDelete = "admin.users/doRemove.cfm";
			
			/* Search Criteria */
			event.paramValue("search_criteria","");
			event.paramValue("active",true);
			event.paramValue("page","1");
			event.paramValue("role_id","0");
			
			//setSetting("PagingMaxRows",1);
			
			//Calculate the start row
			startRow = ((rc.page * getSetting("PagingMaxRows")) - getSetting("PagingMaxRows"))+1;
			//Setup the max rows
			maxRows = startRow + getSetting("PagingMaxRows") - 1;
			
			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();
			
			/* Get Users */
			rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,
												   active=rc.active,
												   role_id=rc.role_id,
												   startrow=startRow,
												   maxRows=maxRows);
			
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
			event.setView('admin/users/Listing');
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
	
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Get/Set lookup Service --->
	<cffunction name="getLookupService" access="private" output="false" returntype="codex.model.lookups.LookupService" hint="Get LookupService">
		<cfreturn instance.LookupService/>
	</cffunction>	
	<cffunction name="setLookupService" access="private" output="false" returntype="void" hint="Set LookupService">
		<cfargument name="LookupService" type="codex.model.lookups.LookupService" required="true"/>
		<cfset instance.LookupService = arguments.LookupService/>
	</cffunction>
	
	<!--- Get Set User Service --->
	<cffunction name="getUserService" access="private" output="false" returntype="codex.model.security.UserService" hint="Get UserService">
		<cfreturn instance.UserService/>
	</cffunction>	
	<cffunction name="setUserService" access="private" output="false" returntype="void" hint="Set UserService">
		<cfargument name="UserService" type="codex.model.security.UserService" required="true"/>
		<cfset instance.UserService = arguments.UserService/>
	</cffunction>
	
	
</cfcomponent>