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
<!--- Main Header And Tabs --->
<div id="header">

	<span id="slogan">CodexWiki v#getSetting("Codex").Version# #getSetting("Codex").suffix#</span>

	<!-- tabs -->
	<cfif not event.valueExists("print")>
	<ul>
		<!--- Wiki Tab --->
		<li <cfif refindnocase("^page",event.getCurrentEvent())>id="current"</cfif>>
			<a href="#event.buildLink(pageShowRoot(rc.CodexOptions.wiki_defaultpage))#"><span>Wiki</span></a>
		</li>

		<cfif rc.oUser.getisAuthorized()>
		<!--- User Profile Tab --->
		<li <cfif refindnocase("^profile",event.getCurrentHandler())>id="current"</cfif>>
			<a href="#event.buildLink(rc.xehUserProfile)#"><span>My Profile</span></a>
		</li>
		</cfif>

		<!--- Admin Tab --->
		<cfif rc.oUser.checkPermission("WIKI_ADMIN")>
		<li <cfif refindnocase("^admin",event.getCurrentHandler())>id="current"</cfif> >
			<a href="#event.buildLink(rc.xehAdmin)#"><span>Admin</span></a>
		</li>
		</cfif>
	</ul>
	</cfif>
</div>

<!--- Sub Header --->
<div id="header-logo">

	<div id="logo" onClick="window.location='#event.buildLink(pageShowRoot(rc.CodexOptions.wiki_defaultpage))#'"><h1><a href="#getSetting('htmlBaseURL')#">#rc.CodexOptions.wiki_name#</a></h1></div>

	<cfif not event.valueExists("print")>
	<form method="post" class="search" action="#event.buildLink(rc.xehWikiSearch)#">
		<p><input name="search_query" class="textbox" type="text" />
				<input name="search" class="searchbutton" value="Search" type="submit" /></p>
	</form>
	</cfif>
</div>
</cfoutput>