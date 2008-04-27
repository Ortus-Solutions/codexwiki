<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function submitForm(){
			if( _CF_checkuserForm(document.getElementById('userForm')) ){
				$('##_buttonbar').slideUp("fast");
				$('##_loader').fadeIn("slow");
				$('##userForm').submit();
			}
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> User Management : Edit User</h2>
<p>Please fill out all the information below to create a new user. Please note that all passwords are encrypted.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<cfform name="userForm" id="userForm" action="#getSetting('sesBaseURL')#/#rc.xehUserUpdate#/user_id/#rc.user_id#.cfm">
	
	<fieldset>
	<legend><strong>User Information</strong></legend>
	
	<label for="fname">First Name</label>
	<cfinput type="text" name="fname" id="fname" size="30" 
			 message="Please enter the first name"
			 required="true"
			 value="#rc.thisUser.getfname()#">
	
	<label for="lname">Last Name</label>
	<cfinput type="text" name="lname" id="lname" size="30" 
			 message="Please enter the last name"
			 required="true"
			 value="#rc.thisUser.getlname()#">
			 
	<label for="email">Email Address</label>
	<cfinput type="text" name="email" id="email" size="30" 
			 message="Please enter the email address"
			 required="true"
			 value="#rc.thisUser.getemail()#">
			 
	</fieldset>
	
	<fieldset>
		<legend >Security information</legend>
		
		<!--- Role --->
		<label for="role_id">User Role</label>
		<cfselect name="role_id" id="role_id" required="true" message="Please choose a role for this user." style="width:200px">
			<cfloop query="rc.qRoles">
			<option value="#rc.qRoles.roleid#" <cfif rc.thisUser.getRole().getroleID() eq rc.qRoles.roleid>selected="selected"</cfif>>#rc.qRoles.role#</option>
			</cfloop>
		</cfselect>
		
		<!--- Active Bit --->
		<label for="isActive">Active</label>
		<select name="isActive" id="isActive" style="width:200px">
			<option value="true" <cfif rc.thisUser.getisActive()>selected="selected"</cfif>>true</option>
			<option value="false" <cfif not rc.thisUser.getisActive()>selected="selected"</cfif>>false</option>
		</select>
		
		<!--- Confirmed --->		 
		<label for="isConfirmed">Confirmed</label>
		<select name="isConfirmed" id="isConfirmed" style="width:200px">
			<option value="true" <cfif rc.thisUser.getisConfirmed()>selected="selected"</cfif>>true</option>
			<option value="false" <cfif not rc.thisUser.getisConfirmed()>selected="selected"</cfif>>false</option>
		</select>
		
		<!--- UserName --->
		<label for="username">Username</label>
		<cfinput type="text" name="username" id="username" size="30" 
				 message="Please enter the username"
				 required="true" 
				 value="#rc.thisUser.getUsername()#">
		
		<!--- Password --->
		<label for="newpassword">New Password</label>
		<p>Only fill this new password if you would like to change the user's password.</p>
		<input type="password" name="newpassword" id="newpassword" size="30">
		
	</fieldset>
	
	<br />

	<!--- Loader Bar --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
	
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>	
	<!--- Create / Cancel --->
	<div id="_buttonbar" class="buttons align-center" style="margin-top:8px;">
		<a href="#getSetting('sesBaseURL')#/#rc.xehUserListing#" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/cancel.png" border="0" align="absmiddle">
				Cancel
			</span>
		</a>
		&nbsp;
		<a href="javascript:submitForm()" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/add.png" border="0" align="absmiddle">
				Update User
			</span>
		</a>
	</div>
	<br />
</cfform>
</cfoutput>