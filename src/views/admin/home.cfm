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
	function submitReinit(){
		$('##_loader2').slideToggle();
		$('##ReinitSubmit').toggle();
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<cfoutput>
	
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Welcome --->
<h2><img src="includes/images/shield.png" align="absmiddle"> Welcome to your CodeX Administrator dashboard</h2>
<p>
	From this panel, you will be able to manage this CodeX installation. Please read all the instructions whenever
	making changes to the system settings. As you can see, a new panel has appeared in your sidebar that will let you 
	manage CodeX. So please use the available menu options under the <strong>Admin Menu</strong> box.
</p>

<!--- Beta Notification --->
<div class="cbox_messagebox_warning">
	<p class="cbox_messagebox">
	Please bear in mind that some admin features have not been built yet. Enjoy Codex!
	</p>
</div>

<!--- Reinit Box --->
<form action="#event.buildLink(rc.xehReinitApp)#" name="reinitForm" id="reinitForm" method="post" onSubmit="submitReinit()">
	<fieldset>
	<legend><strong>Codex Information</strong></legend>
		<label>Codex Version:</label>
	    	#getSetting('Codex').Version# #getSetting('Codex').Suffix#<br />
		<label for="fwreinit">Restart CodeX:</label>
		This will start the application fresh, clean the cache and settings<br />
	    <input type="submit" id="ReinitSubmit" name="ReinitSubmit" value="Reinitialize Application">
	    
	    <!--- Loader --->
		<div id="_loader2" class="align-center formloader">
			<p>
				Reloading...<br />
				<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
		</div>
		
   </fieldset>
</form>
</cfoutput>