<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$('##addNewCommentForm').formValidation({
		err_class 	: "invalidLookupInput",
		err_list	: true,
		callback	: 'prepareCommentSubmit'
	});			
});
function submitCommentForm(){
	var data = {captchacode: $("##captchacode").val()};
	$.post('#event.buildLink(rc.xehvalidate)#',data, function(results){
		if( results ){
			$('##addNewCommentForm').submit();
		}
		else{
			$("##captchacode").val('');
			$("##captchacode").addClass('invalidLookupInput');
			alert("Invalid Security Code, please try again!");
		}
	},"json");			
}
function prepareCommentSubmit(){
	$('##_buttonbar').slideUp("fast");
	$('##_loader').fadeIn("slow");
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<div id="addNewComment">
<h2><img src="includes/images/comments.png" border="0" alt="comments" /> Add A Comment</h2>
<p>Please use the form below to enter a new comment into the system</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<form name="addNewCommentForm" id="addNewCommentForm" action="#event.buildLink(rc.xehSave)#" method="POST">
	
	<input type="hidden" name="pageID" id="pageID" value="#rc.pageID#" />
	<input type="hidden" name="userID" id="userID" value="#rc.oUser.getUserID()#" />
	
	<!--- Comment --->
	<fieldset title="New Comment">
	<div>
		<legend>New Comment</legend>
		
		<label for="comment">Author *</label>
		<input type="text" name="author" id="author" size="40" required="true" value="#rc.author#" />
		
		<label for="comment">Email *</label>
		<input type="text" name="authorEmail" id="authorEmail" size="40" required="true" value="#rc.authorEmail#" />
		
		<label for="comment">URL</label>
		<input type="text" name="authorURL" id="authorURL" size="40" value=""/>
		
		<!--- comment --->
		<label for="comment">Comment</label>
		<textarea name="content" id="content" rows="5" cols="50" required="true"></textarea>
		
		<!--- Captcha --->
		<label for="captchacode">Enter the security code: *</label>
		<input type="text" name="captchacode" id="captchacode" value="" required="true" dName="Captcha Security Code">
		<!--- Display CAPTCHA image --->  
   		#getMyPlugin('captcha').display()#<br />  
		
	<div>* Required</div>
	</div>
	</fieldset>
	
	<!--- Loader Bar --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
	
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>	
	
	<!--- Create / Cancel --->
	<div id="_buttonbar" class="buttons align-center">
		<a href="javascript:closeModal()" class="buttonLinks">
			<span>
				<img src="includes/images/cancel.png" border="0" alt="cancel" />
				Cancel
			</span>
		</a>
		&nbsp;
		<a href="javascript:submitCommentForm()" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Add Comment
			</span>
		</a>
	</div>
	
</form>
</div>
</cfoutput>