<cfoutput>
<!--- Main Header And Tabs --->
<div id="header">			
	<span id="slogan">Knowledge is Power...</span>
	<!-- tabs -->
	<cfif not event.valueExists("print")>
	<ul>
		<li id="current"><a href="#getSetting('sesBaseURL')#"><span>Home</span></a></li>
		
		<li><a href="#getSetting('sesBaseURL')#/#rc.xehAdmin#"><span>Admin</span></a></li>		
	
	</ul>
	</cfif>
</div>

<!--- Sub Header --->	
<div id="header-logo">			
	<div id="logo">Code<span class="red">X</span></div>		
	<cfif not event.valueExists("print")>
	<form method="post" class="search" action="index.cfm">
		<p><input name="search_query" class="textbox" type="text" />
				<input name="search" class="searchbutton" value="Search" type="submit" /></p>
	</form>						
	</cfif>
</div>
</cfoutput>