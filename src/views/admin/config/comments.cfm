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
		$('##optionForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});
	});
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/comments.png" align="absmiddle"> Codex Comment Options</h2>
<p>
	The options below are used to configure the Codex Commenting System.
</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
	<fieldset>
	<legend><strong>Comment Options</strong></legend>
	 	<!--- Activate Comments  --->
		<input type="checkbox" 
			   name="comments_enabled" id="comments_enabled"
			   <cfif rc.CodexOptions.comments_enabled>checked="checked"</cfif>
			   value="1">
		<label for="comments_enabled" class="light">Enable Site Wide Comments</label><br />
		
		<!--- User Registration --->
		<input type="checkbox" 
			   name="comments_registration" id="comments_registration"
			   <cfif rc.CodexOptions.comments_registration>checked="checked"</cfif>
			   value="1">
		<label for="comments_registration" class="light">Users must be logged in and registered in order to comment.</label> 
		<br />
		
		<!--- URL Translations --->
		<input type="checkbox" 
			   name="comments_urltranslations" id="comments_urltranslations"
			   <cfif rc.CodexOptions.comments_urltranslations>checked="checked"</cfif>
			   value="1">
		<label for="comments_urltranslations" class="light">Translate URL's to links</label> <br />
	</fieldset>
	
	<fieldset>
	<legend><strong>Before A Comment Appears</strong></legend>
	 	<!--- Enable Moderation --->
		<input type="checkbox" 
			   name="comments_moderation" id="comments_moderation"
			   <cfif rc.CodexOptions.comments_moderation>checked="checked"</cfif>
			   value="1">
		<label for="comments_moderation" class="light">An administrator must moderate the comment</label> <br />
		
		<!--- Comment Previous History --->
		<input type="checkbox" 
			   name="comments_moderation_whitelist" id="comments_moderation_whitelist"
			   <cfif rc.CodexOptions.comments_moderation_whitelist>checked="checked"</cfif>
			   value="1">
		<label for="comments_moderation_whitelist" class="light">Comment author must have a previously approved comment</label>
	</fieldset>
	
	
	<fieldset>
	<legend><strong>Notifications</strong></legend>
		<!--- Notification on Comment --->
		<input type="checkbox" 
			   name="comments_notify" id="comments_notify"
			   <cfif rc.CodexOptions.comments_notify>checked="checked"</cfif>
			   value="1">
		<label for="comments_notify" class="light">Send a notification that a comment has been made.</label><br />
		
		<!--- Notification on Moderation --->
		<input type="checkbox" 
			   name="comments_moderation_notify" id="comments_moderation_notify"
			   <cfif rc.CodexOptions.comments_moderation_notify>checked="checked"</cfif>
			   value="1">
		<label for="comments_moderation_notify" class="light">Send a notification when a comment needs moderation.</label> 
	</fieldset>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save Options"></input>
   	</div>
</form>
</cfoutput>