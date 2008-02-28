<!--- display a wiki page --->

<cfset urlPage = URLEncodedFormat(rc.page) />

<cfoutput>
<!--- Print Bar --->
<cfif not event.valueExists("print")>
<div align="right" style="float:right">
	<a href="#getSetting('sesBaseURL')#/#rc.onShowHistory#/#urlPage#.cfm">View History</a> ||
	<a href="#pageShowRoot()##urlPage#/pdf.cfm" target="_blank">PDF</a> |
	<a href="#pageShowRoot()##urlPage#/flashpaper.cfm" target="_blank">SWF</a> |
	<a href="#pageShowRoot()##urlPage#/HTML.cfm" target="_blank">HTML</a>
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
	<a href="#getSetting('sesBaseURL')#/#rc.onEditWiki#/#urlPage#.cfm">
		<input type="button" value="Edit Page">
	</a>
	<a href="#getSetting('sesBaseURL')#/#rc.onDeleteWiki#/#urlPage#.cfm">
		<input type="button" value="Delete Page">
	</a>
</p>
</cfif>
</cfoutput>