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
<h2><img src="includes/images/comments.png" alt="comments" /> Codex Comment Options</h2>
<p>
	The options below are used to configure the Codex Commenting System.
</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
<div>
	<fieldset>
	<legend><strong>Comment Options</strong></legend>
	 	<!--- Activate Comments  --->
		<label for="comments_enabled" class="light">Enable Site Wide Comments</label><br />
		<input type="radio" 
			   name="comments_enabled" id="comments_enabled"
			   <cfif rc.CodexOptions.comments_enabled>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_enabled" id="comments_enabled"
			   <cfif not rc.CodexOptions.comments_enabled>checked="checked"</cfif>
			   value="false">No		
			   
		<br />	   
		
		<!--- User Registration --->

		<label for="comments_registration" class="light">Users must be logged in and registered in order to comment.</label>
		<br />
		
		<input type="radio" 
			   name="comments_registration" id="comments_registration"
			   <cfif rc.CodexOptions.comments_registration>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_registration" id="comments_registration"
			   <cfif not rc.CodexOptions.comments_registration>checked="checked"</cfif>
			   value="false">No		
		<br />
		
		<!--- URL Translations --->
		<label for="comments_urltranslations" class="light">Translate URL's to links</label> <br />
		
		<input type="radio" 
			   name="comments_urltranslations" id="comments_urltranslations"
			   <cfif rc.CodexOptions.comments_urltranslations>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_urltranslations" id="comments_urltranslations"
			   <cfif not rc.CodexOptions.comments_urltranslations>checked="checked"</cfif>
			   value="false">No				
	</fieldset>
	
	<fieldset>
	<legend><strong>Before A Comment Appears</strong></legend>
	 	<!--- Enable Moderation --->
		<label for="comments_moderation" class="light">An administrator must moderate the comment</label> <br />
		
		<input type="radio" 
			   name="comments_moderation" id="comments_moderation"
			   <cfif rc.CodexOptions.comments_moderation>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_moderation" id="comments_moderation"
			   <cfif not rc.CodexOptions.comments_moderation>checked="checked"</cfif>
			   value="false">No		
			   
		<br />
		
		<!--- Comment Previous History --->

		<label for="comments_moderation_whitelist" class="light">Comment author must have a previously approved comment</label>
		<br />
		
		<input type="radio" 
			   name="comments_moderation_whitelist" id="comments_moderation_whitelist"
			   <cfif rc.CodexOptions.comments_moderation_whitelist>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_moderation_whitelist" id="comments_moderation_whitelist"
			   <cfif not rc.CodexOptions.comments_moderation_whitelist>checked="checked"</cfif>
			   value="false">No
	</fieldset>
	
	<fieldset>
	<legend><strong>Notifications</strong></legend>
	
		<label>The email the notifications will be sent to is: <a href="mailto:#rc.codexOptions.wiki_outgoing_email#">#rc.codexOptions.wiki_outgoing_email#</a></label>
	
		<!--- Notification on Comment --->
		<label for="comments_notify" class="light">Send a notification that a comment has been made.</label><br />
		
		<input type="radio" 
			   name="comments_notify" id="comments_notify"
			   <cfif rc.CodexOptions.comments_notify>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_notify" id="comments_notify"
			   <cfif not rc.CodexOptions.comments_notify>checked="checked"</cfif>
			   value="false">No		
		
		<br />
		
		<!--- Notification on Moderation --->
		<label for="comments_moderation_notify" class="light">Send a notification when a comment needs moderation.</strong>
		</label> 
		<br />
		
 		<input type="radio" 
			   name="comments_moderation_notify" id="comments_moderation_notify"
			   <cfif rc.CodexOptions.comments_moderation_notify>checked="checked"</cfif>
			   value="true">Yes
		<input type="radio" 
			   name="comments_moderation_notify" id="comments_notify"
			   <cfif not rc.CodexOptions.comments_moderation_notify>checked="checked"</cfif>
			   value="false">No		
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
		<input type="submit" class="submitButton" value="Save Options"></input>
   	</div>
	
</div>
</form>
</cfoutput>