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
<cfcomponent name="UserService"
			 hint="This is the user service using Transfer" 
			 output="false"
			 extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" output="false" returntype="UserService">
		<!--- ************************************************************* --->
		<cfargument name="transfer" 	 type="transfer.com.Transfer" 				required="Yes" hint="the Transfer ORM">
		<cfargument name="transaction" 	 type="transfer.com.sql.transaction.Transaction" required="Yes" hint="The Transfer transaction">
		<cfargument name="Datasource" 	 type="transfer.com.sql.Datasource" 		required="Yes" hint="the Datasource obj">
		<cfargument name="ConfigService" type="codex.model.wiki.ConfigService" 		required="true" hint="The config service">
		<!--- ************************************************************* --->
		<cfscript>
			/* Init */
			super.init(argumentCollection=arguments);
			
			/* Config Bean */
			instance.ConfigService = arguments.configService;
			
			/* More Transactions */
			arguments.transaction.advise(this, "^registerUser");
			
			/* Return Instance */
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<!--- Get All roles --->
	<cffunction name="getAllRoles" output="false" access="public" returntype="query" hint="Returns all roles in the database, active and inactive.">
		<!--- ************************************************************* --->
		<cfargument name="orderProperty"  	type="string"  required="false" default=""/>
		<cfargument name="orderASC"  		type="boolean" required="false" default="true" hint="Order ASC = true, DESC = false"/>
		<!--- ************************************************************* --->
		<cfscript>
			var query = "";
			
			query = getTransfer().list('security.Role',arguments.orderProperty,arguments.orderASC);
			
			return query;
		</cfscript>
	</cffunction>

	<!--- Get Role with or without id --->
	<cffunction name="getRole" output="false" access="public" returntype="codex.model.security.Role" hint="Returns a role by ID or a new user object.">
		<!--- ************************************************************* --->
		<cfargument name="role_id" type="string" required="false" default=""/>
		<!--- ************************************************************* --->
		<cfscript>
			var oRole = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.roleid = arguments.role_id;
			
			/* Get user now. */
			oRole = getTransfer().readByPropertyMap('security.Role', sqlProps);
						
			return oRole;
		</cfscript>
	</cffunction>

	<!--- Get Role Permissions --->
	<cffunction name="getRolePermissions" access="public" returntype="query" hint="Get all the permissions of a specific role_id" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="role_id" required="true" type="string" hint="">
		<!--- ************************************************************* --->
		<cfset var tql = "">
		<cfset var query = "">

		<!--- Build TQL --->
		<cfsavecontent variable="tql">
		<cfoutput>
			SELECT security.Permission.permissionID, security.Permission.permission
			  FROM security.Role
			  JOIN security.Permission
			 WHERE security.Role.roleID = :role_id
		</cfoutput>
		</cfsavecontent>

		<!--- Create Query Object --->
		<cfset query = getTransfer().createQuery(tql)>
		<cfset query.setParam("role_id",arguments.role_id)>
		<cfset query.setCacheEvaluation(true)>

		<!--- create and return query --->
		<cfreturn getTransfer().listByQuery(query)>
	</cffunction>
	
	<!--- Get All users query --->
	<cffunction name="getAllUsers" output="false" access="public" returntype="query" hint="Returns all users in the database, active and inactive.">
		<!--- ************************************************************* --->
		<cfargument name="orderProperty"  	type="string"  required="false" default=""/>
		<cfargument name="orderASC"  		type="boolean" required="false" default="true" hint="Order ASC = true, DESC = false"/>
		<!--- ************************************************************* --->
		<cfscript>
			var query = "";
			
			query = getTransfer().list('security.User',arguments.orderProperty,arguments.orderASC);
			
			return query;
		</cfscript>
	</cffunction>
	
	<!--- find Users --->
	<cffunction name="findUsers" output="false" access="public" returntype="query" hint="Find Users in the database.">
		<!--- ************************************************************* --->
		<cfargument name="criteria" 	required="true" 	type="string" 	hint="The search criteria: fname,lname,email">
		<cfargument name="active" 		required="false" 	type="boolean"	default="true"	hint="Active or not user.">
		<cfargument name="role_id" 		required="false" 	type="string" 	default="0"		hint="The role id to search on.">
		<cfargument name="confirmed" 	required="false" 	type="numeric"  default="-1"    hint="Check user confirmation. -1 means don't check."/>
		<!--- ************************************************************* --->
		<cfset var qUsers = "">
		<cfset var qFoundRows = "">
		
		<!--- Search Users --->
		<cfquery name="qUsers" datasource="#getDatasource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			SELECT Users.user_id, Users.user_fname, Users.user_lname, Users.user_email, Users.user_isActive,
				   Users.user_isConfirmed, Users.user_create_date, Users.user_modify_date, Users.user_isDefault,
				   Roles.role
			  FROM wiki_users as Users, wiki_roles as Roles
			 WHERE Users.FKrole_id = Roles.role_id
			   AND Users.user_isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.active#">
			 
			 <!--- Search Criteria, If Found --->
			 <cfif arguments.criteria.length() neq 0>
			   AND ( Users.user_fname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> OR
			   		 Users.user_lname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> OR
			   		 Users.user_email like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> )
			 </cfif>
			 
			  <!--- Confirmation --->
			 <cfif arguments.confirmed gte 0>
			   AND Users.user_isConfirmed = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.confirmed#">
			 </cfif>
			 
			 <!--- Role, If Found --->
			 <cfif arguments.role_id neq 0>
			   AND Roles.role_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role_id#">
			 </cfif>
		</cfquery>
		
		<cfreturn qUsers>
	</cffunction>

	<!--- Get Basic user Info Query --->
	<cffunction name="getBasicUserInfo" hint="Get basic user info by user_id" access="public" output="false" returntype="query">
		<!--- ************************************************************* --->
		<cfargument name="user_id"  type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfset var tql = "">
		<cfset var query = "">

		<!--- Build TQL --->
		<cfsavecontent variable="tql">
		<cfoutput>
			FROM security.User
			JOIN security.Role
			WHERE security.User.userID = :user_id
		</cfoutput>
		</cfsavecontent>

		<!--- Create Query Object --->
		<cfset query = getTransfer().createQuery(tql)>
		<cfset query.setParam("user_id",arguments.user_id)>
		<cfset query.setCacheEvaluation(true)>

		<!--- create and return query --->
		<cfreturn getTransfer().listByQuery(query)>
	</cffunction>
	
	<!--- Get User Permissions --->
	<cffunction name="getuserPermissions" hint="Get a user's a-la-carte permissions query" access="public" output="false" returntype="query">
		<!--- ************************************************************* --->
		<cfargument name="user_id"  type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfset var tql = "">
		<cfset var query = "">

		<!--- Build TQL --->
		<cfsavecontent variable="tql">
		<cfoutput>
			SELECT security.Permission.permissionID, security.Permission.permission
			  FROM security.User
			  JOIN security.Permission
			 WHERE security.User.userID = :user_id
		</cfoutput>
		</cfsavecontent>

		<!--- Create Query Object --->
		<cfset query = getTransfer().createQuery(tql)>
		<cfset query.setParam("user_id",arguments.user_id)>
		<cfset query.setCacheEvaluation(true)>

		<!--- create and return query --->
		<cfreturn getTransfer().listByQuery(query)>
	</cffunction>

	<!--- Get User By Credentials --->
	<cffunction name="getUserByCredentials" output="false" access="public" returntype="codex.model.security.User" hint="Returns an active/confirmed user by its credentials">
		<!--- ************************************************************* --->
		<cfargument name="username" type="string" required="true"/>
		<cfargument name="password" type="string" required="true" hint="This argument is hashed internally."/>
		<!--- ************************************************************* --->
		<cfscript>
			var oUser = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.username = arguments.username;
			sqlProps.password = hash(arguments.password,'SHA-512');
			sqlProps.isConfirmed = 1;
			sqlProps.isActive = 1;
			
			/* Get user now. */
			oUser = getTransfer().readByPropertyMap('security.User', sqlProps);
						
			return oUser;
		</cfscript>
	</cffunction>

	<!--- Get User By Email Address --->
	<cffunction name="getUserByEmail" output="false" access="public" returntype="codex.model.security.User" hint="Returns an active/confirmed user by email address. This is for the password reminder feature.">
		<!--- ************************************************************* --->
		<cfargument name="email" type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			var oUser = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.email = arguments.email;
			sqlProps.isConfirmed = 1;
			sqlProps.isActive = 1;
			
			/* Get user now. */
			oUser = getTransfer().readByPropertyMap('security.User', sqlProps);
						
			return oUser;
		</cfscript>
	</cffunction>
	
	<!--- Get User By Email Address --->
	<cffunction name="isUsernameValid" output="false" access="public" returntype="boolean" hint="Checks if a username is valid.">
		<!--- ************************************************************* --->
		<cfargument name="username" type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			var qUser = "";
			var sqlProps = structnew();
			
			/* Validate Username */
			if( len(trim(arguments.username)) eq 0 ){
				return false;
			}
			
			/* prepare sqlProps */
			sqlProps.username = arguments.username;
			sqlProps.isActive = 1;
			
			/* Get user now. */
			qUser = getTransfer().listByPropertyMap('security.User', sqlProps);
			
			/* Validate Username */
			if( qUser.recordcount ){
				return false;
			}	
			else{
				return true;
			}
		</cfscript>
	</cffunction>

	<!--- Get User with or without id --->
	<cffunction name="getUser" output="false" access="public" returntype="codex.model.security.User" hint="Returns a user by ID or a new user object.">
		<!--- ************************************************************* --->
		<cfargument name="user_id" type="string" required="false" default=""/>
		<!--- ************************************************************* --->
		<cfscript>
			var oUser = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.userid = arguments.user_id;
			
			/* Get user now. */
			oUser = getTransfer().readByPropertyMap('security.User', sqlProps);
						
			return oUser;
		</cfscript>
	</cffunction>

	<!--- Get a User Object --->
	<cffunction name="getDefaultUser" hint="Get a default user from the db." access="public" output="false" returntype="codex.model.security.User">
		<!--- ************************************************************* --->
		<cfscript>
			var oUser = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.isDefault = 1;
			
			/* Get user now. */
			oUser = getTransfer().readByPropertyMap('security.User', sqlProps);
						
			return oUser;
		</cfscript>
	</cffunction>

	<!--- Delete a user --->
	<cffunction name="deleteUser" hint="Deletes a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			getTransfer().delete(arguments.User);
		</cfscript>
	</cffunction>
	
	<!--- Delete a user --->
	<cffunction name="deleteUserPerm" hint="Deletes a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<cfargument name="Permission" required="true" type="codex.model.security.Permission" hint="The permission to add.">
		<!--- ************************************************************* --->
		<cfscript>
			arguments.User.removePermission(arguments.Permission);
			getTransfer().save(arguments.User);
		</cfscript>
	</cffunction>

	<!--- Save the User --->
	<cffunction name="saveUser" hint="Saves a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<cfargument name="isPasswordChange" type="boolean" required="false" default="false" hint="Flag if controller says a password change is needed"/>
		<!--- ************************************************************* --->
		<cfscript>
			/* Hash Password? */
			if( not arguments.User.getIsPersisted() OR arguments.isPasswordChange){
				arguments.User.setPassword( hash(arguments.User.getPassword(),arguments.User.getHashType()) );
			}
			
			/* Set Modify Date */
			arguments.User.setmodifyDate(now());
						
			/* Save User */
			getTransfer().save(arguments.User);
		</cfscript>
	</cffunction>
	
	<cffunction name="registerUser" hint="Registers a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<!--- ************************************************************* --->
		<cfset var email = 0>
		<cfset var CodexOptions = instance.ConfigService.getOptions()>
		<cfset var link = "">
		
		<!--- Save User --->
		<cfset saveUser(arguments.User)>
		
		<!--- Create Link --->
		<cfset link = "#instance.configService.getSetting('sesBaseURL')#/user/validateRegistration/confirm/#arguments.user.getuserid()##instance.configService.getRewriteExtension()#">
		
		<!--- Email --->
		<cfsavecontent variable="email">
		<cfoutput>
		Dear #arguments.user.getfname()# #arguments.user.getlname()#,<br /><br />
		
		Thank you for registering in the #CodexOptions.wiki_name#. Please click on the link below to activate your account.
		You cannot use your account until it has been verified.<br /><br />
		
		<a href="#link#">#link#</a>
		</cfoutput>
		</cfsavecontent>
		
		<!--- Mail It --->
		<cfmail to="#arguments.user.getEmail()#"
			    from="#CodexOptions.wiki_outgoing_email#"
			    subject="#CodexOptions.wiki_name# User Registration"
			    type="HTML">
		<cfoutput>#email#</cfoutput>
		</cfmail>
	</cffunction>
	
	<cffunction name="confirmUser" hint="Confirms a user" access="public" returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<!--- ************************************************************* --->
		<cfif arguments.User.getIsPersisted()>
			<cfset arguments.user.setIsConfirmed(true)>
			<cfset saveUser(arguments.User)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<!--- Save User Perm --->
	<cffunction name="saveUserPerm" hint="Saves a user's Permission" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<cfargument name="Permission" required="true" type="codex.model.security.Permission" hint="The permission to add.">
		<!--- ************************************************************* --->
		<cfscript>
			arguments.User.addPermission(arguments.Permission);
			/* Save User */
			getTransfer().save(arguments.User);
		</cfscript>
	</cffunction>
		
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="queryToStruct" hint="Convert a permissions query to a structure" access="private" output="false" returntype="struct">
		<cfargument name="queryToParse" type="query" required="true"/>
		<!--- The query has two columns: PERMISSION | ACCESS --->
		<cfset var rtnStruct = structnew()>
		<!--- Loop through query --->
		<cfloop query="queryToParse">
			<cfset StructInsert(rtnStruct, permission , access)>
		</cfloop>
		<!--- Return Struct --->
		<cfreturn rtnStruct>
	</cffunction>


</cfcomponent>