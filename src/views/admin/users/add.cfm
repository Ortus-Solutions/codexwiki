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
		$('##userForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});			
	});
	function submitForm(){
		$('##userForm').submit();		
	}
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
	
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
	
<!--- BACK --->
<div class="backbutton">
	<img src="includes/images/arrow_left.png" alt="back" />
	<a href="#event.buildLink(rc.xehUserListing)#">Back</a>
</div>

<!--- Title --->
<h2><img src="includes/images/user.png" alt="user" /> User Management : Create User</h2>
<p>Please fill out all the information below to create a new user. Please note that all passwords are encrypted.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="userForm" id="userForm" action="#event.buildLink(rc.xehUserCreate)#" method="post">
<div>
	<fieldset>
	<div>
		<legend><strong>User Information</strong></legend>
		
		<label for="fname">First Name</label>
		<input type="text" name="fname" id="fname" dName="First Name" size="30" value="#event.getValue("fname","")#" 
			   required="true">
		
		<label for="lname">Last Name</label>
		<input type="text" name="lname" id="lname" dName="Last Name" size="30" value="#event.getValue("lname","")#" 
			   required="true">
				 
		<label for="email">Email Address</label>
		<input type="text" name="email" id="email" dName="Email" size="30" mask="email" value="#event.getValue("email","")#" 
			   required="true">
	</div>
	</fieldset>
	
	
	<fieldset>
	<div>
		<legend >Security information</legend>
		<!--- Role --->
		<label for="role_id">User Role</label>
		<select name="role_id" id="role_id" dName="Role" required="true"  style="width:200px">
			<cfloop query="rc.qRoles">
			<option value="#rc.qRoles.roleid#">#rc.qRoles.role#</option>
			</cfloop>
		</select>
		
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
		<input type="text" name="username" id="username" dName="Username" size="30" 
			   required="true">
				 
		<!--- Password --->
		<label for="password">Password</label>
		<input type="password" name="password" id="password" dName="Password" size="30" 
			   required="true">
	</div>	
	</fieldset>
	
	<br />

	<!--- Loader Bar --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
	
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>	
	
	<!--- Create / Cancel --->
	<div id="_buttonbar" class="buttons align-center">
		<a href="#event.buildLink(rc.xehUserListing)#" class="buttonLinks">
			<span>
				<img src="includes/images/cancel.png" border="0" alt="cancel" />
				Cancel
			</span>
		</a>
		&nbsp;
		<a href="javascript:submitForm()" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Create User
			</span>
		</a>
	</div>
	<br />
</div>	
</form>
</cfoutput>