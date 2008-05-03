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
	
<!--- BACK --->
<div class="backbutton">
	<img src="#getSetting("htmlBaseURL")#/includes/images/arrow_left.png" align="absmiddle">
	<a href="#getSetting('sesBaseURL')#/#rc.xehUserListing#">Back</a>
</div>

<!--- Title --->
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> User Management : Create User</h2>
<p>Please fill out all the information below to create a new user. Please note that all passwords are encrypted.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<cfform name="userForm" id="userForm" action="#getSetting('sesBaseURL')#/#rc.xehUserCreate#">
	
	<fieldset>
	<legend><strong>User Information</strong></legend>
	
	<label for="fname">First Name</label>
	<cfinput type="text" name="fname" id="fname" size="30" 
			 message="Please enter the first name"
			 required="true">
	
	<label for="lname">Last Name</label>
	<cfinput type="text" name="lname" id="lname" size="30" 
			 message="Please enter the last name"
			 required="true">
			 
	<label for="email">Email Address</label>
	<cfinput type="text" name="email" id="email" size="30" 
			 message="Please enter the email address"
			 required="true">
			 
	</fieldset>
	
	<fieldset>
		<legend >Security information</legend>
		
		<!--- Role --->
		<label for="role_id">User Role</label>
		<cfselect name="role_id" id="role_id" required="true" message="Please choose a role for this user." style="width:200px">
			<cfloop query="rc.qRoles">
			<option value="#rc.qRoles.roleid#">#rc.qRoles.role#</option>
			</cfloop>
		</cfselect>
		
		<!--- Active Bit --->
		<label for="isActive">Active</label>
		<select name="isActive" id="isActive" style="width:200px">
			<option value="true" checked="checked">true</option>
			<option value="false">false</option>
		</select>
		
		<!--- Confirmed --->		 
		<label for="isConfirmed">Confirmed</label>
		<select name="isConfirmed" id="isConfirmed" style="width:200px">
			<option value="true" checked="checked">true</option>
			<option value="false">false</option>
		</select>
		
		<!--- UserName --->
		<label for="username">Username</label>
		<cfinput type="text" name="username" id="username" size="30" 
				 message="Please enter the username"
				 required="true">
				 
		<!--- Password --->
		<label for="password">Password</label>
		<cfinput type="password" name="password" id="password" size="30" 
				 message="Please enter the password"
				 required="true">
		
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
				Create User
			</span>
		</a>
	</div>
	<br />
</cfform>
</cfoutput>