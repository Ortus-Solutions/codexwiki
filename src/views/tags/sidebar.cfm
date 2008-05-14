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
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/shield.png" align="absmiddle"> Admin Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehAdmin#">Admin Dashboard</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehAdminUsers#">User Management</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehAdminCustomHTML#">Custom HTML</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehAdminAPI#">API Docs</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehadminlookups#">System Lookups</a></li>
	</ul>
</div>
<cfelseif refindnocase("^profile",event.getCurrentEvent())>
<!--- User Main Menu --->
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/shield.png" align="absmiddle"> User Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehUserProfile#">My Profile</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehUserChangePass#">Change Password</a></li>
	</ul>
</div>
<cfelse>
<!--- Wiki Main Menu --->
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/home.png" align="absmiddle"> Wiki Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('sesBaseURL')#">Dashboard</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehSpecialHelp#">Help</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehSpecialFeeds#">Rss Feeds</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehSpecialCategory#">Category List</a></li>
	</ul>
</div>
</cfif>


<!--- ***************************************************************************************************** --->
<!--- User Login Box --->
<!--- ***************************************************************************************************** --->

<cfif not rc.oUser.getisAuthorized()>
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> User Login </h1>
<cfelse>
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> User Info </h1>
</cfif>

<div class="left-box">
	
	<cfif not rc.oUser.getisAuthorized()>
		<cfform name="loginform" id="loginform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehUserDoLogin#" onsubmit="onLoginForm()">
		<!--- ref Route --->
		<input type="hidden" name="refRoute" value="#cgi.script_name#">
		<p>
		<label for="username">Username</label>
		<cfinput type="text" name="username" id="username" size="20" required="true" message="Please enter your username" maxlength="50" />
		
		<label for="username">Password</label>
		<cfinput type="password" name="password" id="password" size="20" required="true" message="Please enter your password" maxlength="50" />
		
		<br />
		
		<!--- Loader --->
		<div id="_loader_login" class="align-center formloader">
			<p>
				Submitting...<br />
				
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
		</div>
		
		<!--- Button Bar --->
		<div align="center" id="_buttonbar_login">
			<a href="#getSetting('sesBaseURL')#/#rc.xehUserReminder#">Forgot Password?</a>
			<cfif rc.oUser.checkPermission('WIKI_REGISTRATION')> | <a href="">Register</a> </cfif>
			<br /><br />
			<input type="submit" class="submitButton" value="Log In"></input>
		</div>
		<br />
		</p>
	</cfform>
	
	<cfelse>
		<p>
			Welcome back <strong>#rc.oUser.getfname()# #rc.oUser.getlname()#</strong>!
			<br />
			<strong>Your Role:</strong> #rc.oUser.getRole().getRole()#
		</p>
		<br />
		<!--- Button Bar --->
		<div align="center" id="_buttonbar_login">
			<a href="#getSetting('sesBaseURL')#/#rc.xehUserLogout#" id="buttonLinks">
				<span>
					<img src="#getSetting('sesBaseURL')#/includes/images/door_out.png" border="0" align="absmiddle">
					Logout
				</span>
			</a>
		</div>	
		<br />
	</cfif>
</div>

</cfoutput>