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
			var maxRows = 1;
			
			/* Exit Handlers */
			rc.xehUserListing = "admin.users/list.cfm";
			rc.xehUserCreate = "admin.users/new.cfm";
			rc.xehUserEdit = "admin.users/edit.cfm";
			rc.xehUserDelete = "admin.users/doDelete.cfm";
			
			/* Search Criteria */
			event.paramValue("search_criteria","");
			event.paramValue("active",true);
			event.paramValue("page","1");
			event.paramValue("role_id","0");
			event.paramValue("startrow","1");
			
			/* JS Lookups */
			event.setValue("jsAppendList", "jquery.simplemodal-1.1.1.pack,confirm");
			
			/* For Testing */
			setSetting("PagingMaxRows",10);
			
			//Calculate the start row
			rc.startRow = ((rc.page * getSetting("PagingMaxRows")) - getSetting("PagingMaxRows"))+1;
			//Setup the max rows
			maxRows = rc.startRow + getSetting("PagingMaxRows") - 1;
			
			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();
			
			/* Get Users */
			rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,
												   active=rc.active,
												   role_id=rc.role_id,
												   startrow=rc.startRow,
												   maxRows=maxRows);
			
			/* Found Rows */
			if( rc.qUsers.recordcount ){
				rc.FoundRows = rc.qUsers.foundRows;
			}
			else{
				rc.FoundRows = 0;
			}
			
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
			
			/* Exit Handlers */
			rc.xehUserListing = "admin.users/list.cfm";
			rc.xehUserCreate = "admin.users/doCreate.cfm";
						
			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();
		
			/* Set View */
			event.setView("admin/users/add");			
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="User Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUser = "";
			var oUserService = getUserService();
			
			//create new user object.
			oUser = oUserService.getUser();
			//Populate it
			getPlugin("beanFactory").populateBean(oUser);
			//set role
			oUser.setRole(oUserService.getRole(rc.role_id));
			//Save it
			oUserService.save(oUser);
			//set message box
			getPlugin("messagebox").setMessage("info","User added successfully");
			
			/* Relocate back to listing */
			setNextRoute(route="admin.users/list");	
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="edit" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			/* Exit Handlers */
			rc.xehUserListing = "admin.users/list.cfm";
			rc.xehUserCreate = "admin.users/doEdit.cfm";
			
			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();
			rc.oUser =  getUserService().getUser(rc.user_id);
			
			/* Set View */
			event.setView("admin/users/edit");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="User do edit">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getUserService();
			var oUser = "";
			var oClonedUser = "";
			var errors = ArrayNew(1);
			
			/* get user object. */
			oUser = oUserService.getUser(rc.user_id);
			/* Clone it */
			oClonedUser = oUser.clone();
			//Populate it
			getPlugin("beanFactory").populateBean(oClonedUser);
			//set relation
			oClonedUser.setRole(oUserService.getRole(rc.role_id));
			
			/* Validate it */
			errors = oClonedUser.validate();
			if( ArrayLen(errors) ){
				//set message box
				getMyPlugin("messagebox").setMessage(type="error",messageArray=errors);
				/* Relocate back to edit */
				setNextRoute(route="admin.users/edit",qs="user_id=#rc.user_id#");
			}
			else{
				//Save it
				oUserService.save(oClonedUser);
				//set message box
				getMyPlugin("messagebox").setMessage("info","User updated!");
				/* Relocate back to listing */
				setNextRoute(route="admin.users/list");
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
	
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete a user.">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUser = "";
			var i = 1;
			
			try{
				/* listing or record sent in? */
				if( event.getValue("user_id","") neq "" ){
					/* Loop and delete */
					for(i=1; i lte listlen(rc.user_id); i=i+1){
						//Get new user obj
						oUser = getUserService().getUser(user_id=listGetAt(rc.user_id,i));
						//Remove it.
						getUserService().deleteUser(oUser);
						//set message box
						getPlugin("messagebox").setMessage("info","User(s) removed");				
					}
				}
				else{
					/* Messagebox. */
					getPlugin("messagebox").setMessage("warning", "No Records Selected");
				}				
			}
			catch(Any e){
				getPlugin("messagebox").setMessage("error", "Error removing user. You can only remove users that do not have any internal links in the system. #e.message# #e.detail#");
			}
			
			/* Relocate back to listing */
			setNextRoute(route="admin.users/list");
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