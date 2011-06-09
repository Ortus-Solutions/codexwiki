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
	$(document).ready(function() {
		/* Form Validation */
		$('##commentForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});			
	});
	function submitForm(){
		$('##commentForm').submit();		
	}
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
	
<!--- BACK --->
<div class="backbutton">
	<img src="includes/images/arrow_left.png" alt="back" />
	<a href="#event.buildlink(rc.xehListing)#">Back</a>
</div>

<!--- Title --->
<h2><img src="includes/images/comments.png" alt="comment"/> Edit Comment</h2>
<p>Edit the comment below.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="commentForm" id="commentForm" action="#event.buildlink(rc.xehUpdate & '/commentID/' & rc.commentID)#">
	
	<fieldset>
		<legend><strong>Author Information</strong></legend>
		
		<label for="author">Name</label>
		<input type="text" name="author" id="author" dName="Author" size="50" value="#rc.oComment.getAuthor()#" required="true">
		
		<label for="authorEmail">Email</label>
		<input type="text" name="authorEmail" id="authorEmail" dName="Author Email" size="50" value="#rc.oComment.getAuthorEmail()#" required="true">
		
		<label for="authorURL">URL <a href="<cfif NOT findnocase("http",rc.oComment.getauthorURL())>http://</cfif>#rc.oComment.getauthorURL()#" target="_blank" title="Visit Site"><img src="includes/images/link.png" border="0" alt-"link" /></a></label>
		<input type="text" name="authorURL" id="authorURL" size="50" value="#rc.oComment.getauthorURL()#">
		
		<label>IP Address</label>
		<span class="red"><img src="includes/images/server_key.png" alt="link" /> 
				<a href="http://ws.arin.net/cgi-bin/whois.pl?queryinput=#rc.oComment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.oComment.getAuthorIP()#</a></span>
		
	</fieldset>
	
	<fieldset>
		<legend for="content"><strong>Comment</strong></legend>
		<textarea name="content" id="content" dName="Comment" required="true" rows="5">#rc.oComment.getContent()#</textarea>
	</fieldset>
	
	<br />

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
		<a href="#event.buildLink(rc.xehListing)#" class="buttonLinks">
			<span>
				<img src="includes/images/cancel.png" border="0" alt="cancel" />
				Cancel
			</span>
		</a>
		&nbsp;
		<a href="javascript:submitForm()" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Update Comment
			</span>
		</a>
	</div>
	<br />
</form>
</cfoutput>