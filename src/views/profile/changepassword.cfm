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
	<img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> Change Password
</h1>

<p>
Please enter the information below, to change your password
</p>

#getPlugin("messagebox").renderit()#
	
<!--- Profile Details --->
<cfform name="passwordForm" id="passwordForm" 
		action="#getSetting('sesBaseURL')#/#rc.xehdoChangePass#" 
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
<div id="_loader" class="align-center hidden" style="margin:5px 5px 0px 0px;">
	<p class="bold red">
		Submitting...<br />
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
	</p>
	<br />
</div>

<!--- Button Bar --->
<div align="center" id="_buttonbar">
	<a href="javascript:submitForm()" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/accept.png" border="0" align="absmiddle">
			Update Password
		</span>
	</a>
	
</div>
<br />
</cfform>

</cfoutput>