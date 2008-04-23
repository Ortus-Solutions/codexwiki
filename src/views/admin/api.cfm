<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/book_open.png" align="absmiddle"> CodeX API Documentation</h2>
<p>
	#rc.cfcviewer.renderit()#
</p>
</cfoutput>