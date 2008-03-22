<!--- create a non found wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getCleanName()#</h1>
<p>
	There is no page to be found under the title <strong>'#rc.content.getPage().getCleanName()#'</strong>
</p>
<cfif rc.oUser.checkPermission("WIKI_CREATE")>
	<p>
		Would you like to create it?
	</p>

	<hr size="1"/>

	<p class="buttons">
		<a href="#getSetting('sesBaseURL')#/#rc.onCreateWiki#/#URLEncodedFormat(rc.page)#.cfm" id="buttonLinks">
			<span>Create Page</span>
		</a>
	</p>
<cfelse>
<p>
	You do not have permission to create new pages
</p>
</cfif>
</cfoutput>