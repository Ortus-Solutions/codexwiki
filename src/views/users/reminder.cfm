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
	<img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> Password Reminder
</h1>

<p>
Please enter your email address below and click the Send Password button. This will generate a new temporary password and email it to you.
<br /><br />
</p>

#getPlugin("messagebox").renderit()#

<cfform name="reminderform" id="reminderform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehDoReminder#" onsubmit="submitForm()">
	
	<div align="center" style="margin-top:10px">
	<label for="email" class="inline">Email</label>
	<cfinput type="text" name="email" id="email" 
			 size="50" 
			 required="true" 
			 message="Please enter your email" maxlength="255"/>
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
		<input type="submit" class="submitButton" value="Send Password"></input>
	</div>
	<br />
</cfform>
</cfoutput>