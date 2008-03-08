<cfoutput>

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
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/home.png" align="absmiddle"> Main Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('htmlBaseURL')#">Dashboard</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehSpecialHelp#">Help</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehSpecialFeeds#">Rss Feeds</a></li>
	</ul>
</div>

<!--- User Login Box --->
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> User Login</h1>
<div class="left-box">
	<p>
	<label for="username">Username</label>
	<input type="text" name="username" id="username" size="20" />
	
	<label for="username">Password</label>
	<input type="password" name="password" id="password" size="20" />
	
	<br />
	
	<div align="center">
	<a href="">Forgot Password?</a>
	<input type="submit" class="submitButton" value="Log In"></input>
	</div>
	<br />
	</p>
</div>

</cfoutput>