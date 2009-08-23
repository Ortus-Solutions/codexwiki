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
function searchForm(){
	$('##_loader').fadeIn();
	$('##searchFilterForm').submit();
}
function submitForm(){
	$('##_loader').fadeIn();
	$('##userForm').submit();
}
function deleteRecord(recordID){
	if( recordID != null ){
		$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
		$("input[@name='user_id']").each(function(){
			if( this.value == recordID ){ this.checked = true;}
			else{ this.checked = false; }
		});
	}
	//Submit Form
	submitForm();
}
function confirmDelete(recordID){
	confirm("Do you wish to remove the selected record(s)?<br/>This cannot be undone!",function(){deleteRecord(recordID)});
}
$(document).ready(function() {
	// call the tablesorter plugin
	$("##usersTable").tablesorter({
		sortList: [[1,0]]
	});
	$("##quickfilter").keyup(function(){
		$.uiTableFilter( $("##usersTable"), this.value );
	})
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- Title --->
<h2><img src="includes/images/user.png" alt="user" /> User Management</h2>
<p>From here you can manage and search for all the wiki users.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="searchFilterForm" id="searchFilterForm" method="POST" action="#event.buildLink(rc.xehUserListing)#">

	<div id="adminFilterBar">
		<!--- Loader --->
		<div id="_loader" class="float-right formloader">
			<p>
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
				<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			</p>
		</div>

		<a href="#event.buildLink(rc.xehUserListing)#" <cfif rc.filter eq "all">class="linkBold"</cfif>>All <cfif rc.filter eq "all">(#rc.qUsers.recordcount#)</cfif></a> |
		<a href="#event.buildLink(rc.xehUserListing & '/filter/pending')#" <cfif rc.filter eq "pending">class="linkBold"</cfif>>Pending <cfif rc.filter eq "pending">(#rc.qUsers.recordcount#)</cfif></a> |
		<a href="#event.buildLink(rc.xehUserListing & '/filter/confirmed')#" <cfif rc.filter eq "confirmed">class="linkBold"</cfif>>Confirmed <cfif rc.filter eq "confirmed">(#rc.qUsers.recordcount#)</cfif></a> |	
		<a href="#event.buildLink(rc.xehUserListing & '/filter/inactive')#" <cfif rc.filter eq "inactive">class="linkBold"</cfif>>Inactive <cfif rc.filter eq "inactive">(#rc.qUsers.recordcount#)</cfif></a>
		
		<div class="float-right">
		<!--- Filter --->
		<label class="inline" for="search_criteria">Search</label>
		<input type="text" size="20" name="search_criteria" id="search_criteria" value="#rc.search_criteria#" title="First Name, Last Name and Email">
		&nbsp;
		<!--- Role --->
		<label class="inline" for="role_id">Role</label>
		<select name="role_id" id="role_id">
			<option value="0" <cfif rc.role_id eq rc.qRoles.roleid>selected="selected"</cfif>>All Roles</option>
			<cfloop query="rc.qRoles">
			<option value="#rc.qRoles.roleid#" <cfif rc.role_id eq rc.qRoles.roleid>selected="selected"</cfif>>#rc.qRoles.role#</option>
			</cfloop>
		</select>

		<!--- Search Button --->
		<a href="javascript:searchForm()" class="buttonLinks" title="Search">
			<span>
				<img src="includes/images/magnifier.png" border="0" alt="Search" />
			</span>
		</a>
		</div>
	</div>
</form>

<!--- Results Form --->
<form name="userForm" id="userForm" action="#event.buildLink(rc.xehUserDelete)#" method="post">
	
	<!--- Records Found --->
	<div class="float-left">
		<label class="inlineLabel">Quick Filter: </label>
		<input type="text" size="20" id="quickfilter" value="">
	</div>
	
	<!--- Add / Delete --->
	<div class="buttons">
		<a href="#event.buildLink(rc.xehUserCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="stop" />
				Delete
			</span>
		</a>
	</div>
	
	<br />
	
	<!--- Render Results --->
	<table class="tablesorter" width="100%" id="usersTable" cellspacing="1" cellpadding="0" border="0">
	
		<!--- Display Fields Found in Query --->
		<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter: false}"><input type="checkbox" onClick="checkAll(this.checked,'user_id')"/></th>
			<th>Name</th>
			<th>Email</th>
			<th class="center" width="95">Confirmed</th>
			<th id="actions" class="{sorter: false}">ACTIONS</th>
		</tr>
		</thead>
		<!--- Loop Through Query Results --->
		<tbody>
		<cfloop query="rc.qUsers">
		<tr <cfif CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<cfif not user_isDefault>
				<input type="checkbox" name="user_id" id="user_id" value="#user_id#" />
				</cfif>
			</td>
			<td>
				<!--- Avatar --->
				#getMyPlugin("avatar").renderAvatar(email:user_email,size:32)#
				<!--- Name --->
				#user_fname# #user_lname#
				<!--- Default Image --->
				<cfif user_isDefault><img src="includes/images/asterisk_orange.png" alt="default" /></cfif>
			</td>
			<td><a href="mailto:#user_email#">#user_email#<a/></td>
			<td class="center">#yesnoformat(user_isconfirmed)#</td>

			<!--- Display Commands --->
			<td class="center">
				<!--- Permissions Command --->
				<a href="#event.buildLink(rc.xehUserPerms & '/user_id/' & user_id)#" title="Edit User Permissions"><img src="includes/images/shield.png" border="0" alt="shield" title="Edit User Permissions"/></a>
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehUserEdit & '/user_id/' & user_id)#" title="Edit User"><img src="includes/images/page_edit.png" border="0" alt="edit" title="Edit User"/></a>
				<cfif not user_isDefault>
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#user_id#')" title="Delete User"><img id="delete_#user_id#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Record"/></a>
				</cfif>
			</td>

		</tr>
		</cfloop>
		</tbody>
	</table>
	
	<p><img src="includes/images/asterisk_orange.png" alt="default" /> <strong>Default User</strong></p>

	<!--- Add / Delete --->
	<div class="buttons">
		<a href="#event.buildLink(rc.xehUserCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="stop" />
				Delete
			</span>
		</a>
	</div>
	<br />


</form>

</cfoutput>