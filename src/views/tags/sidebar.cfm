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
<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function onLoginForm(){
			$('##_buttonbar_login').slideUp("fast");
			$('##_loader_login').fadeIn("slow");
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- ***************************************************************************************************** --->
<!--- WIKI SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfif refindnocase("^admin",event.getCurrentEvent())>
<!--- Admin Main Menu --->
<h1> <img src="includes/images/shield.png" align="absmiddle"> Admin Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehAdmin,0)#.cfm">Admin Dashboard</a></li>
		<li><a href="#event.buildLink(rc.xehAdminUsers,0)#.cfm">User Management</a></li>
		<li><a href="#event.buildLink(rc.xehAdminCustomHTML,0)#.cfm">Custom HTML</a></li>
		<li><a href="#event.buildLink(rc.xehAdminOptions,0)#.cfm">System Options</a></li>
		<li><a href="#event.buildLink(rc.xehadminlookups,0)#.cfm">System Lookups</a></li>
		<li><a href="#event.buildLink(rc.xehAdminAPI,0)#.cfm">API Docs</a></li>
	</ul>
</div>
<cfelseif refindnocase("^profile",event.getCurrentEvent())>
<!--- User Main Menu --->
<h1> <img src="includes/images/shield.png" align="absmiddle"> User Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehUserProfile,0)#.cfm">My Profile</a></li>
		<li><a href="#event.buildLink(rc.xehUserChangePass,0)#.cfm">Change Password</a></li>
	</ul>
</div>
<cfelse>
<!--- Wiki Main Menu --->
<h1> <img src="includes/images/home.png" align="absmiddle"> Wiki Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#pageShowRoot(rc.CodexOptions.wiki_defaultpage)#.cfm">#rc.codexOptions.wiki_defaultpage_label#</a></li>
		<li><a href="#event.buildLink(rc.xehSpecialHelp)#.cfm">Help</a></li>
		<li><a href="#event.buildLink(rc.xehSpecialFeeds)#.cfm">Rss Feeds</a></li>
		<li><a href="#event.buildLink(rc.xehSpecialCategory)#.cfm">Category Listing</a></li>
		<li><a href="#event.buildLink(rc.xehPageDirectory)#.cfm">Wiki Page Directory</a></li>
		
	</ul>
</div>
</cfif>


<!--- ***************************************************************************************************** --->
<!--- User Login Box --->
<!--- ***************************************************************************************************** --->

	
<cfif not rc.oUser.getisAuthorized()>
	<h1> <img src="includes/images/key.png" align="absmiddle"> User Login </h1>
<cfelse>
	<h1> <img src="includes/images/user.png" align="absmiddle"> User Info </h1>
</cfif>

<div class="left-box">
	
	<cfif not rc.oUser.getisAuthorized()>
		<!--- Only show for non login event --->
		<cfif not listfindnocase("user.login,user.registration",event.getCurrentEvent())>
		<!--- Don't Show if in login event' --->
		<form name="loginform" id="loginform" method="post" action="#event.buildLink(rc.xehUserDoLogin)#.cfm" onsubmit="onLoginForm()">
			<!--- ref Route --->
			<input type="hidden" name="refRoute" value="#cgi.script_name#" />
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
					<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
					<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				</p>
			</div>
			
			<!--- Button Bar --->
			<div align="center" id="_buttonbar_login">
				<a href="#event.buildLink(rc.xehUserReminder)#.cfm">Forgot Password?</a>
				<!--- Registration Permission Link --->
				<cfif rc.oUser.checkPermission('WIKI_REGISTRATION')> | <a href="#event.buildLink(rc.xehUserRegistration)#.cfm">Register</a></cfif>
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
				<a href="#event.buildLink(rc.xehUserReminder)#.cfm">Forgot Password?</a>
				<!--- Registration Permission Link --->
				<cfif rc.oUser.checkPermission('WIKI_REGISTRATION')> | <a href="#event.buildLink(rc.xehUserRegistration)#.cfm">Register</a></cfif>
				<br /><br />
				<input type="button" class="submitButton" value="Log In" name="loginbutton" id="loginbutton" 
					   onClick="window.location='#event.buildLink(rc.xehUserLogin)#.cfm'"/>
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
			<a href="#event.buildLink(rc.xehUserLogout)#.cfm" id="buttonLinks">
				<span>
					<img src="includes/images/door_out.png" border="0" align="absmiddle">
					Logout
				</span>
			</a>
		</div>	
		<br />
	</cfif>
</div>

<!--- End if not in login event --->
</cfoutput>