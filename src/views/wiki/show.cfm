<!--- display a wiki page --->

<cfset urlPage = URLEncodedFormat(rc.page) />

<cfoutput>
<!--- Print Bar --->
<cfif not event.valueExists("print")>
<div align="right" style="float:right">
	<img src="#getSetting('sesBaseURL')#/includes/images/history.png" border="0" align="absmiddle"> 
	<a href="#getSetting('sesBaseURL')#/#rc.onShowHistory#/#urlPage#.cfm">View History</a> |
	
	<img src="#getSetting('sesBaseURL')#/includes/images/pdf_16x16.png" border="0" align="absmiddle"> 
	<a href="#pageShowRoot()##urlPage#/pdf.cfm" target="_blank">PDF</a> |
	
	<img src="#getSetting('sesBaseURL')#/includes/images/flash_16x16.png" border="0" align="absmiddle"> 
	<a href="#pageShowRoot()##urlPage#/flashpaper.cfm" target="_blank">SWF</a> |
	
	<img src="#getSetting('sesBaseURL')#/includes/images/html_16x16.png" border="0" align="absmiddle"> 
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
	<a href="#getSetting('sesBaseURL')#/#rc.onEditWiki#/#urlPage#.cfm" id="buttonLinks">
		<span>Edit Page</span>
	</a>
	&nbsp;
	<a href="#getSetting('sesBaseURL')#/#rc.onDeleteWiki#/#urlPage#.cfm" id="buttonLinks">
		<span>Delete Page</span>
	</a>
</p>
</cfif>
</cfoutput>