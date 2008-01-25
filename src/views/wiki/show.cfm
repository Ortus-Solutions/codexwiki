<!--- display a wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getName()#</h1>

<!--- Print Bar --->
<div align="right" style="float:right">
	<a href="#getSetting('sesBaseURL')#/#getSetting('showKey')#/#URLEncodedFormat(rc.page)#/pdf.cfm">PDF</a> | 
	<a href="#getSetting('sesBaseURL')#/#getSetting('showKey')#/#URLEncodedFormat(rc.page)#/flashpaper.cfm">SWF</a>
</div>

<p>
	#rc.content.render()#
</p>
<hr size="1"/>
<p>
	<a href="#getSetting('sesBaseURL')#/#rc.onEditWiki#/#URLEncodedFormat(rc.page)#.cfm">
		<input type="button" value="Edit Page">
	</a>
	<a href="#getSetting('sesBaseURL')#/#rc.onDeleteWiki#/#URLEncodedFormat(rc.page)#.cfm">
		<input type="button" value="Delete Page">
	</a>
</p>
</cfoutput>