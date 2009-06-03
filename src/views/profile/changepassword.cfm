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
		$('##passwordForm').formValidation({
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
	function submitForm(){
		$('##passwordForm').submit();
	}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h2>
	<img src="includes/images/key.png" alt="password" /> Change Password
</h2>

<p>
Please enter the information below, to change your password
</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Profile Details --->
<form name="passwordForm" id="passwordForm"
		action="#event.buildLink(rc.xehdoChangePass)#"
		method="post">
			
<fieldset >
	<legend>Password Change Request</legend>
	<div>
		<p>
		<label >Current Password: </label>
		<input name="c_password" id="c_password" type="password" dName="Current Password"
				 required="true"
				 size="35"
				 maxlength="50">
		<br />
		<label >New Password: </label>
		<input name="n_password" id="n_password" type="password" dName="New Password"
				 required="true"
				 size="35"
				 maxlength="50">
		<br />
		<label >New Password Confirmation: </label>
		<input name="n2_password" id="n2_password" type="password" dName="New Password Confirmation"
				 required="true" equal="n_password"
				 size="35"
				 maxlength="50">
		</p>
	</div>
</fieldset>

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
	<a href="javascript:submitForm()" class="buttonLinks">
		<span>
			<img src="includes/images/accept.png" border="0" alt="accept" />
			Update Password
		</span>
	</a>

</div>
<br />
</form>

</cfoutput>