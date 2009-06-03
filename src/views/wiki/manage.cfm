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
<!--- create a non found wiki page --->
<cfsetting showdebugoutput="false">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function CodexPreview(){
	var content = $("##content");
	var data = {content: content.val(), pagename: "#rc.content.getPage().getName()#"};
	var preview = $(getLoadingText()).modal({
		onOpen: function(dialog){ openDialog(dialog) },
		onShow: function(dialog){ showDialog(dialog,"#event.BuildLink(rc.onPreview)#",data) },
		onClose: function(dialog){ closeDialog(dialog) }
		});
}
function pageDialog(pagename){
	//CheatSheet
	var data = {page: pagename};
	var HelpModal = $(getLoadingText()).modal({
		onOpen: function(dialog){ openDialog(dialog) },
		onShow: function(dialog){ showDialog(dialog,"#event.BuildLink(rc.onPageRender)#",data)},
		onClose: function(dialog){ closeDialog(dialog) }
		});
}
function submitForm(){
	needToConfirm=false;
	$('##_buttonbar').slideUp("fast");
	$('##_loader').fadeIn("slow");
}
function askLeaveConfirmation(){
	if (needToConfirm){
   		return "You have unsaved changes.";
   	}    
}
function markupInserted(){
	needToConfirm = true;
}
function togglePageOptions(){
	$("##PageOptions").slideToggle();	
	$("##PageOptionsInstructions").slideToggle();	
}
$(document).ready(function() {
	$("##content").markItUp(mySettings);
	needToConfirm = false;
	window.onbeforeunload = askLeaveConfirmation;
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="includes/images/page_edit.png" alt="edit" /> Editing:
	"<a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.content.getPage().getName())))#">#rc.content.getPage().getCleanName()#</a>"
</h1>
<!--- MessageBox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.onSubmit)#" method="post" onsubmit="submitForm()">
<div>
	<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />
	<input type="hidden" name="pageVersion" value="#rc.content.getVersion()#" />
	
	<!--- Control Holder & Text Area --->
	<div class="float-right">
		<a href="javascript:pageDialog('#rc.onCheatSheet#')">Markup Cheatsheet</a>
		| 
		<a class="externallink" href="#event.buildLink(pageShowRoot('Help:Contents'))#">Wiki Help</a>
	</div>
	<label for="content"><em>*</em> Wiki Content</label>
	<textarea name="content" id="content" class="resizable" rows="20" cols="50">#rc.content.getContent()#</textarea>
	
	<!--- Page Options --->
	<fieldset title="Page Options">
	<div>
		<legend><a href="javascript:togglePageOptions()" title="Click to expand page options">Page Options</a></legend>
		<div id="PageOptionsInstructions">Click to expand page options</div>
		<div id="PageOptions" class="hidden">
		
		<cfif event.getCurrentAction() eq "edit">
		<!--- PageName --->
		<label for="PageName">Rename Page</label>
		You can rename the page here if you so desire. Please note that links or settings pointing to this page will
		need to be updated as well.<br />
		<input type="text" name="RenamePageName" id="RenamePageName" value="#rc.content.getpage().getName()#" size="50">
		</cfif>
		
		<label for="title">Page HTML Title</label>
		The HTML title value (If empty, then the actual page name will be used: <strong>#rc.content.getPage().getName()#</strong>)<br />
		<input type="text" name="title" id="title" value="#rc.content.getpage().getTitle()#" size="50">
		<label for="title">Page HTML Description</label>
		The HTML page description<br />
		<input type="text" name="description" id="description" value="#rc.content.getpage().getdescription()#" size="50">
		<label for="title">Page HTML Keywords</label>
		The HTML page keywords<br />
		<input type="text" name="keywords" id="title" value="#rc.content.getpage().getKeywords()#" size="50">
		
		<label for="PagePassword">Page Viewing Password</label>
		You can password protect this page from viewing by providing a password below.<br />
		<input type="text" name="PagePassword" id="PagePassword" value="#rc.content.getpage().getPassword()#" size="50">
		
		<label>
		<input value="true" id="isReadOnly" type="checkbox" name="isReadOnly" <cfif rc.content.getIsReadOnly()>checked="checked"</cfif>/>
		Page is read-only
		</label> 
		If checked, only page author <strong>#rc.oUser.getUsername()#</strong> and a user with WIKI_ADMIN privileges can edit a read-only page.
		</div>
	</div>
	</fieldset>
	
	<!--- Comment Editing --->
	<fieldset title="Content Information">
	<div>
		<legend>Content Information</legend>
		
		<!--- Categories --->
		<label for"contentCategories">Content Categories</label>
		<em>You can tag this page with existing categories by choosing from the list below. For adding new categories, 
			use the <strong>'<img src="includes/scripts/markitup/sets/wiki/images/categories.gif" alt="category" /> category'</strong> 
			button in the wiki editor or the wiki admin.</em><br />
		<select name="contentCategories" id="contentCategories" multiple="true" size="5">
			<cfloop query="rc.qCategories">
				<option value="#rc.qCategories.category_id#" <cfif rc.content.checkCategory(rc.qCategories.category_id)>selected="selected"</cfif> >#rc.qCategories.name#</option>
			</cfloop>
		</select>
		
		<!--- Comments --->
		<label for="comment"><cfif rc.CodexOptions.wiki_comments_mandatory><em>*</em></cfif> Comment about this change
		<cfif not rc.codexOptions.wiki_comments_mandatory>(Optional)</cfif></label>
		<textarea name="comment" id="comment" rows="3" cols="50"></textarea>
	</div>
	</fieldset>

	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="button" class="cancelButton" onclick="window.location='#event.buildLink(pageShowRoot(rc.content.getPage().getName()))#'" value="cancel"></input>
   		<input type="button" class="previewButton" onclick="javascript:CodexPreview();" value="preview">
   		<input type="submit" class="submitButton" value="submit"></input>
   	</div>
</div>
</form>
</cfoutput>