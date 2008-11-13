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
		function submitForm(){
			$('##_buttonbar').slideUp("fast");
			$('##_loader').fadeIn("slow");
		}
		$(document).ready(function() {
			$('.resizable').TextAreaResizer();
		});
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/cog.png" align="absmiddle"> Options</h2>
<p>
	Below you can see the CodexWiki main options and version information. Please be careful when editing the main options as it affects the entire wiki installation.
</p>

#getPlugin("messagebox").renderit()#


<form action="#event.buildLink(rc.xehReinitApp)#" name="reinitForm" id="reinitForm" method="post">
	<fieldset>
	<legend><strong>Codex Information</strong></legend>
		<label>Codex Version:</label>
	    	#getSetting('Codex').Version# #getSetting('Codex').Suffix#<br />
			<label for="fwreinit">Reinit Password/Key:</label>
	    		<input type="text" name="fwreinit" id="fwreinit" value="true">
				<input type="submit" name="submit" value="Reinitialize Application">
			(The ColdBox fwreinit password, if not set, use a boolean variable)
   </fieldset>
</form>

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" onsubmit="submitForm()">
	<fieldset>
	<legend><strong>Wiki Options</strong></legend>
	 	
		<label for="wikiname"><em>*</em> Wiki Name</label>
     	<input type="text" name="wikiname" id="wikiname" value="" size="60">
     	
		<label for="wikiname"><em>*</em> Wiki Show Key</label>
     	<input type="text" name="ShowKey" id="ShowKey" value="" size="30">
     
		<label for="wikiname"><em>*</em> Wiki Default Page</label>
     	<input type="text" name="defaultpage" id="defaultpage" value="" size="30"> 
		<img border="0" src="includes/images/accept.png" align="absmiddle">
		<a href="" id="defaultpagehref">Validate</a>
     
	</fieldset>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save Wiki Options"></input>
   	</div>
</form>
</cfoutput>