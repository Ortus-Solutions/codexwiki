<cfoutput>

<!--- Security will go here --->
<cfif findnocase("admin",event.getCurrentEvent())>
<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/shield.png" align="absmiddle"> Admin Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehAdmin#">Admin Dashboard</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehadminlookups#">System Lookups</a></li>
	</ul>
</div>	
</cfif>

<h1> <img src="#getSetting('htmlBaseURL')#/includes/images/home.png" align="absmiddle"> Main Menu</h1>
<div class="left-box">
	<ul class="sidemenu">
		<li><a href="#getSetting('htmlBaseURL')#">Dashboard</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehSpecialHelp#">Help</a></li>
		<li><a href="#getSetting('htmlBaseURL')#/#rc.xehSpecialFeeds#">Rss Feeds</a></li>
	</ul>
</div>

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


<!--- <h1>Wise Words</h1>
<div class="left-box">
	<p>&quot;Big men and big personalities make mistakes and admit them.
	 It is the little man who is afraid to admit he has been wrong&quot;</p>

	<p class="align-right">- Dr. Maxwell Maltz</p>
</div>

<h1>Support Styleshout</h1>
<div class="left-box">
	<p>If you are interested in supporting my work and would like to contribute, you are
	welcome to make a small donation through the
	<a href="http://www.styleshout.com/">donate link</a> on my website - it will
	be a great help and will surely be appreciated.</p>
</div> --->
</cfoutput>