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
			confirm("Do you wish to remove the selected record(s)?<br/>This cannot be undone!", function(){deleteRecord(recordID)});
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- Title --->
<h2><img src="includes/images/user.png" align="absmiddle"> User Management</h2>
<p>From here you can manage and search for all the wiki users.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="searchFilterForm" id="searchFilterForm" method="POST" action="#event.buildLink(rc.xehUserListing)#">

	<div style="margin:10px;">
		<!--- Loader --->
		<div id="_loader" class="float-right formloader">
			<p>
				<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
		</div>

		<!--- Filter --->
		<label class="inline" for="search_criteria">Search</label>
		<input type="text" size="20" name="search_criteria" id="search_criteria" value="#rc.search_criteria#" title="First Name, Last Name and Email">

		<!--- Role --->
		<label class="inline" for="role_id">Role</label>
		<select name="role_id" id="role_id">
			<option value="0" <cfif rc.role_id eq rc.qRoles.roleid>selected="selected"</cfif>>All Roles</option>
			<cfloop query="rc.qRoles">
			<option value="#rc.qRoles.roleid#" <cfif rc.role_id eq rc.qRoles.roleid>selected="selected"</cfif>>#rc.qRoles.role#</option>
			</cfloop>
		</select>

		<!--- Active --->
		&nbsp;
		<label class="inline" for="active">Active</label>
		<select name="active" id="active">
			<option value="1" <cfif rc.active>selected="selected"</cfif>>True</option>
			<option value="0" <cfif not rc.active>selected="selected"</cfif>>False</option>
		</select>
		<!--- Confirmed --->
		&nbsp;
		<label class="inline" for="active">Confirmed</label>
		<select name="confirmed" id="confirmed">
			<option value="-1" <cfif rc.confirmed eq -1>selected="selected"</cfif>>All</option>
			<option value="1" <cfif rc.confirmed eq 1>selected="selected"</cfif>>True</option>
			<option value="0" <cfif rc.confirmed eq 0>selected="selected"</cfif>>False</option>
		</select>

		<!--- Search Button --->
		<a href="javascript:searchForm()" class="buttonLinks" title="Search">
			<span>
				<img src="includes/images/magnifier.png" border="0" align="absmiddle" alt="Search">
			</span>
		</a>
		</p>
	</div>
</form>

<!--- Results Form --->
<form name="userForm" id="userForm" action="#event.buildLink(rc.xehUserDelete)#" method="post">
	
	<!--- Add / Delete --->
	<div class="buttons float-right">
		<a href="#event.buildLink(rc.xehUserCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" align="absmiddle" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" align="absmiddle" />
				Delete
			</span>
		</a>
	</div>
	
	<!--- Records Found --->
	<div>
		<p>
		<cfif rc.qusers.recordcount>
		<em>Records: #rc.boundaries.startrow# - #rc.qUsers.recordcount#</em>
		<cfelse>
		<em>No Records Found</em>
		</cfif>
		</p>
	</div>

	<!--- Paging --->
	#getMyPlugin("paging").renderit(FoundRows=rc.FoundRows,link=rc.pagingLink)#

	<!--- Render Results --->
	<table class="tablelisting" width="100%">

		<!--- Display Fields Found in Query --->
		<tr>
			<th style="width: 20px"></th>
			<th >
				<!--- Sort Indicator --->
				<cfif event.getValue("sortBy","") eq "user_lname">&##8226;</cfif>
				<a href="#event.buildLink(rc.xehUserListing & '/sort/user_lname/' & rc.sortOrder & '/' & rc.page)#">
				Name
				</a>
				<!--- Sort Orders --->
			   <cfif event.getValue("sortBy","") eq "user_lname">
			   		<cfif rc.sortOrder eq "ASC">&raquo;<cfelse>&laquo;</cfif>
			   </cfif>
			</th>
			<th >
				<!--- Sort Indicator --->
				<cfif event.getValue("sortBy","") eq "user_email">&##8226;</cfif>
				<a href="#event.buildLink(rc.xehUserListing & '/sort/user_email/' & rc.sortOrder & '/' & rc.page)#">
				Email
				</a>
				<!--- Sort Orders --->
			   <cfif event.getValue("sortBy","") eq "user_email">
			   		<cfif rc.sortOrder eq "ASC">&raquo;<cfelse>&laquo;</cfif>
			   </cfif>
			</th>
			<th class="center" width="95">
				<!--- Sort Indicator --->
				<cfif event.getValue("sortBy","") eq "user_isconfirmed">&##8226;</cfif>
				<a href="#event.buildLink(rc.xehUserListing & '/sort/user_isconfirmed/' & rc.sortOrder & '/' & rc.page)#">
				Confirmed
				</a>
				<!--- Sort Orders --->
			   <cfif event.getValue("sortBy","") eq "user_isconfirmed">
			   		<cfif rc.sortOrder eq "ASC">&raquo;<cfelse>&laquo;</cfif>
			   </cfif>
			</th>
			<th class="center" width="65">ACTIONS</th>
		</tr>

		<!--- Loop Through Query Results --->
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
				#getMyPlugin("avatar").renderAvatar(size:32)#
				<!--- Name --->
				#user_fname# #user_lname#
				<!--- Default Image --->
				<cfif user_isDefault><img src="includes/images/asterisk_orange.png" align="absmiddle"></cfif>
			</td>
			<td><a href="mailto:#user_email#">#user_email#<a/></td>
			<td class="center">#yesnoformat(user_isconfirmed)#</td>

			<!--- Display Commands --->
			<td class="center">
				<!--- Permissions Command --->
				<a href="#event.buildLink(rc.xehUserPerms & '/user_id/' & user_id)#" title="Edit User Permissions"><img src="includes/images/shield.png" border="0" align="absmiddle" title="Edit User Permissions"></a>
				<!--- Edit Command --->
				<a href="#event.buildlink(rc.xehUserEdit & '/user_id/' & user_id)#" title="Edit User"><img src="includes/images/page_edit.png" border="0" align="absmiddle" title="Edit User"></a>
				<cfif not user_isDefault>
				<!--- Delete Command --->
				<a href="javascript:confirmDelete('#user_id#')" title="Delete User"><img id="delete_#user_id#" src="includes/images/bin_closed.png" border="0" align="absmiddle" title="Delete Record"></a>
				</cfif>
			</td>

		</tr>
		</cfloop>
	</table>
	
	<p><img src="includes/images/asterisk_orange.png" align="absmiddle"> <strong>Default User</strong></p>

	<!--- Add / Delete --->
	<div class="buttons">
		<a href="#event.buildLink(rc.xehUserCreate)#" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" align="absmiddle" />
				Add
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
				<img src="includes/images/stop.png" border="0" align="absmiddle" />
				Delete
			</span>
		</a>
	</div>
	<br />


</form>

</cfoutput>