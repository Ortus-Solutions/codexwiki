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
			$('##_loader').fadeIn();
			$('##addPermForm').submit();
		}
		function deleteRecord(recordID){
			$('##delete_'+recordID).attr('src','#getSetting('htmlBaseURL')#/includes/images/ajax-spinner.gif');
			window.location='#getSetting('sesBaseURL')#/#rc.xehRemovePerm#/user_id/#rc.user_id#/permissionID/'+recordID+'.cfm';
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
	
<!--- BACK --->
<div class="backbutton">
	<img src="#getSetting("htmlBaseURL")#/includes/images/arrow_left.png" align="absmiddle">
	<a href="#getSetting('sesBaseURL')#/#rc.xehUserListing#">Back</a>
</div>

<!--- Title --->
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/shield.png" align="absmiddle"> User Management : Edit User Permissions</h2>
<p>From here you can manage the user's a-la-carte permissions and view its inherited role permissions</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Add Permission  --->
<form name="addPermForm" id="addPermForm" method="POST" action="#getSetting('sesBaseURL')#/#rc.xehAddPerm#">
	<input type="hidden" name="user_id" id="user_id" value="#rc.user_id#">
	<div style="margin:10px;">
		
		<!--- Loader --->
		<div id="_loader" class="float-right formloader">
			<p>
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
		</div>
		
		<!--- Filter --->
		<label class="inline" for="search_criteria">Available Permissions</label>
		<select name="permissionID" id="permissionID">
			<cfloop query="rc.qAllPerms">
			<option value="#rc.qAllPerms.permissionID#">#rc.qAllPerms.permission#</option>
			</cfloop>
		</select>
		
		<!--- Search Button --->
		<a href="javascript:submitForm()" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/magnifier.png" border="0" align="absmiddle">
				Add Permission
			</span>
		</a>
		</p>
	</div>
</form>

<!--- Security Info --->
<fieldset >
	<legend>User Permissions</legend>
	<div>
		<p>
			<cfloop query="rc.qUserPerms">
			<img src="#getSetting('sesBaseURL')#/includes/images/accept.png" align="absmiddle"> 
			
			<a class="noborder" href="javascript:deleteRecord('#rc.qUserPerms.permissionID#');" title="Remove Permission"><img src="#getSetting('sesBaseURL')#/includes/images/stop.png" id="delete_#rc.qUserPerms.permissionID#" align="absmiddle" title="Remove Permission" border="0"></a>
			
			#rc.qUserPerms.permission#<br />
			</cfloop>
			<cfif rc.qUserPerms.recordcount eq 0>
			<em>No a-la-carte permissions</em>
			</cfif>
		</p>
	</div>
</fieldset>

<!--- Security Info --->
<fieldset >
	<legend>Role Permissions</legend>
	<div>
		<p>
			<cfloop query="rc.qRolePerms">
			<img src="#getSetting('sesBaseURL')#/includes/images/accept.png" align="absmiddle"> #rc.qRolePerms.permission#<br />
			</cfloop>
		</p>
	</div>
</fieldset>

<!--- Create / Cancel --->
	<div id="_buttonbar" class="buttons align-center" style="margin-top:8px;">
		<a href="#getSetting('sesBaseURL')#/#rc.xehUserListing#" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/cancel.png" border="0" align="absmiddle">
				Cancel
			</span>
		</a>
	</div>

</cfoutput>