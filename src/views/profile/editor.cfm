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
		function submitForm(){
			if( _CF_checkdetailsForm(document.getElementById('detailsForm')) ){
				$('##detailsForm').submit();
				$('##_buttonbar').slideUp("fast");
				$('##_loader').fadeIn("slow");
			}
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> Update Your Profile
</h1>

<p>
Please enter all the required information to update your profile details
</p>

#getPlugin("messagebox").renderit()#

<!--- Profile Details --->
<cfform name="detailsForm" id="detailsForm"
		action="#getSetting('sesBaseURL')#/#rc.xehDoEdit#"
		method="post">

<fieldset >
	<legend>Profile Details</legend>
	<div>
		<p>
		<label for="fname" >First Name:</label>
		<cfinput type="text" name="fname" id="fname"
				 required="true"
				 message="Please enter your first name"
				 value="#rc.oUser.getfname()#"
				 maxlength="100"
				 size="40">
		<br />
		<label for="lname" >Last Name: </label>
		<cfinput type="text" name="lname" id="lname"
				 required="true"
				 message="Please enter your last name"
				 value="#rc.oUser.getlname()#"
				 maxlength="100"
				 size="40">
		<br />
		<label for="email" >Email Address:</label>
		<cfinput type="text" name="email" id="email"
				 required="true"
				 message="Please enter your email address"
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
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
	</p>
</div>

<!--- Button Bar --->
<div align="center" id="_buttonbar">
	<a href="#getSetting('sesBaseURL')#/#rc.xehUserProfile#" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/cancel.png" border="0" align="absmiddle">
			Cancel
		</span>
	</a>
	&nbsp;
	<a href="javascript:submitForm()" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/accept.png" border="0" align="absmiddle">
			Update Profile
		</span>
	</a>
</div>
<br />
</cfform>

</cfoutput>