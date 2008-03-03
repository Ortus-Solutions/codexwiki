<cfcomponent hint="This is the user service using Transfer" output="false">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" output="false" returntype="UserService">
		<!--- ************************************************************* --->
		<cfargument name="transfer" 	hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
		<cfargument name="transaction" 	hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			instance = StructNew();
	
			setTransfer(arguments.transfer);
	
			arguments.transaction.advise(this, "^save");
	
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

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
		<cfargument name="password" type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			var oUser = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			sqlProps.username = arguments.username;
			sqlProps.password = arguments.password;
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
			getTransfer().save(arguments.User);
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
<!------------------------------------------- ACCESSORS/MUTATORS ------------------------------------------->

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