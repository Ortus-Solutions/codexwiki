<cfoutput>
<cfif not rc.oUser.getisAuthorized()>
	<h1 onclick="toggleItems('sb_userinfo')"> <img src="includes/images/key.png" alt="login"/> User Login </h1>
<cfelse>
	<h1 onclick="toggleItems('sb_userinfo')"> <img src="includes/images/user.png" alt="info"/> User Info </h1>
</cfif>

<div class="left-box" id="sb_userinfo">
	
	<cfif not rc.oUser.getisAuthorized()>
		<!--- Only show for non login event --->
		<cfif not listfindnocase("user.login,user.registration",event.getCurrentEvent())>
		<!--- Don't Show if in login event' --->
		<form name="loginform" id="loginform" method="post" action="#event.buildLink(rc.xehUserDoLogin)#" onsubmit="onLoginForm()">
			<!--- ref Route --->
			<cfif structKeyExists(rc,"_securedURL")>
			<input type="hidden" name="_securedURL" value="#event.getValue("_securedURL","")#">
			<cfelse>
			<!--- TODO: abstract the cgi and path info into the request context --->
			<input type="hidden" name="_securedURL" value="#cgi.script_name##cgi.path_info#">
			</cfif>
			<p>
			<label for="username">Username</label>
			<input type="text" name="username" id="username" size="20" maxlength="50" />
			
			<label for="username">Password</label>
			<input type="password" name="password" id="password" size="20" maxlength="50" />
			
			<br />
			
			<!--- Loader --->
			<div id="_loader_login" class="align-center formloader">
				<p>
					Submitting...<br />
					<img src="includes/images/ajax-loader-horizontal.gif" alt="loader"/>
					<img src="includes/images/ajax-loader-horizontal.gif" alt="loader"/>
				</p>
			</div>
			
			<!--- Button Bar --->
			<div align="center" id="_buttonbar_login">
				<a href="#event.buildLink(rc.xehUserReminder)#">Forgot Password?</a>
				<!--- Registration Permission Link --->
				<cfif rc.CodexOptions.wiki_registration> | <a href="#event.buildLink(rc.xehUserRegistration)#">Register</a></cfif>
				<br /><br />
				<input type="submit" class="submitButton" value="Log In" name="loginbutton" id="loginbutton" />
			</div>
			<br />
			</p>
		</form>
		<cfelse>
			<br /><br />
			<!--- Button Bar --->
			<div align="center" id="_buttonbar_login">
				<a href="#event.buildLink(rc.xehUserReminder)#">Forgot Password?</a>
				<!--- Registration Permission Link --->
				<cfif rc.CodexOptions.wiki_registration> | <a href="#event.buildLink(rc.xehUserRegistration)#">Register</a></cfif>
				<br /><br />
				<input type="button" class="submitButton" value="Log In" name="loginbutton" id="loginbutton" 
					   onclick="window.location='#event.buildLink(rc.xehUserLogin)#'"/>
			</div>
			<br />
		</cfif>
	<cfelse>
		<p>
			Welcome back <strong>#rc.oUser.getfname()# #rc.oUser.getlname()#</strong>!
			<br />
			<strong>Your Role:</strong> #rc.oUser.getRole().getRole()#
		</p>
		<br />
		<!--- Button Bar --->
		<div align="center" id="_buttonbar_login">
			<a href="#event.buildLink(rc.xehUserLogout)#" class="buttonLinks">
				<span>
					<img src="includes/images/door_out.png" border="0" alt="signout" />
					Logout
				</span>
			</a>
		</div>	
		<br />
	</cfif>
</div>
</cfoutput>