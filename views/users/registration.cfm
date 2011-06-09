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
		$('##registerForm').formValidation({
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
	function copyEmail(copy){
		if( copy )
			$('##username').val($('##email').val());
		else
			$('##username').val('');
	}
	function validateUsername(){
		//Toggle Spinner
		$('##username_spinner').toggle();
		$('##username_validation').text('');
		//Prepare REquest
		var params = new Object();
		params.username = $('##username').val();
		//Get REquest
		$.get('#event.buildLink(rc.xehValidateUsername)#',params,function(data){
			data = $.trim(data);
			//Check username
			if( data == 'true'){
				$('##username_validation').text('Username is valid!');
				$('##username_validation').removeClass('red');
				$('##username_validation').addClass('green');				
			}
			else{
				$('##username_validation').text('Username is already in use');
				$('##username_validation').removeClass('green');
				$('##username_validation').addClass('red');	
			}
			$('##username_spinner').toggle();
		});
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h2>
	<img src="includes/images/user.png" alt="registration" /> New User Registration
</h2>

<p>
	Create a new account by filling out the form below, so you can contribute to this wiki.
</p>

<!--- MessageBox --->
#getPlugin("messagebox").renderit()#

<form name="registerForm" id="registerForm" method="post" action="#event.buildLink(rc.xehDoRegistration)#">

	<fieldset name="personal details">
		<legend>Personal Details</legend>
		
		Any notifications from the system will be sent to the email address you register with. 
		Also, if you lose your password, you can have a new one sent to your email address by using our forget password link.
		
		<!--- Name --->
		<label for="fname">First Name</label>
		<input type="text" name="fname" id="fname" value="#event.getValue("fname","")#" required="true" dName="First Name" size="30">
		<label for="lname">Last Name</label>
		<input type="text" name="lname" id="lname" value="#event.getValue("lname","")#" required="true" dName="Last Name" size="30">
		
		<!--- Email --->
		<label for="email">Email</label>
		<input type="text" name="email" id="email" value="#event.getValue("email","")#" required="true" dName="Email Address" size="30" mask="email">
	</fieldset>
	
	<fieldset name="login details">
		<legend>Login Details</legend>
		
		Please enter a username that you will use to login to this wiki.
		This must be unique: for example John Smith could use jsmith. Alternatively you can use your email address as your username.
		
		<!--- Username --->
		<label for="username">Username <input type="checkbox" name="emailcopy" value="true" onclick="copyEmail(this.checked)"> (Same as email)</label>
		<input type="text" name="username" id="username" value="#event.getValue("username","")#" required="true" dName="Username" size="30">
		
		<input type="button" value="Validate Username" onclick="validateUsername()">
		<img src="includes/images/ajax-spinner.gif" alt="spinner" name="username_spinner" id="username_spinner" class="hidden"/>
		
		<span id="username_validation"></span>
		
		<!--- Password --->
		<br /><br />
		Choose a password for your account. Pick something you will be able to remember, but something not to easy to figure out.
		To make sure you do not mistype your password, you must enter it twice.
		<label for="password">Password</label>
		<input type="password" name="password" id="password" value="" required="true" dName="Password" size="30">
		<label for="password">Confirm Password</label>
		<input type="password" name="c_password" id="c_password" value="" required="true" dName="Confirm Password" size="30" equal="password">
		
	</fieldset>
	
	<fieldset name="captcha">
		<legend>Confirmation</legend>
		<!--- Display CAPTCHA image --->  
   		#getMyPlugin('captcha').display()#<br />  
		<!--- Captcha --->
		<label for="captchacode">Enter the security code:</label>
		<input type="text" name="captchacode" id="captchacode" value="" required="true" dName="Captcha Security Code">
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
	<div id="_buttonbar" class="align-center">
		<input type="submit" class="submitButton" value="Register" />
	</div>
	<br />
</form>
</cfoutput>