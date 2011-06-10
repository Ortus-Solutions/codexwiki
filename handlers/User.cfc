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
<cfcomponent name="user"
	<!--- Dependencies --->
	<cfproperty name="SecurityService" 	inject="ioc" scope="instance" />
	<cfproperty name="UserService" 		inject="ioc" scope="instance" />

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
<!------------------------------------------- PUBLIC ------------------------------------------->
			rc.jsAppendList = "formvalidation";
			
			/* login view */
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
	</cffunction>
			rc.jsAppendList = "formvalidation";
			
	
	<!--- registration --->
	<cffunction name="registration" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
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
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
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
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
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
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
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
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
	    <cfset var rc = event.getCollection()>
	    
	    <cfset event.setView('users/confirmation')>
	</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

		<cfreturn instance.SecurityService>
	</cffunction>