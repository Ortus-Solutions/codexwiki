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
		$('##detailsForm').formValidation({
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
		$('##detailsForm').submit();
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h2>
	<img src="includes/images/user.png" alt="profile" /> Update Your Profile
</h2>

<p>
Please enter all the required information to update your profile details
</p>

#getPlugin("messagebox").renderit()#

<!--- Profile Details --->
<form name="detailsForm" id="detailsForm"
		action="#event.buildLink(rc.xehDoEdit)#"
		method="post">

<fieldset >
	<legend>Profile Details</legend>
	<div>
		<p>
		<label for="fname" >First Name:</label>
		<input type="text" name="fname" id="fname" dName="First Name"
				 required="true"
				 value="#rc.oUser.getfname()#"
				 maxlength="100"
				 size="40">
		<br />
		<label for="lname" >Last Name: </label>
		<input type="text" name="lname" id="lname" dName="Last Name"
				 required="true"
				 value="#rc.oUser.getlname()#"
				 maxlength="100"
				 size="40">
		<br />
		<label for="email" >Email Address:</label>
		<input type="text" name="email" id="email" dName="Email Address"
				 required="true"
				 value="#rc.oUser.getemail()#"
				 maxlength="255"
				 size="40">
		<br />
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
	<a href="#event.buildLink(rc.xehUserProfile)#" class="buttonLinks">
		<span>
			<img src="includes/images/cancel.png" border="0" alt="cancel" />
			Cancel
		</span>
	</a>
	&nbsp;
	<a href="javascript:submitForm()" class="buttonLinks">
		<span>
			<img src="includes/images/accept.png" border="0" alt="accept" />
			Update Profile
		</span>
	</a>
</div>
<br />
</form>

</cfoutput>