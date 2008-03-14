<!--- display a wiki page --->
<cfset urlPage = URLEncodedFormat(rc.page) />

<cfoutput>
<!--- Print & Floating Top Bar --->
<cfif not event.valueExists("print")>
<div align="right" style="margin-bottom:15px;">
	<cfif rc.oUser.checkPermission("WIKI_VIEW_HISTORY")>
	<img src="#getSetting('htmlBaseURL')#/includes/images/history.png" border="0" align="absmiddle">
	<a href="#getSetting('sesBaseURL')#/#rc.onShowHistory#/#urlPage#.cfm">View History</a> |
	</cfif>

	<img src="#getSetting('htmlBaseURL')#/includes/images/pdf_16x16.png" border="0" align="absmiddle">
	<a href="#pageShowRoot()##urlPage#/pdf.cfm" target="_blank">PDF</a> |

	<img src="#getSetting('htmlBaseURL')#/includes/images/flash_16x16.png" border="0" align="absmiddle">
	<a href="#pageShowRoot()##urlPage#/flashpaper.cfm" target="_blank">SWF</a> |

	<img src="#getSetting('htmlBaseURL')#/includes/images/html_16x16.png" border="0" align="absmiddle">
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
	<cfif rc.oUser.checkPermission("WIKI_EDIT")>
	<a href="#getSetting('sesBaseURL')#/#rc.onEditWiki#/#urlPage#.cfm" id="buttonLinks">
		<span>Edit Page</span>
	</a>
	</cfif>
	&nbsp;
	<cfif rc.oUser.checkPermission("WIKI_DELETE")>
	<a href="#getSetting('sesBaseURL')#/#rc.onDeleteWiki#/id/#rc.content.getPage().getPageID()#.cfm" id="buttonLinks">
		<span>Delete Page</span>
	</a>
	</cfif>
</p>
</cfif>
</cfoutput>