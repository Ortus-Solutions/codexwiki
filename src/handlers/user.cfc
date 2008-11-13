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
	<!------------------------------------------- PUBLIC ------------------------------------------->	<cffunction name="login" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();			/* Right login view */			event.setView("users/login");		</cfscript>	</cffunction>	<cffunction name="doLogin" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var refRoute = event.getValue("refRoute","");

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
	</cffunction>	<cffunction name="logout" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			getSecurityService().cleanUserSession();			setNextRoute(route=event.getValue('xehDashboard'));		</cfscript>			</cffunction>	<cffunction name="reminder" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();						/* Exit Handlers */			rc.xehDoReminder = "user/doPasswordReminder.cfm";						event.setView("users/reminder");		</cfscript>	</cffunction>	<cffunction name="doPasswordReminder" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();			var errors = "";			var oUser = "";						/* Param email */			event.paramValue("email","");						/* Validate email */			if( not trim(rc.email).length() ){				errors = errors & "Please enter an email address<br />";				}			if( not getPlugin("Utilities").isEmail(rc.email) ){				errors = errors & "The email you entered is not a valid email address: #rc.email#<br />";			}			/* Try To get User */			oUser = getUserService().getUserByEmail(rc.email);			if( not oUser.getisPersisted() ){				errors = errors & "The email address you entered is not in our system. Please try again.<br />";			}						/* Check if Errors */			if( not errors.length() ){				/* Send Reminder */				getSecurityService().sendPasswordReminder(oUser);				getPlugin("messagebox").setMessage("info", "Password reminder sent!");			}			else{				getPlugin("messagebox").setMessage("error", errors);			}			/* Re Route */			setNextRoute("user/reminder");		</cfscript>	</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->
	<!--- Get the security service --->	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
		<cfreturn instance.SecurityService>
	</cffunction>		<!--- Get the User service --->	<cffunction name="getUserService" access="private" returntype="codex.model.security.UserService" output="false">		<cfreturn instance.UserService>	</cffunction></cfcomponent>