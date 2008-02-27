<!--- display a wiki page --->
<cfoutput>
<!--- Print Bar --->
<cfif not event.valueExists("print")>
<div align="right" style="float:right">
	<a href="#pageShowRoot()##URLEncodedFormat(rc.page)#/pdf.cfm" target="_blank">PDF</a> |
	<a href="#pageShowRoot()##URLEncodedFormat(rc.page)#/flashpaper.cfm" target="_blank">SWF</a> |
	<a href="#pageShowRoot()##URLEncodedFormat(rc.page)#/HTML.cfm" target="_blank">HTML</a>
</div>
</cfif>

<!--- Content --->
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
				<a href="#pageShowRoot()##URLEncodedFormat("Category:" & category.getName())#.cfm">#category.getName()#</a>
			</li>
		</cfloop>
		</ul>
	</div>
</cfif>

<!--- Management Tool Bar --->
<cfif not event.valueExists("print")>
<br />
<p class="buttons">
	<a href="#getSetting('sesBaseURL')#/#rc.onEditWiki#/#URLEncodedFormat(rc.page)#.cfm">
		<input type="button" value="Edit Page">
	</a>
	<a href="#getSetting('sesBaseURL')#/#rc.onDeleteWiki#/#URLEncodedFormat(rc.page)#.cfm">
		<input type="button" value="Delete Page">
	</a>
</p>
</cfif>
</cfoutput>