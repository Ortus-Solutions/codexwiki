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
	The options below have to deal with the Codex Commenting System.
</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
	<fieldset>
	<legend><strong>Comment Options</strong></legend>
	 	<!--- Activate Comments  --->
		<label for="commenting_active">Activate Comments</label> 
		This setting will enable site-wide commenting.<br />
		<input type="radio" 
			   name="commenting_active" id="commenting_active"
			   <cfif rc.CodexOptions.commenting_active>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="commenting_active" id="commenting_active"
			   <cfif not rc.CodexOptions.commenting_active>checked="checked"</cfif>
			   value="0">No
		<br />
		
		<!--- Wiki Outgoing Email --->
		<label for="wiki_outgoing_email">Wiki Administrator Email</label>
		The email to use to send out email and also receive email notifications from.<br />
		<input type="text"
			   dName="Wiki Outgoing Email"
			   name="wiki_outgoing_email" id="wiki_outgoing_email" 
			   value="#rc.CodexOptions.wiki_outgoing_email#" 
			   size="60" required="true" mask="email">
		<br />
		
	</fieldset>
	
	<fieldset>
	<legend><strong>Comment Notifications</strong></legend>
	 	<!--- Notification Emails  --->
		<label for="commenting_notifification_emails">Notification Email(s)</label> 
		Please enter the email addresse(s) in comma-delimitted format that will receive email notifications from new or moderated comments.<br />
		<input type="text"
			   dName="Notification Email"
			   name="commenting_notifification_emails" id="commenting_notifification_emails" 
			   value="#rc.CodexOptions.commenting_notifification_emails#" 
			   size="60" required="true" mask="email">
		<br />
		<!--- Notification on Comment --->
		<label for="commenting_notification_onpost">Notification on Post</label> 
		Send a notification that a comment has been made.<br />
		<input type="radio" 
			   name="commenting_notification_onpost" id="commenting_notification_onpost"
			   <cfif rc.CodexOptions.commenting_notification_onpost>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="commenting_notification_onpost" id="commenting_notification_onpost"
			   <cfif not rc.CodexOptions.commenting_notification_onpost>checked="checked"</cfif>
			   value="0">No
		<br />
		
		<!--- Notification on Moderation --->
		<label for="commenting_notification_onmoderation">Notification for Moderation</label> 
		Send a notification that a comment needs moderation.<br />
		<input type="radio" 
			   name="commenting_notification_onmoderation" id="commenting_notification_onmoderation"
			   <cfif rc.CodexOptions.commenting_notification_onmoderation>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="commenting_notification_onmoderation" id="commenting_notification_onmoderation"
			   <cfif not rc.CodexOptions.commenting_notification_onmoderation>checked="checked"</cfif>
			   value="0">No
		<br />
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