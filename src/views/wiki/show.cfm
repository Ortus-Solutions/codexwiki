<!--- display a wiki page --->

<cfoutput>
	Wiki Page Title: #event.getValue("page")#

	<hr>
	<a href="#event.getValue("onEditWiki")#&page=#event.getValue("page")#">Edit Page</a><br/>
	<a href="#event.getValue("onDeleteWiki")#&page=#event.getValue("page")#">Delete Page</a>
</cfoutput>