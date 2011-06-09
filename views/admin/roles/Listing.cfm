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
		$('##_loader').fadeIn();
		$('##roleForm').submit();
	}
	function deleteRecord(recordID){
		if( recordID != null ){
			$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
			$("input[@name='roleID']").each(function(){
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
		$("##rolesTable").tablesorter({
			sortList: [[1,0]]
		});
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h2><img src="includes/images/vcard.png" alt="Roles" /> Role Management</h2>
<p>From here you can manage all the wiki roles.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Results Form --->
<form name="roleForm" id="roleForm" action="#event.buildLink(rc.xehDelete)#" method="post">
	
	<!--- Records Found --->
	<div class="float-left">
		<cfif rc.qRoles.recordcount>
		<em>Records Found: #rc.qRoles.recordcount#</em>
		<cfelse>
		<em>No Records Found</em>
		</cfif>
	</div>
	<!--- Add / Delete --->
	<div class="buttons">
		<a href="#event.buildLink(rc.xehCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="delete" />
				Delete
			</span>
		</a>
	</div>
	
	<!--- Render Results --->
	<table class="tablesorter" width="100%" id="rolesTable" cellspacing="1" cellpadding="0" border="0">
	
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th id="checkboxHolder" class="{sorter:false}"><input type="checkbox" onClick="checkAll(this.checked,'roleID')"/></th>
			<th >Role</th>
			<th >Description</th>
			<th id="actions" class="{sorter:false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qRoles">
		<tr <cfif CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="roleID" id="roleID" value="#roleID#" />
			</td>
			<td>
				#role#
			</td>
			<td>#description#</td>

			<!--- Display Commands --->
			<td class="center">
				<!--- Permissions Command --->
				<a href="#event.buildLink(rc.xehPerms & '/roleID/' & roleID)#" title="Edit Role Permissions"><img src="includes/images/shield.png" border="0" alt="edit" title="Edit Role Permissions"/></a>
				
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehEdit & '/roleID/' & roleID)#" title="Edit Role"><img src="includes/images/page_edit.png" border="0" alt="edit" title="Edit Role"/></a>
				
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#roleID#')" title="Delete Role"><img id="delete_#roleID#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Role"/></a>
			</td>

		</tr>
		</cfloop>
		</tbody>
	</table>
	
	<!--- Add / Delete --->
	<div class="buttons">
		<a href="#event.buildLink(rc.xehCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" alt="delete" />
				Delete
			</span>
		</a>
	</div>
	<br />


</form>

</cfoutput>