<!--- display a wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getName()#</h1>

<cfset pageShowRoot = getSetting('sesBaseURL') & "/" & getSetting('showKey') & "/" />

<!--- Print Bar --->
<div align="right" style="float:right">
	<a href="#pageShowRoot##URLEncodedFormat(rc.page)#/pdf.cfm">PDF</a> |
	<a href="#pageShowRoot##URLEncodedFormat(rc.page)#/flashpaper.cfm">SWF</a>
</div>

<p>
	#rc.content.render()#
</p>
<cfset categories = rc.content.getCategoryArray() />
<cfif NOT ArrayIsEmpty(categories)>
	<div id="categories">
		Categories:
		<ul>
		<cfloop array="#categories#" index="category">
			<li>
				<a href="#pageShowRoot##URLEncodedFormat("Category:" & category.getName())#.cfm">#category.getName()#</a>
			</li>
		</cfloop>
		</ul>
	</div>
</cfif>
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