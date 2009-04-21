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
<cfcomponent name="roles"
			 output="false"
			 hint="Roles Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="LookupService" type="ioc" scope="instance">
	<cfproperty name="UserService" type="ioc" scope="instance">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List Users --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="Role listing">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			/* Exit Handlers */
			rc.xehListing = "admin/roles/list";
			rc.xehCreate = "admin/roles/new";
			rc.xehEdit = "admin/roles/edit";
			rc.xehDelete = "admin/roles/doDelete";
			rc.xehPerms = "admin/roles/permissions";

			/* JS Lookups */
			event.setValue("jsAppendList", "jquery.simplemodal,confirm,jquery.metadata,jquery.tablesorter.min");
			event.setValue("cssFullAppendList","includes/lookups/styles/sort");
			
			/* Get all the roles */
			rc.qRoles = getUserService().getAllRoles();

			/* Set View */
			event.setView('admin/roles/Listing');
		</cfscript>
	</cffunction>

	<!--- New user panel --->
	<cffunction name="new" output="false" access="public" returntype="void" hint="new role editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/roles/list";
			rc.xehCreate = "admin/roles/doCreate";
			
			/* JS */
			rc.jsAppendList = "formvalidation";

			/* Set View */
			event.setView("admin/roles/add");
		</cfscript>
	</cffunction>

	<!--- Create a new role --->
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="Role Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oRole = "";
			var oUserService = getUserService();
			var errors = ArrayNew(1);

			//create new role object.
			oRole = oUserService.getRole();
			//Populate it
			getPlugin("beanFactory").populateBean(oRole);
			/* Validate it */
			errors = oRole.validate();
			/* Error Checks */
			if( arraylen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				new(event);
			}
			else{
				/* Save Role */
				oUserService.save(oRole);
				getPlugin("messagebox").setMessage("info","Role added successfully");
				setNextRoute(route="admin/roles/list");
			}
		</cfscript>
	</cffunction>

	<!--- Edit Panel --->
	<cffunction name="edit" output="false" access="public" returntype="void" hint="Role editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/roles/list";
			rc.xehUpdate = "admin/roles/doEdit";
			
			/* JS */
			rc.jsAppendList = "formvalidation";
			
			/* Verify incoming user id */
			if( not event.valueExists("roleID") ){
				getPlugin("messagebox").setMessage("warning", "role id not detected");
				setNextRoute("admin/roles/list");
			}

			/* Get the role */
			rc.oRole =  getUserService().getRole(rc.roleID);

			/* Set View */
			event.setView("admin/roles/edit");
		</cfscript>
	</cffunction>

	<!--- Do Edit --->
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="Edit a Role">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oUserService = getUserService();
			var oRole = "";
			var oClonedRole = "";
			var errors = ArrayNew(1);
			
			/* Get User and start checks */
			oRole = oUserService.getRole(rc.roleID);
			oClonedRole = oRole.clone();
			getPlugin("beanFactory").populateBean(oClonedRole);
			
			/* Validate it */
			errors = oClonedRole.validate();
			if( ArrayLen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				edit(event);
			}
			else{
				//Save it
				oUserService.save(oClonedRole);
				
				/* Message of success */
				getPlugin("messagebox").setMessage("info","Role updated!");
				setNextRoute(route="admin/roles/list");
			}
		</cfscript>
	</cffunction>

	<!--- Permissions --->
	<cffunction name="permissions" output="false" access="public" returntype="void" hint="Permissions editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehAddPerm = "admin/roles/addPermission";
			rc.xehRemovePerm = "admin/roles/removePermission";
			rc.xehListing = "admin/roles/list";

			/* Verify incoming role id */
			if( not event.valueExists("roleID") ){
				getPlugin("messagebox").setMessage("warning", "role id not detected");
				setNextRoute("admin/roles/list");
			}

			/* Get the role */
			rc.oRole =  getUserService().getRole(rc.roleID);

			/* Get the Role's Perms */
			rc.qRolePerms = getUserService().getRolePermissions(rc.roleID);
			
			/* Get All the perms */
			rc.qAllperms = getLookupService().getListing('security.Permission');

			/* Set View */
			event.setView("admin/roles/permissions");
		</cfscript>
	</cffunction>

	<!--- Add Permission --->
	<cffunction name="addPermission" output="false" access="public" returntype="void" hint="Add Role Permission">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oRole = "";
			var oPerm = "";

			/* Check Permission and user */
			if( not event.valueExists('permissionID') or not event.valueExists('roleID') ){
				getPlugin("messagebox").setMessage("warning", "permission or role id not detected");
				setNextRoute("admin/roles/permissions/roleID/#rc.roleID#");
			}

			/* Get user and perm */
			oRole = getUserService().getRole(rc.roleID);
			oPerm = getLookupService().getLookupObject('security.Permission',rc.permissionID);

			/* Check if perm already in role */
			if( not oRole.containsPermission(oPerm) ){
				/* Add Perm and save */
				oRole.addPermission(oPerm);
				getUserService().save(oRole);
				getPlugin("messagebox").setMessage("info", "permission added");
			}
			else{
				getPlugin("messagebox").setMessage("warning", "permission already in role");
			}

			/* relocate */
			setNextRoute('admin/roles/permissions/roleID/#rc.roleID#');
		</cfscript>
	</cffunction>

	<!--- Remove Permission --->
	<cffunction name="removePermission" output="false" access="public" returntype="void" hint="User editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oRole = 0;
			var oPerm = 0;

			/* Check Permission and user */
			if( not event.valueExists('permissionID') or not event.valueExists('roleID') ){
				getPlugin("messagebox").setMessage("warning", "permission or role id not detected");
				setNextRoute("admin/roles/permissions/roleID/#rc.roleID#");
			}

			/* get Permission_id and roleID */
			oRole = getUserService().getRole(rc.roleID);
			oPerm = getLookupService().getLookupObject('security.Permission',rc.permissionID);

			/* Remove Permission */
			oRole.removePermission(oPerm);
			getUserService().save(oRole);
			getPlugin("messagebox").setMessage("info", "permission removed");

			/* relocate */
			setNextRoute('admin/roles/permissions/roleID/#rc.roleID#');
		</cfscript>
	</cffunction>

	<!--- Delete User --->
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete a role.">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oRole = "";
			var i = 1;

			try{
				/* listing or record sent in? */
				if( event.getValue("roleID","") neq "" ){
					/* Loop and delete */
					for(i=1; i lte listlen(rc.roleID); i=i+1){
						//Get new obj
						oRole = getUserService().getRole(listGetAt(rc.roleID,i));
						//Remove it.
						getUserService().delete(oRole);
						//set message box
						getPlugin("messagebox").setMessage("info","Role(s) removed");
					}
				}
				else{
					/* Messagebox. */
					getPlugin("messagebox").setMessage("warning", "No Records Selected");
				}
			}
			catch(Any e){
				getPlugin("messagebox").setMessage("error", "Error removing role. You can only remove roles that do not have any internal links in the system. #e.message# #e.detail#");
			}

			/* Relocate back to listing */
			setNextRoute(route="admin/roles/list");
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