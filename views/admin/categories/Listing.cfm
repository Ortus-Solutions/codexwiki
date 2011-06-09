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
		$('##categoriesForm').submit();
	}
	function deleteRecord(recordID){
		if( recordID != null ){
			$('##delete_'+recordID).attr('src','includes/images/ajax-spinner.gif');
			$("input[@name='category_id']").each(function(){
				if( this.value == recordID ){ this.checked = true;}
				else{ this.checked = false; }
			});
		}
		//Submit Form
		submitForm();
	}
	function confirmDelete(recordID){
		confirm("Do you wish to remove the selected categorie(s)?<br/>This cannot be undone and ALL references to the category pages will be lost!",function(){deleteRecord(recordID)});
	}
	$(document).ready(function() {
		// call the tablesorter plugin
		$("##categoriesTable").tablesorter({
			sortList: [[1,0]]
		});
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h2><img src="includes/images/tag_blue.png" alt="Roles" /> Categories Management</h2>
<p>From here you can manage all the wiki categories.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Results Form --->
<form name="categoriesForm" id="categoriesForm" action="#event.buildLink(rc.xehDelete)#" method="post">
	
	<!--- Records Found --->
	<div class="float-left">
		<cfif rc.qCategories.recordcount>
		<em>Records Found: #rc.qCategories.recordcount#</em>
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
				<img src="includes/images/stop.png" border="0" alt="stop" />
				Delete
			</span>
		</a>
	</div>
	
	<!--- Render Results --->
	<table class="tablesorter" width="100%" id="categoriesTable" cellspacing="1" cellpadding="0" border="0">
	
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th id="checkboxHolder" class="{sorter:false}"><input type="checkbox" onClick="checkAll(this.checked,'category_id')"/></th>
			<th >Name</th>
			<th >Created Date</th>
			<th id="actions" class="{sorter:false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qCategories">
		<tr <cfif CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="category_id" id="category_id" value="#category_id#" />
			</td>
			<td>#name#</td>
			<td>#printDate(createdDate)#</td>

			<!--- Display Commands --->
			<td class="center">
				
				<!--- Open Category Page --->
				<a href="#event.buildLink(linkTo=pageShowRoot('Category:#name#'),translate=false)#" title="Goto Category Page"><img src="includes/images/house_link.png" border="0" title="Goto Category Page" alt="category" /></a>
				
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehEdit & '/category_id/' & category_id)#" title="Edit Category"><img src="includes/images/page_edit.png" border="0" alt="edit" title="Edit Category"></a>
				
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#category_id#')" title="Delete Category"><img id="delete_#category_id#" src="includes/images/bin_closed.png" border="0" alt="delete" title="Delete Category"></a>
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
				<img src="includes/images/stop.png" border="0" alt="stop" />
				Delete
			</span>
		</a>
	</div>
	<br />


</form>
</cfoutput>