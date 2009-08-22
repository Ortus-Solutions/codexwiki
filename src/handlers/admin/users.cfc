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
<cfcomponent name="users"
			 output="false"
			 hint="Users Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="LookupService" type="ioc" scope="instance">
	<cfproperty name="UserService" type="ioc" scope="instance">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List Users --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="User listing">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();

			rc.xehUserListing = "admin/users/list";
			rc.pagingLink = "#rc.xehUserListing#/page/@page@";
			rc.xehUserCreate = "admin/users/new";
			rc.xehUserEdit = "admin/users/edit";
			rc.xehUserDelete = "admin/users/doDelete";
			rc.xehUserPerms = "admin/users/permissions";

			event.paramValue("search_criteria","");
			event.paramValue("active",true);
			event.paramValue("confirmed",-1);
			event.paramValue("role_id","0");

			event.setValue("jsAppendList", "jquery.simplemodal,confirm,jquery.metadata,jquery.tablesorter.min,jquery.uitablefilter");
			event.setValue("cssFullAppendList","includes/lookups/styles/sort");

			rc.qRoles = getUserService().getAllRoles();

			event.paramValue("filter","all");
			switch(rc.filter){
				case "all" : {
					rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,role_id=rc.role_id);
					break;
				}
				case "pending" : {
					rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,role_id=rc.role_id,confirmed=false);
					break;
				}
				case "confirmed" : {
					rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,role_id=rc.role_id,confiremd=true);
					break;
				}
				case "inactive" : {
					rc.qUsers = getUserService().findUsers(criteria=rc.search_criteria,role_id=rc.role_id,active=false);
					break;
				}
			}
			
			event.setView('admin/users/Listing');
		</cfscript>
	</cffunction>

	<!--- New user panel --->
	<cffunction name="new" output="false" access="public" returntype="void" hint="new user editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehUserListing = "admin/users/list";
			rc.xehUserCreate = "admin/users/doCreate";
			
			/* JS */
			rc.jsAppendList = "formvalidation";

			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();

			/* Set View */
			event.setView("admin/users/add");
		</cfscript>
	</cffunction>

	<!--- Create a new user --->
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="User Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUser = "";
			var oUserService = getUserService();
			var errors = ArrayNew(1);

			/* Validate username */
			if( not oUserService.isUsernameValid(event.getValue("username","")) ){
				getPlugin("messagebox").setMessage("error","The username you choose is already taken. Please try another one.");
				new(arguments.event);
				return;
			}
			
			//create new user object.
			oUser = oUserService.getUser();
			//Populate it
			getPlugin("beanFactory").populateBean(oUser);
			/* Validate it */
			errors = oUser.validate();
			/* Error Checks */
			if( arraylen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				setNextRoute(route="admin/users/new");
			}
			else{
				/* Set Role */
				oUser.setRole(oUserService.getRole(rc.role_id));
				/* Save User */
				oUserService.saveUser(oUser);

				getPlugin("messagebox").setMessage("info","User added successfully");
				setNextRoute(route="admin/users/list");
			}
		</cfscript>
	</cffunction>

	<!--- Edit Panel --->
	<cffunction name="edit" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehUserListing = "admin/users/list";
			rc.xehUserUpdate = "admin/users/doEdit";
			
			/* JS */
			rc.jsAppendList = "formvalidation";
			
			/* Verify incoming user id */
			if( not event.valueExists("user_id") ){
				getPlugin("messagebox").setMessage("warning", "user id not detected");
				setNextRoute("admin/users/list");
			}

			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();
			rc.thisUser =  getUserService().getUser(rc.user_id);

			/* Set View */
			event.setView("admin/users/edit");
		</cfscript>
	</cffunction>

	<!--- Do Edit --->
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="User do edit">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getUserService();
			var oUser = "";
			var oClonedUser = "";
			var errors = ArrayNew(1);
			var passChange = false;
			
			/* Get User and start checks */
			oUser = oUserService.getUser(rc.user_id);
			oClonedUser = oUser.clone();
			getPlugin("beanFactory").populateBean(oClonedUser);
			
			/* Validate it */
			errors = oClonedUser.validate(edit=true);
			if( ArrayLen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				setNextRoute(route="admin/users/edit/user_id/#rc.user_id#");
			}
			else{
				/* Set/update role */
				oClonedUser.setRole(oUserService.getRole(rc.role_id));
				/* Set password if sent */
				if( rc.newpassword.length() neq 0 ){
					oClonedUser.setPassword(rc.newpassword);
					passChange = true;
				}

				//Save it
				oUserService.saveUser(User=oClonedUser,isPasswordChange=passChange);
				
				/* Message of success */
				getPlugin("messagebox").setMessage("info","User updated!");
				setNextRoute(route="admin/users/list");
			}
		</cfscript>
	</cffunction>

	<!--- Permissions --->
	<cffunction name="permissions" output="false" access="public" returntype="void" hint="Permissions editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehAddPerm = "admin/users/addPermission";
			rc.xehRemovePerm = "admin/users/removePermission";
			rc.xehUserListing = "admin/users/list";

			/* Verify incoming user id */
			if( not event.valueExists("user_id") ){
				getPlugin("messagebox").setMessage("warning", "user id not detected");
				setNextRoute("admin/users/list");
			}

			/* Get the current User */
			rc.thisUser =  getUserService().getUser(rc.user_id);

			/* Get The User's Perms */
			rc.qUserPerms = getUserService().getuserPermissions(rc.thisUser.getuserID());
			/* Get the Role's Perms */
			rc.qRolePerms = getUserService().getRolePermissions(rc.thisUser.getRole().getroleId());
			/* Get All the perms */
			rc.qAllperms = getLookupService().getListing('security.Permission');

			/* Set View */
			event.setView("admin/users/permissions");
		</cfscript>
	</cffunction>

	<!--- Add Permission --->
	<cffunction name="addPermission" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUser = "";
			var oPerm = "";

			/* Check Permission and user */
			if( not event.valueExists('permissionID') or not event.valueExists('user_id') ){
				getPlugin("messagebox").setMessage("warning", "permission or user id not detected");
				setNextRoute("admin/users/permissions/user_id/#rc.user_id#");
			}

			/* Get user and perm */
			oUser = getUserService().getUser(rc.user_id);
			oPerm = getLookupService().getLookupObject('security.Permission',rc.permissionID);

			/* Check if perm already in user */
			if( not oUser.containsPermission(oPerm) ){
				/* Add Perm and save */
				getUserService().saveUserPerm(oUser,oPerm);
				getPlugin("messagebox").setMessage("info", "permission added");
			}
			else{
				getPlugin("messagebox").setMessage("warning", "permission already in user");
			}

			/* relocate */
			setNextRoute('admin/users/permissions/user_id/#rc.user_id#');
		</cfscript>
	</cffunction>

	<!--- Remove Permission --->
	<cffunction name="removePermission" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUser = 0;
			var oPerm = 0;

			/* Check Permission and user */
			if( not event.valueExists('permissionID') or not event.valueExists('user_id') ){
				getPlugin("messagebox").setMessage("warning", "permission or user id not detected");
				setNextRoute("admin/users/permissions/user_id/#rc.user_id#");
			}

			/* get Permission_id and user_id */
			oUser = getUserService().getUser(rc.user_id);
			oPerm = getLookupService().getLookupObject('security.Permission',rc.permissionID);

			/* Remove Permission */
			getUserService().deleteUserPerm(oUser,oPerm);
			getPlugin("messagebox").setMessage("info", "permission removed");

			/* relocate */
			setNextRoute('admin/users/permissions/user_id/#rc.user_id#');
		</cfscript>
	</cffunction>

	<!--- Delete User --->
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
			setNextRoute(route="admin/users/list");
		</cfscript>
	</cffunction>


<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Get/Set lookup Service --->
	<cffunction name="getLookupService" access="private" output="false" returntype="codex.model.lookups.LookupService" hint="Get LookupService">
		<cfreturn instance.LookupService/>
	</cffunction>

	<!--- Get Set User Service --->
	<cffunction name="getUserService" access="private" output="false" returntype="codex.model.security.UserService" hint="Get UserService">
		<cfreturn instance.UserService/>
	</cffunction>

</cfcomponent>