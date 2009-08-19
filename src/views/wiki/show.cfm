<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by 
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 
    		
	http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>
<cfif not event.valueExists("print")>
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##deletePageButton").click(function(){
		var _this = this;
		return confirm("Are you sure you wish to delete the page '<strong>#rc.content.getPage().getName()#</strong>'?<br/>This cannot be undone!", function(){
			gotoLink(_this)
		});
	});
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
</cfif>

<!--- Print & Floating Top Bar --->
<cfif not event.valueExists("print")>

<!--- Page Title --->
<h1 class="wikiPageTitle">#rc.page# 
<cfif rc.content.getPage().isProtected()><img src="includes/images/lock.png" alt="protected" title="Page is protected!" /></cfif> 
</h1>

<!--- Top Bar --->	
<div id="wikiTopToolbar">

	<!--- Last Edit By --->
	<div id="wikiLastEditby">
	last edited by<img src="includes/images/user_icon.gif" alt="usericon"/><strong>#rc.content.getUser().getUsername()#</strong> 
	on #printDate(rc.content.getcreatedDate())#
	</div>
	
	<!--- Page Toolbar --->
	<div id="wikiTopToolbarActions">
		<!--- Create Button --->
		<cfif rc.oUser.checkPermission("WIKI_CREATE")>
			<img src="includes/images/add.png" border="0" alt="add" />
			<a href="#event.buildLink(rc.onCreateWiki)#" title="Create Page">Create Page</a>&nbsp;
		</cfif>
		<!--- Page History Button --->
		<cfif rc.oUser.checkPermission("WIKI_VIEW_HISTORY")>
			<img src="includes/images/history.png" border="0" alt="history" />
			<a href="#event.buildLink(rc.onShowHistory & '/' & rc.urlPage)#" title="Page History">Page History</a>
		</cfif>
	</div>
</div>
</cfif>

<!--- Messsagebox --->
#getPlugin("messagebox").renderit()#

<!--- Content --->
<p id="wikiContent">#rc.content.render()#</p>

<!--- Category Displays --->
<cfset categories = rc.content.getCategoryArray() />
<cfif NOT ArrayIsEmpty(categories)>
<div id="categories">
	<img src="includes/images/tag_blue.png" alt="category" /> 
	Categories:
	<ul>
	<cfloop array="#categories#" index="category">
		<li>
			<a href="#event.buildLink(pageShowRoot(URLEncodedFormat("Category:" & category.getName())))#">#category.getName()#</a>
		</li>
	</cfloop>
	</ul>
</div>
</cfif>

<!--- Management Tool Bar --->
<cfif not event.valueExists("print")>
	<!--- Only edit if not read only --->
	<cfif ( 
			rc.content.getisReadOnly() AND 
			(
		    	rc.content.getUser().getuserid() EQ rc.oUser.getUserid() 
		    	OR
		    	rc.oUser.checkPermission("WIKI_ADMIN") 
		    )
		  ) 
		  OR
		  NOT rc.content.getisReadOnly()>
		<div id="wikiPageActionBar">
			<cfif rc.oUser.checkPermission("WIKI_EDIT")>
			<a href="#event.buildLink(rc.onEditWiki & '/' & rc.urlPage)#" class="buttonLinks">
				<img src="includes/images/page_edit.png" alt="edit" border="0"  />
				<span>Edit Page</span>
			</a>
			</cfif>
			&nbsp;
			<cfif rc.oUser.checkPermission("WIKI_DELETE_PAGE")>
			<a id="deletePageButton" href="#event.buildLink(rc.onDeleteWiki & '/id/' & rc.content.getPage().getPageID())#" class="buttonLinks">
				<img src="includes/images/bin_closed.png" alt="edit" border="0" />
				<span>Delete Page</span>
			</a>
			</cfif>
		</div>
	</cfif>
	
	<!--- Format Bar --->
	<div id="downloadFormatsBar">
		<strong>Download in other Formats:</strong><br />
		
		<img src="includes/images/code.png" border="0" alt="markup" />
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/markup'))#" target="_blank">Markup</a> |
		
		<img src="includes/images/pdf_16x16.png" border="0" alt="pdf" />
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/pdf'))#" target="_blank">PDF</a> |
		
		<cfif getSetting("CFMLEngine",1) neq "RAILO">
		<img src="includes/images/flash_16x16.png" border="0" alt="swf" />
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/flashpaper'))#" target="_blank">SWF</a> |
		</cfif>
		
		<img src="includes/images/html_16x16.png" border="0" alt="html" />
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/HTML'))#" target="_blank">HTML</a> |
		
		<img src="includes/images/word.png" border="0" alt="word" />
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/word'))#" target="_blank">Word</a>
	</div>
	
	<!--- Comments, if Enabled? --->
	<cfif rc.codexoptions.comments_enabled AND rc.content.getPage().getAllowComments()>
	#renderView('wiki/comments')#
	</cfif>
</cfif>
</cfoutput>