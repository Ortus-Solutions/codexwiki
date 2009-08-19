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
<cfcomponent name="SecurityService" 
			 hint="This service takes care of authentication and security." 
			 output="false"
			 extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" returntype="SecurityService" output="false">
		<!--- ************************************************************* --->
		<cfargument name="configBean" 	hint="the ColdBox config Bean"  type="coldbox.system.beans.configBean" required="Yes">
		<cfargument name="transfer" 	hint="the Transfer ORM" 		type="transfer.com.Transfer" required="Yes">
		<cfargument name="transaction" 	hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
		<cfargument name="ConfigService" 	required="true" type="codex.model.wiki.ConfigService" hint="The config service">
		<!--- ************************************************************* --->
		<cfscript>
			/* Init */
			super.init(argumentCollection=arguments);
			
			/* Set properties */
			instance.UserSessionKey = 'auth_user_id';
			instance.configBean = arguments.configBean;
			instance.configService = arguments.configService;
			
			/* Advices */
			arguments.transaction.advise(this, "^sendPasswordReminder");
			
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- User Validator for security --->
	<cffunction name="userValidator" access="public" returntype="boolean" output="false" hint="Verifies that the user is in any permission">
		<!--- ************************************************************* --->
		<cfargument name="rule" 	required="true" type="struct"   hint="The rule to verify">
		<cfargument name="messagebox" type="coldbox.system.plugins.messagebox" required="true" hint="The ColdBox messagebox plugin. You can use to set a redirection message"/>
		<!--- ************************************************************* --->
		<cfset var oUser = getUserSession()>
		<cfset var authResults = false>
		<cfset var permResults = false>
		<cfset var thisPermission = "">
				
		<!--- Authorized Check, if true, then see if user is valid. --->
		<cfif arguments.rule['authorize_check']>
			<cfif oUser.getisAuthorized()>
				<cfset authResults = true>
			</cfif>
		<cfelse>
			<cfset authResults = true>
		</cfif>		
		
		<!--- Loop Over Permissions --->
		<cfif len(arguments.rule.permissions)>
			<cfloop list="#arguments.rule['permissions']#" index="thisPermission">
				<cfif oUser.checkPermission( thisPermission ) >
					<cfset permResults = true>
					<cfbreak>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset permResults = true>
		</cfif>
		
		<!--- Messagebox --->
		<cfif permResults EQ FALSE AND authResults EQ FALSE>
			<cfset arguments.messagebox.setMessage("warning","You are not authorized to view this page.")>
		</cfif>	
		
		<cfreturn (permResults AND authResults)>
	</cffunction>
					
	<!--- Authenticate a user in the system --->
	<cffunction name="authenticateUser" output="false" access="public" returntype="boolean"
				hint="Authenticate a User. If valid it places them in session. Returns true if user is valid and authenticated and ready for usage.">
		<!--- ************************************************************* --->
		<cfargument name="username" type="string" required="true"/>
		<cfargument name="password" type="string" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			/* Prepare results */
			var authenticated = false;
			var oUserTO = "";

			/* Try to get user by credentials */
			oUserTO = getUserService().getUserByCredentials(argumentCollection=arguments);

			//Is User in system.
			if ( oUserTO.getIsPersisted() ){
				//Save User State
				getSessionStorage().setVar(getuserSessionKey(), oUserTO.getuserID());
				//Set Return Flags
				authenticated = true;
			}

			/* Return Results */
			return authenticated;
		</cfscript>
	</cffunction>

	<!--- Send a Password Reminder --->
	<cffunction name="sendPasswordReminder" output="false" access="public" returntype="void"
				hint="This will generate a new password, set it and send it to the user.">
		<!--- ************************************************************* --->
		<cfargument name="user" type="codex.model.security.User" required="true"/>
		<!--- ************************************************************* --->
		<cfscript>
			var genPassword = "";
			var email = "";
			var CodexOptions = instance.ConfigService.getOptions();
			var link = "#instance.configBean.getKey('sesBaseURL')#/user/login.cfm";
		
			/* Generate a password */
			genPassword = hash(arguments.user.getEmail() & createUUID() & now());
			
			/* Save it on User and save. */
			arguments.user.setPassword(genPassword);
			getUserService().saveUser(User=arguments.user,isPasswordChange=true);
		</cfscript>
		
		<!--- Email --->
		<cfsavecontent variable="email">
		<cfoutput>
		A new password has been generated for you: <strong>#genPassword#</strong><br />
		Please use this password with your current username and login to your account.<br /><br />
		
		<a href="#link#">Click here to login</a>
		<br /><br />
		Login Link: #link#
		</cfoutput>
		</cfsavecontent>
		<!--- Mail It --->
		<cfmail to="#arguments.user.getEmail()#"
			    from="#CodexOptions.wiki_outgoing_email#"
			    subject="#CodexOptions.wiki_name# Password Reminder"
			    type="HTML">
		<cfoutput>#email#</cfoutput>
		</cfmail>		
	</cffunction>

	<!--- Get A User Session --->
	<cffunction name="getUserSession" output="false" access="public" returntype="codex.model.security.User"
				hint="This method checks if a user is in an authorized session, else it returns the default user object.">
		<cfscript>
			var oUser = "";
			var getByDefault = true;

			//Is user in session
			if ( getSessionStorage().exists( getuserSessionKey() ) ){
				oUser = getUserService().getUser(user_id=getSessionStorage().getVar( getuserSessionKey() ));
				/* Validate its a good User */
				if( oUser.getIsPersisted() and oUser.getIsActive() and oUser.getISConfirmed() ){
					/* We got it!! */
					getByDefault = false;
					/* Authenticate User */
					oUser.setisAuthorized(true);
				}
			}
			/* Get by Default */
			if( getByDefault ){
				//Get Default User
				oUser = getUserService().getDefaultUser();
			}
			/* Return User Object */
			return oUser;
		</cfscript>
	</cffunction>

	<!--- Clean a user's session. --->
	<cffunction name="cleanUserSession" output="false" access="public" returntype="void" hint="This method will clean the user session.">
		<cfscript>
			getSessionStorage().deleteVar( getuserSessionKey() );
		</cfscript>
	</cffunction>
	
	<!--- Get Security Rules --->
	<cffunction name="getSecurityRules" output="false" access="public" returntype="query" hint="Get the security Rules">
		<cfscript>
			var query = "";
			
			query = getTransfer().list('security.SecurityRules');
			
			return query;
		</cfscript>
	</cffunction>
	
	<!--- Authorize a Protected Page --->
	<cffunction name="authorizePage" access="public" returntype="boolean" hint="Check Authorize a user to view a page" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="page" required="true" type="codex.model.wiki.Page" hint="The page object to check">
		<cfargument name="password" type="string" required="true" default="" hint="The user password to check for verification"/>
		<!--- ************************************************************* --->
		<cfscript>
			// Validate Password
			if( compare(arguments.page.getPassword(),arguments.password) eq 0 ){
				// Set cookie
				cookie["protection-#hash(arguments.page.getName())#"] = hash(arguments.page.getName() & arguments.page.getPassword());
				return true;
			}
			
			return false;
		</cfscript>
	</cffunction>	
	
	<!--- Check if a potected page is viewable --->
	<cffunction name="isPageViewable" access="public" returntype="boolean" hint="Checks Whether a page is protected and user has cookie for it" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="page" required="true" type="codex.model.wiki.Page" hint="The page object to check">
		<!--- ************************************************************* --->
		<cfif structKeyExists(cookie,"protection-#hash(arguments.page.getName())#") AND
			  compare(cookie["protection-#hash(arguments.page.getName())#"],hash(arguments.page.getName() & arguments.page.getPassword())) EQ 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
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
	
	<!--- Get/Set config bean. --->
	<cffunction name="getconfigBean" access="public" returntype="coldbox.system.beans.configBean" output="false">
		<cfreturn instance.configBean>
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
	

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>