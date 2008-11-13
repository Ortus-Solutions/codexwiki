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
			$('##_buttonbar').slideUp("fast");
			$('##_loader').fadeIn("slow");
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h1>
	<img src="includes/images/key.png" align="absmiddle"> User Login
</h1>

<p>
Log in to the wiki system by using the form below.
<cfif rc.oUser.checkPermission('WIKI_REGISTRATION')>
	If you do not have an account, <a href="#getSetting('sesBaseURL')#/#rc.xehUserRegistration#">please create an account first.</a>
</cfif>
<br /><br />
</p>

#getPlugin("messagebox").renderit()#

<form name="loginform" id="loginform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehUserDoLogin#" onsubmit="submitForm()">

	<div align="center" style="margin-top:10px">
	<label for="username" class="inline">Username</label>
	<input type="text" name="username" id="username" size="30" maxlength="50"/>
	<br /><br />
	<label for="username" class="inline">Password</label>
	<input type="password" name="password" id="password" size="30" maxlength="50"/>
	</div>

	<br />

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
		<a href="#getSetting('sesBaseURL')#/#rc.xehUserReminder#">Forgot Password?</a>
		<br /><br />
		<input type="submit" class="submitButton" value="Log In" />
	</div>
	<br />
</form>
</cfoutput>