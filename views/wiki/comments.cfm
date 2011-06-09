<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function addComment(){
	var data = {pageID: '#rc.content.getPage().getPageID()#'};
	openModal("#event.BuildLink(rc.xehComments)#",data,550,650);
}
function deleteComment(commentID){
	var data = {commentID:commentID, ajax:true}
	confirm("Are you sure you wish to delete the selected comment. This cannot be undone!", function(e){
		$("##comment_action_delete_"+commentID).attr("src","includes/images/ajax-spinner.gif");
		$.post("#event.buildLink(rc.xehCommentRemove)#",data,function(results){
			if( results ){
				$("##pageComment_"+commentID).fadeOut();
				$("##pageComment_"+commentID).remove();
				$("##pageCommentCount").text($("##pageCommentCount").text()-1);
			}
			else{
				$("##pageCommentMessages_"+commentID).html('<strong>Oops! Something went wrong</strong><br/>' + results);
				$("##comment_action_delete_"+commentID).attr("src","includes/images/bin_closed.png");
			}
		},"json");
	});
	
}
function approveComment(commentID){
	var data = {commentID : commentID, ajax:true}
	$("##comment_action_status_"+commentID).attr("src","includes/images/ajax-spinner.gif");
	$.post("#event.buildLink(rc.xehCommentStatus)#",data,function(results){
		if( results ){
			$("##pageComment_"+commentID).removeClass('pageCommentUnapproved');
			$("##pageCommentModeration_"+commentID).fadeOut();
			$("##pageCommentModeration_"+commentID).remove();
		}
		else{
			$("##pageCommentMessages_"+commentID).html('<strong>Oops! Something went wrong</strong><br/>' + results);
			$("##comment_action_status_"+commentID).attr("src","includes/images/thumb_up.png");
		}
	},"json");
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<div id="pageComments">

	<!---  Comment Header --->
	<div id="pageCommentHeader">
		<a name="pageComments"></a>
		<p>
			<img src="includes/images/comments.png" alt="comments" /> 
			Comments (<span id="pageCommentCount">#rc.qComments.recordcount#</span>)
		</p>
	</div>
	
	<!--- Add Comments? --->
	<div id="pageCommentButtonBar">
	<cfif ( rc.codexOptions.comments_registration and rc.oUser.getIsAuthorized() ) 
		  OR
		  rc.codexOptions.comments_registration eq false>
		<!--- Add Button --->
		<a href="javascript:addComment()" class="buttonLinks">
			<span>Add Comment</span>
		</a>
	<cfelse>
		<!--- Need to Login --->
		<p><strong>You need to <a href="#event.buildLink(rc.xehUserLogin)#">login</a> in order to comment!</strong></p>
	</cfif>
	</div>
	
	<!--- Render Comments Here --->
	<cfloop query="rc.qComments">
		<!--- Show Only if comment moderation is enabled and not active --->
		<cfif rc.qComments.isApproved OR rc.oUser.checkPermission("COMMENT_MODERATION")>
		<div id="pageComment_#rc.qComments.commentID#" class="pageComment<cfif NOT rc.qComments.isApproved> pageCommentUnapproved</cfif>">
			<!--- Anchor --->
			<a name="comment-#rc.qComments.commentID#"></a>
			<!--- Comment Message --->
			<div id="pageCommentMessages_#rc.qComments.commentID#"></div>
			
			<!--- Comment Avatar --->
			<div class="pageCommentPicture">
			#getMyPlugin("avatar").renderAvatar(email=rc.qComments.authorEmail,size=60)#
			</div>
			
			<!--- Comment Author --->
			<h4>
				<cfif len(rc.qComments.authorURL)>
					<a href="<cfif NOT findnocase("http",rc.qComments.AuthorURL)>http://</cfif>#rc.qComments.AuthorURL#" title="Open #rc.qComments.AuthorURL#"><img src="includes/images/link.png" alt="url" border="0" /></a>
				</cfif>
				<strong>#rc.qComments.author#</strong> said
			</h4>
			<p>at #printTime(rc.qComments.createdDate)# #printDate(rc.qComments.createdDate)#</p>
			
			<!--- Comment Moderation --->
			<cfif rc.oUser.checkPermission("COMMENT_MODERATION")>
			<p>
				<!--- Delete Comments --->
				<img src="includes/images/bin_closed.png" alt="remove" id="comment_action_delete_#rc.qComments.commentID#" /> <a href="javascript:deleteComment('#rc.qComments.commentID#')">delete</a>
				
				<!--- Moderate Comment --->
				<cfif NOT rc.qComments.isApproved>
					<span id="pageCommentModeration_#rc.qComments.commentID#">
					<img src="includes/images/thumb_up.png" alt="remove"  id="comment_action_status_#rc.qComments.commentID#"/> <a href="javascript:approveComment('#rc.qComments.commentID#')">Approve</a>
					</span>
				</cfif>
			</p>
			</cfif>
			
			<!--- Content --->
			<div class="pageCommentContent">
				#rc.qComments.content#
			</div>
		</div>
		</cfif> <!--- If comment approved --->		
	</cfloop>
	
	<!--- End of Comments --->
	<a name="pageCommentsEnd"></a>
</div>
</cfoutput>