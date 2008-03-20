<!--- Page Title --->
<cfoutput>
	<title>
		#getSetting("WikiName")#
		<cfif event.valueExists("content") > - #rc.content.getPage().getCleanName()#</cfif>
		<cfif event.valueExists("pageTitle")> - #replaceNoCase(rc.pageTitle, "_", " ")#</cfif>
		-
		CodeX Wiki
	</title>
</cfoutput>