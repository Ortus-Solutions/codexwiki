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
<cfcomponent name="user"			 extends="codex.handlers.baseHandler"			 output="false"			 hint="The user profile handler"			 autowire="true">
	<!--- Dependencies --->
	<cfproperty name="UserService" type="ioc" scope="instance">
<!------------------------------------------- PUBLIC ------------------------------------------->	<!--- preHandler --->
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="Pre handler operation">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>			var rc = event.getCollection();			/* Exit Handlers For entire handler */			rc.xehUserChangePass = "profile/user/changepassword";			rc.xehUserProfile = "profile/user/details";		</cfscript>
	</cffunction>	<!--- Profile --->	<cffunction name="details" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<cfscript>			var rc = event.getCollection();			/* Exit Handlers */			rc.xehEditProfile = "profile/user/editprofile";			/* Get Perms */			rc.userPerms = rc.oUser.getPermissions();			/* User Details */			event.setView("profile/details");		</cfscript>	</cffunction>	<!--- editProfile --->
	<cffunction name="editProfile" access="public" returntype="void" output="false" hint="Edit the profile">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>			var rc = event.getCollection();			/* Exit Handlers */			rc.xehDoEdit = "profile/user/doEditProfile";
			/* JS */
			rc.jsAppendList = "formvalidation";			/* User Details */			event.setView("profile/editor");		</cfscript>
	</cffunction>	<!--- doeditProfile --->	<cffunction name="doEditProfile" access="public" returntype="void" output="false" hint="Edit the profile">		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">	    <cfscript>			var rc = event.getCollection();			/* Validate form */			if( not trim(event.getValue("fname","")).length() or			    not trim(event.getValue("lname","")).length() or			    not trim(event.getValue("email","")).length()){				/* errors */				getPlugin("messagebox").setMessage("error", "Please enter all required fields");				setNextRoute("profile/user/editProfile");			}			/* Validate Email */			if( not getPlugin("Utilities").isEmail(rc.email) ){				/* errors */				getPlugin("messagebox").setMessage("error", "The email address you entered #rc.email# is not a valid email address.");				setNextRoute("profile/user/editProfile");			}			/* No more errors, just save */			getPlugin("beanFactory").populateBean(rc.oUser);			rc.oUser.setModifyDate(now());			getUserService().saveUser(rc.oUser);			getPlugin("messagebox").setMessage("info", "Your details where updated!");			setNextRoute('profile/user/details');		</cfscript>	</cffunction>	<!--- changepassword --->
	<cffunction name="changepassword" access="public" returntype="void" output="false" hint="Change password form">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>			var rc = event.getCollection();			/* Exit Handlers */			rc.xehdoChangePass = "profile/user/doChangePassword";
			/* JS */
			rc.jsAppendList = "formvalidation";			/* User Details */			event.setView("profile/changepassword");		</cfscript>
	</cffunction>	<!--- do change password --->	<cffunction name="doChangePassword" access="public" returntype="any" hint="" output="false" >		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">	    <cfscript>			var rc = event.getCollection();			var errors = "";			/* Test */			if( not trim(event.getValue("c_password","")).length() or			    not trim(event.getValue("n_password","")).length() or			    not trim(event.getValue("n2_password","")).length() ){			    /* error box.  */				getPlugin("messagebox").setMessage("error", "Please enter all the required fields");			}			else{				/* Validate Passwords */				if( compare(rc.oUser.getPassword(), hash(rc.c_password,rc.oUser.getHashType())) neq 0 ){					 /* error box.  */					errors = errors & "- Your current password does not match what you entered.<br />";				}				/* New Check */				if( compare(rc.n_password, rc.n2_password) neq 0 ){					/* error box.  */					errors = errors & "- Your new passwords do not confirm. Please try again.<br />";				}				/* Validate Now */				if( not errors.length() ){					/* Save the new password. */					rc.oUser.setPassword( rc.n_password );					getUserService().saveUser(User=rc.oUser,isPasswordChange=true);
					/* Message */					getPlugin("messagebox").setMessage("info","Password update complete.");				}				else{					getPlugin("messagebox").setMessage("error",errors);				}			}//errors on form			/* Back to same page */			setNextRoute("profile/user/changepassword");		</cfscript>
	</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->
	<!--- Get the UserService --->	<cffunction name="getUserService" access="private" returntype="codex.model.security.UserService" output="false">
		<cfreturn instance.UserService>
	</cffunction></cfcomponent>