<cfoutput>
<div id="pageComments">
	<!--- Title --->
	<h2><a name="pageComments"></a><img src="includes/images/comments.png" alt="comments" /> 
	Comments (#rc.qComments.recordcount#)</h2>
	
	<!--- Add Comments? --->
	<cfif ( rc.codexOptions.comments_registration and rc.oUser.getIsAuthorized() ) 
		  OR
		  rc.codexOptions.comments_registration eq false>
	<div id="commentButtonBar" style="margin:10px 0px 10px 5px">
	<!--- Add Button --->
	<a href="javascript:addComment()" class="buttonLinks">
		<span>Add Comment</span>
	</a>
	</div>
	</cfif>
	
	<!--- Render Comments Here --->
	
	<!--- End of Comments --->
	<a name="pageCommentsEnd"></a>
</div>
</cfoutput>