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
	<img src="#getSetting('htmlBaseURL')#/includes/images/key.png" align="absmiddle"> Password Reminder
</h1>

<p>
Please enter your email address below and click the Send Password button. This will generate a new temporary password and email it to you.
<br /><br />
</p>

#getPlugin("messagebox").renderit()#

<form name="reminderform" id="reminderform" method="post" action="#getSetting('sesBaseURL')#/#rc.xehDoReminder#" onsubmit="submitForm()">

	<div align="center" style="margin-top:10px">
	<label for="email" class="inline">Email</label>
	<input type="text" name="email" id="email"
		   size="50"
		   maxlength="255"/>
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
		<input type="submit" class="submitButton" value="Send Password" />
	</div>
	<br />
</form>
</cfoutput>