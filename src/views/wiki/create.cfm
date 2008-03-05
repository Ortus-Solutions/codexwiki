<!--- create a non found wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getName()#</h1>
<p>
	There is no page to be found under the title <strong>'#rc.content.getPage().getName()#'</strong>
</p>
<p>
	Would you like to create it?
</p>

<hr size="1"/>

<p class="buttons">
	<a href="#getSetting('sesBaseURL')#/#rc.onCreateWiki#/#URLEncodedFormat(rc.page)#.cfm" id="buttonLinks">
		<span>Create Page</span>
	</a>
</p>
</cfoutput>