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
		$('##loginform').formValidation({
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
	<img src="includes/images/key.png" alt="login" /> User Login
</h2>

<p>
Log in to the wiki system by using the form below.
<cfif rc.CodexOptions.wiki_registration>
	If you do not have an account, <a href="#event.buildLink(rc.xehUserRegistration)#">please create an account first.</a>
</cfif>
<br /><br />
</p>
<!--- Message Box --->
#getPlugin("messagebox").renderit()#

<form name="loginform" id="loginform" method="post" action="#event.buildLink(rc.xehUserDoLogin)#">
	<input type="hidden" name="_securedURL" value="#event.getValue("_securedURL","")#">
	<p class="align-center">
		<br /><br />
		<label for="username" class="inline">Username</label>
		<input type="text" name="username" id="username" size="30" maxlength="50" dName="Username" required="true"/>
		<br /><br />
		<label for="username" class="inline">Password</label>
		<input type="password" name="password" id="password" size="30" maxlength="50" dName="Password" required="true"/>
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
		<a href="#event.buildLink(rc.xehUserReminder)#">Forgot Password?</a>
		<br /><br />
		<input type="submit" class="submitButton" value="Log In" />
	</div>
	<br />
</form>
</cfoutput>