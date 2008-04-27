<cfcomponent hint="This is the user service using Transfer" output="false">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" output="false" returntype="UserService">
		<!--- ************************************************************* --->
		<cfargument name="transfer" 	hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
		<cfargument name="transaction" 	hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
		<cfargument name="Datasource" 	hint="the Datasource obj" type="transfer.com.sql.Datasource" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			instance = StructNew();
	
			setTransfer(arguments.transfer);
			setDatasource(arguments.datasource);
	
			arguments.transaction.advise(this, "^save");
	
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

	<!--- ************************************************************* --->
	
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

	<!--- ************************************************************* --->
	
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

	<!--- ************************************************************* --->
	
	<!--- find Users --->
	<cffunction name="findUsers" output="false" access="public" returntype="query" hint="Find Users in the database.">
		<!--- ************************************************************* --->
		<cfargument name="criteria" required="true" 	type="string" 	hint="The search criteria: fname,lname,email">
		<cfargument name="active" 	required="false" 	type="boolean"	default="true"	hint="Active or not user.">
		<cfargument name="role_id" 	required="false" 	type="string" 	default="0"		hint="The role id to search on.">
		<cfargument name="startRow" required="false" 	type="string"	default="1" 	hint="The row offset">
		<cfargument name="maxRows" 	required="false" 	type="string"	default="" 		hint="The max rows to retrieve">
		<!--- ************************************************************* --->
		<cfset var qUsers = "">
		<cfset var qFoundRows = "">
		
		<!--- Search Users with Paging --->
		<cftransaction>
			<cfquery name="qUsers" datasource="#getDatasource().getName()#">
				SELECT SQL_CALC_FOUND_ROWS
					   Users.user_id, Users.user_fname, Users.user_lname, Users.user_email, Users.user_isActive,
					   Users.user_isConfirmed, Users.user_create_date, Users.user_modify_date, Roles.role
				  FROM wiki_users as Users, wiki_roles as Roles
				 WHERE Users.FKrole_id = Roles.role_id
				   AND Users.user_isActive = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">
				 
				 <!--- Search Criteria, If Found --->
				 <cfif arguments.criteria.length() neq 0>
				   AND ( Users.user_fname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> OR
				   		 Users.user_lname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> OR
				   		 Users.user_email like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.criteria#%"> )
				 </cfif>
				 
				 <!--- Role, If Found --->
				 <cfif arguments.role_id neq 0>
				   AND Roles.role_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role_id#">
				 </cfif>
				 
				 <!--- Paging Limits--->
				 <cfif isNumeric(arguments.maxRows)>
				  LIMIT <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.startRow-1#">,
				  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.maxRows#">
				 </cfif>
			</cfquery>
			<cfquery name="qFoundRows" datasource="#getDatasource().getName()#">
				SELECT found_rows() AS foundRows
			</cfquery>
		</cftransaction>
		
		<!--- Add Found Rows to Paging --->
		<cfif qUsers.recordcount>
			<cfset queryAddColumn(qUsers,"foundRows",listToArray(qFoundRows.foundRows))>
		</cfif>
		
		<cfreturn qUsers>
	</cffunction>

	<!--- ************************************************************* --->

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

	<!--- ************************************************************* --->
	
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
			sqlProps.password = hash(arguments.password, getHashType());
			sqlProps.isConfirmed = 1;
			sqlProps.isActive = 1;
			
			/* Get user now. */
			oUser = getTransfer().readByPropertyMap('security.User', sqlProps);
						
			return oUser;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
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

	<!--- ************************************************************* --->
	
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

	<!--- ************************************************************* --->
	
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

	<!--- ************************************************************* --->
	
	<!--- Get User By Credentials --->
	<cffunction name="deleteUser" hint="Deletes a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			getTransfer().delete(arguments.User);
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- Save the User --->
	<cffunction name="saveUser" hint="Saves a user" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="User" hint="The User object" type="codex.model.security.User" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			/* Hash Password? */
			if( not arguments.User.getIsPersisted() ){
				arguments.User.setPassword( hash(arguments.User.getPassword(),getHashType()) );
			}
			else if( arguments.User.getPassword().length() neq 0 ){
				arguments.User.setPassword( hash(arguments.User.getPassword(),getHashType()) );
			}
			/* Save User */
			getTransfer().save(arguments.User);
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
<!------------------------------------------- ACCESSORS/MUTATORS ------------------------------------------->

		<!--- Get/set HashType --->
	<cffunction name="gethashType" access="public" output="false" returntype="string" hint="Get hashType">
		<cfreturn instance.hashType/>
	</cffunction>	
	<cffunction name="sethashType" access="public" output="false" returntype="void" hint="Set hashType">
		<cfargument name="hashType" type="string" required="true"/>
		<cfset instance.hashType = arguments.hashType/>
	</cffunction>
	
	<!--- Get Set Datasource --->
	<cffunction name="getDatasource" access="private" output="false" returntype="transfer.com.sql.Datasource" hint="Get Datasource">
		<cfreturn instance.Datasource/>
	</cffunction>	
	<cffunction name="setDatasource" access="private" output="false" returntype="void" hint="Set Datasource">
		<cfargument name="Datasource" type="transfer.com.sql.Datasource" required="true"/>
		<cfset instance.Datasource = arguments.Datasource/>
	</cffunction>
	
	<!--- Get Set Transfer --->
	<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
		<cfreturn instance.transfer />
	</cffunction>	
	<cffunction name="setTransfer" access="private" returntype="void" output="false">
		<cfargument name="transfer" type="transfer.com.Transfer" required="true">
		<cfset instance.transfer = arguments.transfer />
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