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
function toggleItems(it){
	$("##"+it).slideToggle('fast');
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- ***************************************************************************************************** --->
<!--- WIKI ADMIN SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfif refindnocase("^admin",event.getCurrentEvent())>
	
	<!--- Admin Main Menu --->
	<h1 onClick="toggleItems('sb_admin')"><img src="includes/images/shield.png" align="absmiddle"/> Admin</h1>
	<div class="left-box#isItemVisible('sb_admin')#" id="sb_admin">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehAdmin)#">Admin Dashboard</a></li>
			<li><a href="#event.buildLink(rc.xehAdminUsers)#">User Management</a></li>
			<li><a href="#event.buildLink(rc.xehAdminRoles)#">Role Management</a></li>
		</ul>
	</div>
	
	<!--- Pages --->
	<h1 onClick="toggleItems('sb_wikiadmin')"> <img src="includes/images/home.png" align="absmiddle"/> Wiki Admin</h1>
	<div class="left-box#isItemVisible('sb_wikiadmin')#" id="sb_wikiadmin">
		<ul class="sidemenu">
			<li>Pages</li>
			<li><a href="#event.buildLink(rc.xehAdminNamespace)#">Namespaces</a></li>
			<li>Categories</li>
			<li>Comments</li>
		</ul>
	</div>
	
	<!--- Plugins --->
	<h1 onClick="toggleItems('sb_plugins')"> <img src="includes/images/plugin.png" align="absmiddle"/> Plugins</h1>
	<div class="left-box#isItemVisible('sb_plugins')#" id="sb_plugins">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehAdminPlugins)#">Install/Remove</a></li>
			<li><a href="#event.buildLink(rc.xehAdminPluginDocs)#">Plugin Documentation</a></li>
		</ul>
	</div>
	
	<!--- Tools --->
	<h1 onClick="toggleItems('sb_tools')"> <img src="includes/images/tools.png" align="absmiddle"/> Tools</h1>
	<div class="left-box#isItemVisible('sb_tools')#" id="sb_tools">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehAdminAPI)#">API Docs</a></li>
			<li>Export</li>
			<li>Import</li>
			<li>Markup Converter</li>
		</ul>
	</div>
	
	<!--- Settings --->
	<h1 onClick="toggleItems('sb_settings')"> <img src="includes/images/process.png" align="absmiddle"/> Settings</h1>
	<div class="left-box#isItemVisible('sb_settings')#" id="sb_settings">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehAdminOptions)#">General</a></li>
			<li><a href="#event.buildLink(rc.xehAdminCommentOptions)#">Comments</a></li>
			<li><a href="#event.buildLink(rc.xehAdminCustomHTML)#">Custom HTML</a></li>
			<li><a href="#event.buildLink(rc.xehadminlookups)#">System Lookups</a></li>
		</ul>
	</div>
<!--- ***************************************************************************************************** --->
<!--- WIKI PROFILE SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfelseif refindnocase("^profile",event.getCurrentEvent())>
	<!--- User Main Menu --->
	<h1 onClick="toggleItems('sb_profile')"> <img src="includes/images/shield.png" align="absmiddle"/> User Menu</h1>
	<div class="left-box" id="sb_profile">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehUserProfile)#">My Profile</a></li>
			<li><a href="#event.buildLink(rc.xehUserChangePass)#">Change Password</a></li>
		</ul>
	</div>
<!--- ***************************************************************************************************** --->
<!--- WIKI MAIN SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfelse>
	<!--- Wiki Main Menu --->
	<h1 onClick="toggleItems('sb_wikimenu')"> <img src="includes/images/home.png" align="absmiddle"/> Wiki Menu</h1>
	<div class="left-box" id="sb_wikimenu">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(pageShowRoot(rc.CodexOptions.wiki_defaultpage))#">#rc.codexOptions.wiki_defaultpage_label#</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialHelp)#">Help</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialFeeds)#">Rss Feeds</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialCategory)#">Category Listing</a></li>
			<li><a href="#event.buildLink(rc.xehPageDirectory)#">Wiki Page Directory</a></li>
			
		</ul>
	</div>
</cfif>


<!--- ***************************************************************************************************** --->
<!--- User Login Box --->
<!--- ***************************************************************************************************** --->
	<cfif not rc.oUser.getisAuthorized()>
		<h1 onClick="toggleItems('sb_userinfo')"> <img src="includes/images/key.png" align="absmiddle"/> User Login </h1>
	<cfelse>
		<h1 onClick="toggleItems('sb_userinfo')"> <img src="includes/images/user.png" align="absmiddle"/> User Info </h1>
	</cfif>
	
	<div class="left-box" id="sb_userinfo">
		
		<cfif not rc.oUser.getisAuthorized()>
			<!--- Only show for non login event --->
			<cfif not listfindnocase("user.login,user.registration",event.getCurrentEvent())>
			<!--- Don't Show if in login event' --->
			<form name="loginform" id="loginform" method="post" action="#event.buildLink(rc.xehUserDoLogin)#" onsubmit="onLoginForm()">
				<!--- ref Route --->
				<input type="hidden" name="_securedURL" value="#event.getValue("_securedURL","")#">
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
						<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle"/>
						<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle"/>
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
						   onClick="window.location='#event.buildLink(rc.xehUserLogin)#'"/>
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
						<img src="includes/images/door_out.png" border="0" align="absmiddle" />
						Logout
					</span>
				</a>
			</div>	
			<br />
		</cfif>
	</div>

<!--- End if not in login event --->
</cfoutput>