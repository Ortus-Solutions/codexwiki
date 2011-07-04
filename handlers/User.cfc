/**
********************************************************************************
* Copyright Since 2011 CodexPlatform
* www.codexplatform.com | www.coldbox.org | www.ortussolutions.com
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
*********************************************************************************/
component extends="BaseHandler" accessors="true"  singleton{
	
	// Dependencies
	property name="SecurityService" 	inject;
	property name="UserService" 		inject;

	//Implicit Properties
	this.prehandler_only = "registration,doregistration";
	
/************************************** IMPLICIT *********************************************/

	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
			
		// Check For Registration setting
		if( NOT rc.CodexOptions.wiki_registration ){
			getPlugin("MessageBox").setMessage(type="warn", message="Wiki registration is not enabled.");
			setNextEvent(rc.xehDashboard);
		}
	}

/************************************** PUBLIC EVENTS *********************************************/	
	
	
	function login(event,rc,prc){
		// js append list
		rc.jsAppendList = "formvalidation";
		
		event.setView("user/login");
	}
	
	function doLogin(event,rc,prc){
		var refRoute 	= event.getValue("_securedURL","");

		// Validate Login 
		if( not event.getTrimValue('username','').length() or
		 	not event.getTrimValue('password','').length() ){
			// Invalid Login
			getPlugin("MessageBox").warn("Please enter all the required fields to log in.");
			// relocate
			setNextEvent("user/login");
		}
		
		// Validate Credentials
		if ( getSecurityService().authenticateUser(rc.username, rc.password) ){
			/// Service logged user in, now just relocate.
			if( findnocase("login",refRoute) OR NOT refRoute.length() ){
				// relocate home if no refRoute found
				setNextEvent(getSetting('ShowKey'));
			}
			else{
				setNextEvent(URL=refRoute);
			}
		}
		else{
			getPlugin("MessageBox").setMessage("error", "The credentials you provided are not valid or your user is not active. Please try again.");
			setNextEvent(event="user/login");
		}
	}
	
	function logout(event,rc,prc){
		getSecurityService().cleanUserSession();		setNextEvent(event=getSetting("showKey"));	}
		function reminder(event,rc,prc){
		// Exit Handlers		rc.xehDoReminder = "user/doPasswordReminder";		// js
		rc.jsAppendList = "formvalidation";
				event.setView("user/reminder");	}	
	function doPasswordReminder(event,rc,prc){		var errors 	= "";		var oUser 	= "";				// Param email		event.paramValue("email","");				// Validate email		if( not trim(rc.email).length() ){			errors = errors & "Please enter an email address<br />";			}		else{
			// Try To get User			oUser = userService.getUserByEmail( rc.email );			if( NOT oUser.getisPersisted() ){				errors = errors & "The email address you entered is not in our system. Please try again.<br />";			}
		}					
		// Check if Errors		if( NOT errors.length() ){			// Send Reminder			getSecurityService().sendPasswordReminder( oUser );			getPlugin("MessageBox").info("Password reminder sent!");		}		else{			getPlugin("MessageBox").error(messageArray=errors);		}		// Re Route		setNextEvent("user/reminder");	}
	
	function registration(event,rc,prc){
		// Exit Handler
		rc.xehDoRegistration = "user/doRegistration";
		rc.xehValidateUsername = "user/usernameCheck";
		// JS
		rc.jsAppendList = "formvalidation";
		
		event.setView('user/registration');
	}
	
	function doRegistration(event,rc,prc){
		var oUser 			= "";
		var errors 			= ArrayNew(1);
		
		// Validate Password comparison
		if( compare(rc.password,rc.c_password) neq 0 ){
			ArrayAppend(errors,"The passwords you entered are not the same. Please try again.");
		}
		
		// Validate Captcha
		if( not getMyPlugin("Captcha").validate( rc.captchacode ) ){
			ArrayAppend(errors, "Invalid security code. Please try again.");
		}
		
		// Check valid username
		if( not userService.isUsernameValid( event.getValue("username","") ) ){
			ArrayAppend(errors,"The username you choose is already taken. Please try another one.");
		}
		
		// Validate
		if( arraylen(errors) ){
			getPlugin("MessageBox").error(messageArray=errors);
			// Back to Registration
			registration(arguments.event);
			return;
		}
		
		// create new user object and populate it with form data
		oUser = populateModel( userService.getUser() );
		// Validate it
		errors = oUser.validate();
		// Error Checks on user creation
		if( arraylen(errors) ){
			getPlugin("MessageBox").error(messageArray=errors);
			// Back to Registration
			registration(arguments.event);
			return;			
		}
		else{
			// Set Default Wiki Role for successful registration: TODO: Move to service layer
			oUser.setRole( userService.getRole(rc.CodexOptions.wiki_defaultrole_id) );
			// Set Unconfirmed, jsut to be safe. TODO: Move to service layer
			oUser.setisConfirmed( false );
			// Register User
			userService.registerUser( oUser );
			// Set Messages
			getPlugin("MessageBox").info("User added successfully");
			setNextEvent("user/RegistrationConfirmation");
		}
	}
	
	function usernameCheck(event,rc,prc){
		var valid 	= false;
		
		event.paramValue("username","");
		
		if( NOT len(rc.username) ){
			valid = false;
		}
		else{
			valid = userService.isUsernameValid( rc.username );
		}
		
		event.renderdata(data=valid);
	}
	
	function validateRegistration(event,rc,prc){
		// create new user object according to incoming confirmation number
		rc.oUser = userService.getUser( event.getValue('confirm','') );
		
		// Validate confirmation number
		if(NOT userService.confirmUser( rc.oUser ) ){
			getPlugin("MessageBox").warn("The confirmation number is not valid!");
		}
		else{
			getPlugin("MessageBox").info("Confirmation number is valid! Thank You!");
		}
		
		event.setView("user/validated");			
	}
	
	function registrationConfirmation(event,rc,prc){
		event.setView('user/confirmation');
	}
	
}