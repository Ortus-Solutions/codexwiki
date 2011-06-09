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
	function submitUpload(){
		$('##_uploadLoader').slideToggle();
		$('##UploadButton').toggle();
	}
	function submitReload(){
		$('##_reloadUploader').slideToggle();
		$('##reloadPluginsDiv').slideToggle();
	}
	function confirmDelete(plugin,linkTo){
		confirm("Do you wish to remove the <strong>"+plugin+"</strong> plugin?<br/>This cannot be undone!",function(){
			window.location.href=linkTo;
		});
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<h2><img src="includes/images/plugin.png" alt="plugins"/> 
CodeX Wiki Plugins</h2>
<p>
	From this panel you can see the installed Wiki Plugins, reload the plugins index,
	remove plugins and even install new plugins.
</p>

<!--- Box --->
#getPlugin("messagebox").renderit()#

<form name="uploadForm" id="uploadForm" 
	  action="#event.buildLink(rc.xehUpload)#" 
	  enctype="multipart/form-data"
	  method="post" onSubmit="submitUpload()">
	<p>
	<div id="_uploadLoader" class="formloader float-right">
		<p>
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>
	<label>Upload/Install Plugin</label>
	<input type="file" name="filePlugin" id="filePlugin" size="60">
	<!--- Loader --->
	<input type="submit" name="UploadButton" id="UploadButton" value="Upload/Install Plugin">
	</p>
</form>

<table class="tablelisting center" width="98%" align="center">
	<tr>
		<th>Installed Plugins</th>
		<th class="center" width="50">Actions</th>
	</tr>
	<cfloop query="rc.qPlugins">
		<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
			<td>#name#</td>
			<td class="center">
				<a href="javascript:confirmDelete('#jsstringFormat(getPlugin('Utilities').ripExtension(name))#','#event.buildLink(rc.xehRemove & '/plugin/' & getPlugin('Utilities').ripExtension(name))#')" 
				   title="Remove Plugin"><img src="includes/images/bin_closed.png" alt="remove" border="0"/></a>
			</td>
		</tr>
	</cfloop>
</table>

<br />

<!--- Reload Button --->
<div class="align-center" id="reloadPluginsDiv">
	<a href="#event.buildLink(rc.xehReload)#" onclick="return submitReload()" class="buttonLinks">
		<span>
			<img src="includes/images/arrow_refresh.png" border="0" alt="refresh" />
			Reload Plugins Index
		</span>
	</a>
</div>
<div id="_reloadUploader" class="formloader align-center">
	<p>
		Please Wait...<br />
		<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
	</p>
</div>
<br />
</cfoutput>