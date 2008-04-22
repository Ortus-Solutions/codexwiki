<cfoutput>
<!--- Main Header And Tabs --->
<div id="header">
	<span id="slogan">CodexWiki</span>
	<!-- tabs -->
	<cfif not event.valueExists("print")>
	<ul>
		<!--- Wiki Tab --->
		<li <cfif refindnocase("^page",event.getCurrentEvent())>id="current"</cfif>>
			<a href="#getSetting('sesBaseURL')#"><span>Wiki</span></a>
		</li>

		<cfif rc.oUser.getisAuthorized()>
		<!--- User Profile Tab --->
		<li <cfif refindnocase("^profile",event.getCurrentEvent())>id="current"</cfif>>
			<a href="#getSetting('sesBaseURL')#/#rc.xehUserProfile#"><span>My Profile</span></a>
		</li>
		</cfif>

		<!--- Admin Tab --->
		<cfif rc.oUser.checkPermission("WIKI_ADMIN")>
		<li <cfif refindnocase("^admin",event.getCurrentEvent())>id="current"</cfif> >
			<a href="#getSetting('sesBaseURL')#/#rc.xehAdmin#"><span>Admin</span></a>
		</li>
		</cfif>
	</ul>
	</cfif>
</div>

<!--- Sub Header --->
<div id="header-logo">
	<div id="logo"><h1>#getSetting("WikiName")#</h1></div>
	<cfif not event.valueExists("print")>
	<form method="post" class="search" action="#getSetting('sesBaseURL')#/page/search.cfm">
		<p><input name="search_query" class="textbox" type="text" />
				<input name="search" class="searchbutton" value="Search" type="submit" /></p>
	</form>
	</cfif>
</div>
</cfoutput>