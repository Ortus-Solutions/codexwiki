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
	$(document).ready(function() {
		/* Form Validation */
		$('##reminderform').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'submitForm'
		});			
	});
	function submitForm(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h2>
	<img src="includes/images/key.png" alt="Reminder" /> Password Reminder
</h2>

<p>
Please enter your email address below and click the Send Password button. This will generate a new temporary password and email it to you.
<br /><br />
</p>

<!--- MessageBox --->
#getPlugin("MessageBox").renderit()#

<form name="reminderform" id="reminderform" method="post" action="#event.buildLink(rc.xehDoReminder)#">

	<p class="align-center">
	<br /><br />
	<label for="email" class="inline">Email</label>
	<input type="text" name="email" id="email"
		   size="50"
		   dName="Email Address"
		   required="true"
		   maxlength="255"/>
	</p>
	
	<br />

	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>

	<!--- Button Bar --->
	<div align="center" id="_buttonbar">
		<input type="submit" class="submitButton" value="Send Password" />
	</div>
	<br />
</form>
</cfoutput>