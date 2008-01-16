<!--- display a wiki page --->
<cfscript>
	content = event.getValue("content");
</cfscript>

<cfoutput>
	<h1>#content.getPage().getName()#</h1>
	<p>
		#content.getContent()#
	</p>
	<hr />
	<p>



		<a href="?event=#event.getValue("onEditWiki")#&amp;page=#URLEncodedFormat(event.getValue("page"))#">Edit Page</a><br/>


		<a href="?event=#event.getValue("onDeleteWiki")#&amp;page=#URLEncodedFormat(event.getValue("page"))#">Delete Page</a>
	</p>
</cfoutput>