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
		$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
		window.location='#event.buildLink(linkTo=rc.xehRemovePerm,override=true)#/roleID/#rc.roleID#/permissionID/'+recordID+'#event.getRewriteExtension()#';
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
	
<!--- BACK --->
<div class="backbutton">
	<img src="includes/images/arrow_left.png" alt="back" />
	<a href="#event.buildLink(rc.xehListing)#">Back</a>
</div>

<!--- Title --->
<h2><img src="includes/images/vcard.png" alt="perms"/> Role Management : Role Permissions for '#rc.oRole.getRole()#'</h2>
<p>From here you can manage the role's permissions.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Add Permission  --->
<form name="addPermForm" id="addPermForm" method="POST" action="#event.buildLink(rc.xehAddPerm)#">
	<input type="hidden" name="roleID" id="roleID" value="#rc.roleID#">
	<div style="margin:10px;">
		
		<!--- Loader --->
		<div id="_loader" class="float-right formloader">
			<p>
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
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
		<a href="javascript:submitForm()" class="buttonLinks">
			<span>
				<img src="includes/images/magnifier.png" border="0" alt="add" />
				Add Permission
			</span>
		</a>
		</p>
	</div>
</form>

<!--- Security Info --->
<fieldset >
	<legend>Role Permissions</legend>
	<div>
		<p>
			<cfloop query="rc.qRolePerms">
			<img src="includes/images/accept.png" alt="add"/> 
			
			<a class="noborder" href="javascript:deleteRecord('#rc.qRolePerms.permissionID#');" title="Remove Permission"><img src="includes/images/stop.png" id="delete_#rc.qRolePerms.permissionID#" alt="remove" title="Remove Permission" border="0"/></a>
			
			#rc.qRolePerms.permission#<br />
			</cfloop>
			<cfif rc.qRolePerms.recordcount eq 0>
			<em>No permissions attached</em>
			</cfif>
		</p>
	</div>
</fieldset>

<!--- Create / Cancel --->
<div id="_buttonbar" class="buttons align-center" style="margin-top:8px;">
	<a href="#event.buildLink(rc.xehListing)#" class="buttonLinks">
		<span>
			<img src="includes/images/cancel.png" border="0" alt="cancel" />
			Cancel
		</span>
	</a>
</div>

</cfoutput>