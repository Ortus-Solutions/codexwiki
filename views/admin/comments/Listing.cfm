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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function submitForm(){
	$('##_loader').fadeIn();
	$('##commentsForm').submit();
}
function deleteRecord(recordID){
	if( recordID != null ){
		$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
		$("input[@name='commentID']").each(function(){
			if( this.value == recordID ){ this.checked = true;}
			else{ this.checked = false; }
		});
	}
	//Submit Form
	submitForm();
}
function confirmDelete(recordID){
	confirm("Do you wish to remove the selected comment(s)?<br/>This cannot be undone!",function(){deleteRecord(recordID)});
}
function changeStatus(status){
	$("##commentsForm").attr("action","#event.buildlink(linkTo=rc.xehStatus,translate=false)#/status/"+status);
	submitForm();
}
$(document).ready(function() {
	// call the tablesorter plugin
	$("##commentsTable").tablesorter({
		sortList: [[1,0]]
	});
	$("##commentFilter").keyup(function(){
		$.uiTableFilter($("##commentsTable"),this.value);
	});
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h2><img src="includes/images/comments.png" alt="Comments" /> Comment Inbox</h2>
<p>This screen shows the latest 50 comments entered into your system.</p>
<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#


<!--- Table Manager Jumper --->
<form name="searchFilterForm" id="searchFilterForm">
	<div id="adminFilterBar">
		<a href="#event.buildLink(rc.xehListing)#" <cfif rc.filter eq "all">class="linkBold"</cfif>>All <cfif rc.filter eq "all">(#rc.qComments.recordcount#)</cfif></a> |
		<a href="#event.buildLink(rc.xehListing & '/filter/pending')#" <cfif rc.filter eq "pending">class="linkBold"</cfif>>Pending <cfif rc.filter eq "pending">(#rc.qComments.recordcount#)</cfif></a> |
		<a href="#event.buildLink(rc.xehListing & '/filter/approved')#" <cfif rc.filter eq "approved">class="linkBold"</cfif>>Approved <cfif rc.filter eq "approved">(#rc.qComments.recordcount#)</cfif></a>
	
		<!--- Records Found --->
		<div class="float-right">
			<label class="inline" for="commentFilter">Comment Filter</label>
			<input type="text" size="30" name="commentFilter" id="commentFilter">
		</div>
		
	</div>
	
</form>

<!--- Results Form --->
<form name="commentsForm" id="commentsForm" action="#event.buildLink(rc.xehDelete)#" method="post">
	
	<!--- Add / Delete --->
	<div class="buttons">
		<a href="javascript:changeStatus('approve')" class="buttonLinks">
			<span>
				<img src="includes/images/thumb_up.png" border="0" alt="delete" />
				Approve
			</span>
		</a>
		&nbsp;
		<a href="javascript:changeStatus('unapprove')" class="buttonLinks">
			<span>
				<img src="includes/images/thumb_down.png" border="0" alt="delete" />
				Unapprove
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="delete" />
				Delete
			</span>
		</a>
	</div>
	
	<!--- Render Results --->
	<table class="tablesorter" width="100%" id="commentsTable" cellspacing="1" cellpadding="0" border="0">
	
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th id="checkboxHolder" class="{sorter:false}"><input type="checkbox" onClick="checkAll(this.checked,'commentID')"/></th>
			<th width="250" >Author</th>
			<th >Comment</th>
			<th width="85" class="center">Approved</th>			
			<th width="100" class="{sorter:false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qComments">
		<tr>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="commentID" id="commentID" value="#rc.qComments.commentID#" />
			</td>
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
				#htmlEditFormat(left(rc.qComments.content,300))#
				<cfif len(rc.qComments.content) gt 300>...</cfif>
			</td>
			<td class="center<cfif NOT rc.qComments.isApproved> pageCommentUnapproved</cfif>">#yesNoFormat(rc.qComments.isApproved)#</td>

			<!--- Display Commands --->
			<td class="center">
				
				<!--- Approve/Unapprove --->
				<cfif rc.qComments.isApproved>
				<a href="#event.buildlink(rc.xehStatus & '/status/unapprove/commentID/' & commentID)#" title="Unapprove Comment"><img src="includes/images/thumb_down.png" border="0" alt="edit" title="Unapprove Comment"/></a>
				<cfelse>
				<a href="#event.buildlink(rc.xehStatus & '/status/approve/commentID/' & commentID)#" title="Approve Comment"><img src="includes/images/thumb_up.png" border="0" alt="edit" title="Approve Comment"/></a>
				</cfif>
				
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehEdit & '/commentID/' & commentID)#" title="Edit Comment"><img src="includes/images/page_edit.png" border="0" alt="edit" title="Edit Namespace"/></a>
				
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#commentID#')" title="Delete Comment"><img id="delete_#commentID#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Comment"/></a>
			</td>

		</tr>
		</cfloop>
		</tbody>
	</table>
	
	<!--- Add / Delete --->
	<div class="buttons">
		<a href="javascript:changeStatus('approve')" class="buttonLinks">
			<span>
				<img src="includes/images/thumb_up.png" border="0" alt="delete" />
				Approve
			</span>
		</a>
		&nbsp;
		<a href="javascript:changeStatus('unapprove')" class="buttonLinks">
			<span>
				<img src="includes/images/thumb_down.png" border="0" alt="delete" />
				Unapprove
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="delete" />
				Delete
			</span>
		</a>
	</div>
	<br />


</form>

</cfoutput>