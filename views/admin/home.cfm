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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function submitReinit(){
	$('##_loader2').slideToggle();
	$('##ReinitSubmit').toggle();
}
function deleteComment(id){
	window.location.href='#event.buildLink(linkTo=rc.xehCommentDelete,translate=false)#/commentID/' +id;
}
function confirmDelete(id){
	confirm("Do you wish to remove the selected comment(s)?<br/>This cannot be undone!",function(){deleteComment(id)});
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<cfoutput>
	
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Welcome --->
<h2><img src="includes/images/shield.png" alt="welcome" /> Welcome to your CodeX Administrator dashboard</h2>
<p>
	From this panel, you will be able to manage this CodeX installation. Please read all the instructions whenever
	making changes to the system settings. As you can see, a new panel has appeared in your sidebar that will let you 
	manage CodeX. So please use the available menu options under the <strong>Admin Menu</strong> box.
</p>

<!--- Beta Notification --->
<div class="cbox_messagebox_warning">
	<p class="cbox_messagebox">
	Please bear in mind that some admin features have not been built yet. Enjoy Codex!
	</p>
</div>

<!--- Reinit Box --->
<form action="#event.buildLink(rc.xehReinitApp)#" name="reinitForm" id="reinitForm" method="post" onSubmit="submitReinit()">
	<fieldset>
	<legend><strong>Codex Information</strong></legend>
		<label>Codex Version:</label>
	    	#getSetting('Codex').Version# #getSetting('Codex').Suffix#<br />
		<label for="fwreinit">Restart CodeX:</label>
		This will start the application fresh, clean the cache and settings<br />
	    <input type="submit" id="ReinitSubmit" name="ReinitSubmit" value="Reinitialize Application">
	    
	    <!--- Loader --->
		<div id="_loader2" class="align-center formloader">
			<p>
				Reloading...<br />
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			</p>
		</div>		
   </fieldset>

	<fieldset>
	<legend><strong>Latest 10 Comments</strong></legend>
	
	<!--- Render Results --->
	<table class="tablesorter" width="100%" id="commentsTable" cellspacing="1" cellpadding="0" border="0">
	
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th width="250" >Author</th>
			<th >Comment</th>
			<th width="85" class="align-center">Approved</th>			
			<th width="100" class="align-center {sorter:false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qComments">
		<tr>
			<td>
				<!--- Avatar --->
				#getMyPlugin("avatar").renderAvatar(email:rc.qComments.authorEmail,size:32)#
				<!--- Name --->
				#rc.qComments.Author#<br />
				<cfif len(rc.qComments.authorURL)>
					<img src="includes/images/link.png" alt="link" /> 
					<a href="<cfif NOT findnocase("http",rc.qComments.authorURL)>http://</cfif>#rc.qComments.authorURL#">#rc.qComments.authorURL#</a>
					<br />
				</cfif>
				<img src="includes/images/server_key.png" alt="link" /> 
				<a href="http://ws.arin.net/cgi-bin/whois.pl?queryinput=#rc.qComments.authorIP#" title="Get IP Information" target="_blank">#rc.qComments.authorIP#</a>
			</td>
			<td>
				<div class="commentCreateDate">Submitted on #printDate(rc.qComments.createdDate)# at #printTime(rc.qComments.createdDate)# in
				<a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.qComments.pageName)))###pageComment_#rc.qComments.commentID#" class="externallink">#rc.qComments.pageName#</a><br />
				</div>
				#htmlEditFormat(left(rc.qComments.content,100))#
				<cfif len(rc.qComments.content) gt 100>...</cfif>
			</td>
			<td class="center<cfif NOT rc.qComments.isApproved> pageCommentUnapproved</cfif>">#yesNoFormat(rc.qComments.isApproved)#</td>

			<!--- Display Commands --->
			<td class="center">
				<cfif rc.qComments.isApproved>
				<a href="#event.buildlink(rc.xehCommentStatus & '/status/unapprove/commentID/' & commentID)#" title="Unapprove Comment"><img src="includes/images/thumb_down.png" border="0" alt="edit" title="Unapprove Comment"/></a>
				<cfelse>
				<a href="#event.buildlink(rc.xehCommentStatus & '/status/approve/commentID/' & commentID)#" title="Approve Comment"><img src="includes/images/thumb_up.png" border="0" alt="edit" title="Approve Comment"/></a>
				</cfif>
				
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#commentID#')" title="Delete Comment"><img id="delete_#commentID#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Comment"/></a>
			</td>

		</tr>
		</cfloop>
		</tbody>
	</table>
	</fieldset>
	
	<fieldset>
	<legend><strong>Latest 10 Wiki Updates</strong></legend>
		<!--- Render Results --->
		<table class="tablesorter" width="100%" id="updatesTable" cellspacing="1" cellpadding="0" border="0">
		
			<thead>
			<!--- Display Fields Found in Query --->
			<tr>
				<th >Page</th>
				<th >Change Information</th>
				<th width="85" class="align-center">Version</th>		
			</tr>
			</thead>
			
			<tbody>
			<!--- Loop Through Query Results --->
			<cfloop query="rc.qPageUpdates">
			<tr>
				<td>
					<img src="includes/images/page_go.png" alt="page" /> <a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.qPageUpdates.page_name)))#">#rc.qPageUpdates.page_name#</a>
				</td>
				<td>
					<div class="commentCreateDate">Updated on #printDate(rc.qPageUpdates.pagecontent_createdate)# at #printTime(rc.qPageUpdates.pagecontent_createdate)# by<img src="includes/images/user_icon.gif" alt="usericon"/><strong>#rc.qPageUpdates.user_username#</strong>
					</div>
					#rc.qPageUpdates.pagecontent_comment#
					<cfif not len(#rc.qPageUpdates.pagecontent_comment#)><span class="red">No Comment</span></cfif>
				</td>
				<td class="align-center">
					#rc.qPageUpdates.pagecontent_version#
				</td>
			</tr>
			</cfloop>
			</tbody>
		</table>
	
	
	</fieldset>

</form>
</cfoutput>