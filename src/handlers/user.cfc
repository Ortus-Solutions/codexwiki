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
<cfcomponent name="user"			 extends="baseHandler"			 output="false"			 hint="Our main handler for user interactivity."			 autowire="true"			 cache="true" cacheTimeout="0">
	<!--- Dependencies --->
	<cfproperty name="SecurityService" 	type="ioc" scope="instance" />
	<cfproperty name="UserService" 		type="ioc" scope="instance" />

	<!--- Implicit Properties --->
	<cfset this.prehandler_only = "registration,doregistration">

<!----------------------------------------- IMPLICIT ------------------------------------->	

	<!--- preHandler --->
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="Handler interceptor">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var rc = event.getCollection();
			
			/* Check For Registration setting */
			if( not rc.CodexOptions.wiki_registration ){
				getPlugin("messagebox").setMessage(type="warning", message="Wiki registration is not enabled.");
				setNextRoute(rc.xehDashboard);
			}
		</cfscript>
	</cffunction>	
<!------------------------------------------- PUBLIC ------------------------------------------->	<cffunction name="login" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();			/* JS */
			rc.jsAppendList = "formvalidation";
			
			/* login view */			event.setView("users/login");		</cfscript>	</cffunction>	<cffunction name="doLogin" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var refRoute = event.getValue("_securedURL","");

			/* Validate */
			if( not trim(event.getValue('username','')).length() or
			 	not trim(event.getValue('password','')).length() ){
				/* Invalid Login */
				getPlugin("messagebox").setMessage("warning", "Please enter all the required fields to log in.");
				/* relocate to invalid route */
				setNextRoute(route="user/login");
			}
			
			/* Validate Credentials */
			if ( getSecurityService().authenticateUser(rc.username,rc.password) ){
				/* Service logged user in, now just relocate. */
				if( findnocase("login",refRoute) or refRoute.length() eq 0 ){
					setNextRoute(getSetting('ShowKey'));
				}
				else{
					relocate(refRoute);
				}
			}
			else{
				getPlugin("messagebox").setMessage("error", "The credentials you provided are not valid or your user is not active. Please try again.");
				setNextRoute(route="user/login");
			}
		</cfscript>
	</cffunction>	<cffunction name="logout" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			getSecurityService().cleanUserSession();			setNextRoute(route=getSetting("showKey"));		</cfscript>			</cffunction>	<cffunction name="reminder" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();						/* Exit Handlers */			rc.xehDoReminder = "user/doPasswordReminder";			/* JS */
			rc.jsAppendList = "formvalidation";
						event.setView("users/reminder");		</cfscript>	</cffunction>	<cffunction name="doPasswordReminder" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();			var errors = "";			var oUser = "";						/* Param email */			event.paramValue("email","");						/* Validate email */			if( not trim(rc.email).length() ){				errors = errors & "Please enter an email address<br />";				}			if( not getPlugin("Utilities").isEmail(rc.email) ){				errors = errors & "The email you entered is not a valid email address: #rc.email#<br />";			}			/* Try To get User */			oUser = getUserService().getUserByEmail(rc.email);			if( not oUser.getisPersisted() ){				errors = errors & "The email address you entered is not in our system. Please try again.<br />";			}						/* Check if Errors */			if( not errors.length() ){				/* Send Reminder */				getSecurityService().sendPasswordReminder(oUser);				getPlugin("messagebox").setMessage("info", "Password reminder sent!");			}			else{				getPlugin("messagebox").setMessage("error", errors);			}			/* Re Route */			setNextRoute("user/reminder");		</cfscript>	</cffunction>
	
	<!--- registration --->
	<cffunction name="registration" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfset var rc = event.getCollection()>
	    <cfscript>
			/* Exit Handler */
			rc.xehDoRegistration = "user/doRegistration";
			rc.xehValidateUsername = "user/usernameCheck";
			/* JS */
			rc.jsAppendList = "formvalidation";
			/* View */
			event.setView('users/registration');
		</cfscript>
	</cffunction>
	
	<!--- doRegistration --->
	<cffunction name="doRegistration" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	  <cfscript>
			var rc = event.getCollection();
			var oUser = "";
			var oUserService = getUserService();
			var errors = ArrayNew(1);
			
			/* Validate Passwords */
			if( compare(rc.password,rc.c_password) neq 0 ){
				ArrayAppend(errors,"The passwords you entered are not the same. Please try again.");
			}
			
			/* Validate Captcha */
			if( not getMyPlugin("captcha").validate(rc.captchacode) ){
				ArrayAppend(errors, "Invalid security code. Please try again.");
			}
			
			if( not getUserService().isUsernameValid(event.getValue("username","")) ){
				ArrayAppend(errors,"The username you choose is already taken. Please try another one.");
			}
			
			/* Validate */
			if( arraylen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				/* Run Registration */
				registration(arguments.event);
				return;
			}
			
			/* create new user object. */
			oUser = oUserService.getUser();
			/* Populate it */
			getPlugin("beanFactory").populateBean(oUser);
			/* Validate it */
			errors = oUser.validate();
			/* Error Checks */
			if( arraylen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				setNextRoute(route="admin.users/new");
			}
			else{
				/* Set Default Wiki Role */
				oUser.setRole(oUserService.getRole(rc.CodexOptions.wiki_defaultrole_id));
				/* Set Unconfirmed, jsut to be safe. */
				oUser.setisConfirmed(false);
				/* Save User */
				oUserService.registerUser(oUser);
				/* Set Messagebox */
				getPlugin("messagebox").setMessage("info","User added successfully");
				setNextRoute(route="user/RegistrationConfirmation");
			}
		</cfscript> 
	</cffunction>
	
	<!--- usernameCheck --->
	<cffunction name="usernameCheck" access="public" returntype="void" output="false" hint="Check a username">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>
			var rc = event.getCollection();
			var valid = false;
			
			if( len(event.getTrimValue("username","")) eq 0){
				valid = false;
			}
			else{
				valid = getUserService().isUsernameValid(event.getValue("username",""));
			}
			/* Render Data */
			event.renderdata(data=valid);
		</cfscript> 
	</cffunction>
	
	<!--- validateRegistration --->
	<cffunction name="validateRegistration" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>
			var rc = event.getCollection();
			var oUserService = getUserService();
			
			
			/* create new user object. */
			rc.oUser = oUserService.getUser(event.getValue('confirm',''));
			/* Validate */
			if(not oUserService.confirmUser(rc.oUser) ){
				getPlugin("messagebox").setMessage(type="warning", message="The confirmation number is not valid.");
			}
			else{
				getPlugin("messagebox").setMessage(type="info", message="Confirmation number is valid");
			}
			event.setView("users/validated");			
		</cfscript>
	</cffunction>
	
	<!--- RegistrationConfirmation --->
	<cffunction name="RegistrationConfirmation" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfset var rc = event.getCollection()>
	    
	    <cfset event.setView('users/confirmation')>
	</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->
	<!--- Get the security service --->	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
		<cfreturn instance.SecurityService>
	</cffunction>		<!--- Get the User service --->	<cffunction name="getUserService" access="private" returntype="codex.model.security.UserService" output="false">		<cfreturn instance.UserService>	</cffunction></cfcomponent>