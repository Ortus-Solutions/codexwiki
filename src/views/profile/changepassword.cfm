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
			if( _CF_checkpasswordForm(document.getElementById('passwordForm')) ){
				$('##passwordForm').submit();
				$('##_buttonbar').slideUp("fast");
				$('##_loader').fadeIn("slow");
			}
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h1>
	<img src="includes/images/key.png" align="absmiddle"> Change Password
</h1>

<p>
Please enter the information below, to change your password
</p>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Profile Details --->
<cfform name="passwordForm" id="passwordForm"
		action="#event.buildLink(rc.xehdoChangePass,0)#.cfm"
		method="post">
<fieldset >
	<legend>Password Change Request</legend>
	<div>
		<p>
		<label >Current Password: </label>
		<cfinput name="c_password" id="c_password" type="password"
				 required="true"
				 message="Please enter your current password."
				 size="30"
				 maxlength="50">
		<br />
		<label >New Password: </label>
		<cfinput name="n_password" id="n_password" type="password"
				 required="true"
				 message="Please enter the new password."
				 size="30"
				 maxlength="50">
		<br />
		<label >New Password Confirmation: </label>
		<cfinput name="n2_password" id="n2_password" type="password"
				 required="true"
				 message="Please enter your new password confirmation."
				 size="30"
				 maxlength="50">
		</p>
	</div>
</fieldset>

<!--- Loader --->
<div id="_loader" class="align-center formloader">
	<p>
		Submitting...<br />
		<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
	</p>
</div>

<!--- Button Bar --->
<div align="center" id="_buttonbar">
	<a href="javascript:submitForm()" id="buttonLinks">
		<span>
			<img src="includes/images/accept.png" border="0" align="absmiddle">
			Update Password
		</span>
	</a>

</div>
<br />
</cfform>

</cfoutput>