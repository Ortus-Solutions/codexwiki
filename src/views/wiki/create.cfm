<!--- create a non found wiki page --->
<cfscript>
	content = event.getValue("content");
</cfscript>

<cfoutput>
	<h1>#content.getPage().getName()#</h1>
	<p>
		There is no page to be found under the title '#content.getPage().getName()#'
	</p>
	<p>
		Would you like to create it?
	</p>

	<hr />
	<p>
		<a href="?event=#event.getValue("onCreateWiki")#&amp;page=#URLEncodedFormat(event.getValue("page"))#">Create Page</a><br/>
	</p>
</cfoutput>