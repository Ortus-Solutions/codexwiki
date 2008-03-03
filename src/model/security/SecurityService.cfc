<cfcomponent name="SecurityService" hint="This service takes care of authentication and security." output="false">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" returntype="SecurityService" output="false">
		<cfscript>
			instance = StructNew();
			
			/* User session Key */
			setUserSessionKey('oUserTO');
			
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- Authenticate a user in the system --->
	<cffunction name="authenticateUser" output="false" access="public" returntype="boolean"
				hint="Authenticate a User. If valid it places them in session. Returns true if user is valid and authenticated and ready for usage.">
		<!--- ************************************************************* --->
		<cfargument name="username" type="string" required="true"/>
		<cfargument name="password" type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			/* Prepare results */
			var results = false;
			var oUserTO = "";
			
			/* Try to get user by credentials */
			oUserTO = getUserService().getUserByCredentials(argumentCollection=arguments);
	
			//Is User in system.
			if ( oUserTO.getIsPersisted() ){
				//Set User to Authorized
				oUserTO.setisAuthorized(true);
				//Save User State
				getSessionStorage().setVar(getuserSessionKey(), oUserTO);
				//Set Return Flags
				results.authenticated = true;
			}
			
			/* Return Results */
			return results;
		</cfscript>
	</cffunction>
	
	<!--- ************************************************************* --->
	
	<!--- Send a Password Reminder --->
	<cffunction name="passwordReminder" output="false" access="public" returntype="void"
				hint="This will generate a new password, set it and send it to the user.">
		<!--- ************************************************************* --->
		<cfargument name="user" type="codex.model.security.User" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			
		</cfscript>
	</cffunction>
	
	<!--- ************************************************************* --->
	
	<!--- Get A User Session --->
	<cffunction name="getUserSession" output="false" access="public" returntype="codex.model.security.User"
				hint="This method checks if a user is in an authorized session, else it returns the default user object.">
		<cfscript>
			var oUserTO = "";
			
			//Is user in session
			if ( getSessionStorage().exists( getuserSessionKey() ) ){
				oUserTO = getSessionStorage().getVar( getuserSessionKey() );
			}
			else{
				//Get Default User
				oUserTO = getUserService().getDefaultUser();
			}
			
			return oUserTO;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- Clean a user's session. --->
	<cffunction name="cleanUserSession" output="false" access="public" returntype="void" hint="This method will clean the user session.">
		<cfscript>
			return getSessionStorage().deleteVar( getuserSessionKey() );
		</cfscript>
	</cffunction>

<!------------------------------------------- ACCESSOR/MUTATORS ------------------------------------------->

	<!--- getter and setter for sessionstorage --->
	<cffunction name="getsessionstorage" access="public" returntype="any" output="false">
		<cfreturn instance.sessionstorage>
	</cffunction>
	<cffunction name="setsessionstorage" access="public" returntype="void" output="false">
		<cfargument name="sessionstorage" type="any" required="true">
		<cfset instance.sessionstorage = arguments.sessionstorage>
	</cffunction>

	<!--- getter and setter for UserService --->
	<cffunction name="getUserService" access="public" returntype="codex.model.security.UserService" output="false">
		<cfreturn instance.UserService>
	</cffunction>
	<cffunction name="setUserService" access="public" returntype="void" output="false">
		<cfargument name="UserService" type="codex.model.security.UserService" required="true">
		<cfset instance.UserService = arguments.UserService>
	</cffunction>
	
	<!--- getter and setter for userSessionKey --->
	<cffunction name="getuserSessionKey" access="public" returntype="string" output="false">
		<cfreturn instance.userSessionKey>
	</cffunction>
	<cffunction name="setuserSessionKey" access="public" returntype="void" output="false">
		<cfargument name="userSessionKey" type="string" required="true">
		<cfset instance.userSessionKey = arguments.userSessionKey>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Get the util object --->
	<cffunction name="getUtil" output="false" access="private" returntype="codex.model.util.utility" hint="Utility Object">
		<cfreturn CreateObject("component","codex.model.util.utility")>
	</cffunction>

</cfcomponent>