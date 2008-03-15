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
	<img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> User Login
</h1>

<p>
Log in to the wiki system by using the form below.
<cfif rc.oUser.checkPermission('WIKI_REGISTRATION')>
If you do not have an account, <a href="#getSetting('sesBaseURL')#/#rc.xehUserRegistration#">please create an account first.</a>
</cfif>
<br /><br />
</p>

#getPlugin("messagebox").renderit()#

<cfform name="loginform" id="loginform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehUserDoLogin#" onsubmit="submitForm()">
	
	<div align="center" style="margin-top:10px">
	<label for="username" class="inline">Username</label>
	<cfinput type="text" name="username" id="username" size="30" required="true" message="Please enter your username" maxlength="50"/>
	<br /><br />
	<label for="username" class="inline">Password</label>
	<cfinput type="password" name="password" id="password" size="30" required="true" message="Please enter your password" maxlength="50"/>
	</div>
	
	<br />
	
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
		<a href="#getSetting('sesBaseURL')#/#rc.xehUserReminder#">Forgot Password?</a>
		<br /><br />
		<input type="submit" class="submitButton" value="Log In"></input>
	</div>
	<br />
</cfform>
</cfoutput>