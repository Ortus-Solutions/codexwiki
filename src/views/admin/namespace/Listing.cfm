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
	$('##namespaceForm').submit();
}
function deleteRecord(recordID){
	if( recordID != null ){
		$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
		$("input[@name='namespaceID']").each(function(){
			if( this.value == recordID ){ this.checked = true;}
			else{ this.checked = false; }
		});
	}
	//Submit Form
	submitForm();
}
function confirmDelete(recordID){
	confirm("Do you wish to remove the selected namespace(s)?<br/>This cannot be undone and ALL pages within that namespace will be deleted!",function(){deleteRecord(recordID)});
}
function directoryDialog(namespace){
	var data = {nolayout:'true'};
	openModal("#event.BuildLink(rc.xehNamespaceViewer)#/"+namespace,data);
}
$(document).ready(function() {
	// call the tablesorter plugin
	$("##namespaceTable").tablesorter({
		sortList: [[1,0]]
	});
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h2><img src="includes/images/namespace.png" alt="Roles" /> Namespace Management</h2>
<p>From here you can manage all the wiki page namespaces.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Results Form --->
<form name="namespaceForm" id="namespaceForm" action="#event.buildLink(rc.xehDelete)#" method="post">
	
	<!--- Records Found --->
	<div class="float-left">
		<cfif rc.qNamespaces.recordcount>
		<em>Records Found: #rc.qNamespaces.recordcount#</em>
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
	<table class="tablesorter" width="100%" id="namespaceTable" cellspacing="1" cellpadding="0" border="0">
	
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th id="checkboxHolder" class="{sorter:false}"><input type="checkbox" onClick="checkAll(this.checked,'namespaceID')"/></th>
			<th >Name</th>
			<th >Description</th>
			<th >Created Date</th>
			<th >isDefault</th>			
			<th id="actions" class="{sorter:false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qNamespaces">
		<tr <cfif CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="namespaceID" id="namespaceID" value="#namespace_id#" />
			</td>
			<td>#name#</td>
			<td>#description#</td>
			<td>#printDate(createdDate)#</td>
			<td>#yesNoFormat(isDefault)#</td>

			<!--- Display Commands --->
			<td class="center">
				<!--- Namespace Viewer --->
				<a href="javascript:directoryDialog('#name#')" title="Open Namespace Viewer"><img src="includes/images/directory.png" border="0" alt="namespace viewer"/></a>
				
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehEdit & '/namespaceID/' & namespace_id)#" title="Edit Namespace"><img src="includes/images/page_edit.png" border="0" alt="edit" title="Edit Namespace"/></a>
				
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#namespace_id#')" title="Delete Namespace"><img id="delete_#namespace_id#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Namespace"/></a>
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