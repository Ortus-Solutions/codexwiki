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

<!--- Security will go here --->
<!--- Admin Main Menu --->
<cfif findnocase("admin",event.getCurrentEvent())>
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/shield.png" align="absmiddle"> Admin Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehAdmin#">Admin Dashboard</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehadminlookups#">System Lookups</a></li>
	</ul>
</div>	
</cfif>

<!--- Wiki Main Menu --->
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/home.png" align="absmiddle"> Wiki Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('sesBaseURL')#">Dashboard</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehSpecialHelp#">Help</a></li>
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehSpecialFeeds#">Rss Feeds</a></li>
	</ul>
</div>

<!--- User Login Box --->
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> User Login</h1>
<div class="left-box">
	
	<cfif not rc.oUser.getisAuthorized()>
		<cfform name="loginform" id="loginform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehUserDoLogin#" onsubmit="onLoginForm()">
		<!--- ref Route --->
		<input type="hidden" name="refRoute" value="#cgi.script_name#">
		<p>
		<label for="username">Username</label>
		<cfinput type="text" name="username" id="username" size="20" required="true" message="Please enter your username"  />
		
		<label for="username">Password</label>
		<cfinput type="password" name="password" id="password" size="20" required="true" message="Please enter your password"  />
		
		<br />
		
		<!--- Loader --->
		<div id="_loader_login" class="align-center hidden" style="margin:5px 5px 0px 0px;">
			<p class="bold red">
				Submitting...<br />
				
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
			<br />
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
			Welcome back <strong>#rc.oUser.getfname()#</strong>!
			<br />
			Role: #rc.oUser.getRole().getRole()#
		</p>
		<br /><br />
		<!--- Button Bar --->
		<div align="center" id="_buttonbar_login">
			<a href="#getSetting('sesBaseURL')#/#rc.xehUserLogout#" id="buttonLinks">
				<span>
					<img src="#getSetting('sesBaseURL')#/includes/images/stop.png" border="0" align="absmiddle">
					Logout
				</span>
			</a>
		</div>	
		<br />
	</cfif>
</div>

</cfoutput>