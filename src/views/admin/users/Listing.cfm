<cfoutput>
<cfsetting showdebugoutput="false">
<div id="content">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function searchForm(){
			$('##_loader').fadeIn();
			$('##searchFilterForm').submit();
		}
		function deleteRecord(recordID){
			if( recordID != null ){
				$('##delete_'+recordID).attr('src','#getSetting('sesBaseURL')#/includes/images/ajax-spinner.gif');
				$("input[@name='lookupid']").each(function(){
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
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> User Management</h2>
<p>From here you can manage and search for all the wiki users.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="searchFilterForm" id="searchFilterForm" method="POST" action="#getSetting('sesBaseURL')#/#rc.xehUserListing#">
	
	<div style="margin:10px;">
		<!--- Loader --->
		<div id="_loader" class="float-right formloader">
			<p>
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
				<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			</p>
		</div>
		
		<!--- Filter --->
		<label class="inline" for="search_criteria">Search</label>
		<input type="text" name="search_criteria" id="search_criteria" value="#rc.search_criteria#" title="First Name, Last Name and Email">
		
		<!--- Role --->
		<label class="inline" for="role_id">User Role</label>
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
		
		
		<!--- Search Button --->
		<a href="javascript:searchForm()" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/magnifier.png" border="0" align="absmiddle">
				Search
			</span>
		</a>
		</p>
	</div>
</form>

<!--- Results Form --->
<form name="userForm" id="userForm" action="#getSetting('sesBaseURL')#/#rc.xehUserDelete#" method="post">
	
	<!--- Add / Delete --->
	<div class="buttons float-right" style="margin-top:12px;">
		<a href="#getSetting('sesBaseURL')#/" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/add.png" border="0" align="absmiddle">
				Add Record
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/stop.png" border="0" align="absmiddle">
				Delete Record(s)
			</span>
		</a>
	</div>
	
	<!--- Records Found --->
	<div style="margin-top: 12px">
		<p>
		<em>Records Found: #rc.qUsers.recordcount#</em>
		</p>
	</div>
	
	<br />
	<!--- Render Results --->
	<table class="tablelisting" width="100%">
	
		<!--- Display Fields Found in Query --->
		<tr>
			<th style="width: 20px"></th>
			<th >Name</th>
			<th >Email</th>
			<th align="center" width="60">Confirmed</th>
			<th align="center" width="60">ACTIONS</th>
		</tr>
	
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qUsers">
		<tr <cfif CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="user_id" id="user_id" value="#user_id#" />
			</td>
			<td>#user_fname# #user_lname#</td>
			<td>#user_email#</td>
			<td align="center">#yesnoformat(user_isconfirmed)#</td>
			
			<!--- Display Commands --->
			<td align="center">
				<a href="#getSetting('sesBaseURL')#/#rc.xehUserEdit#?" title="Edit User">
				<img src="#getSetting('sesBaseURL')#/includes/images/page_edit.png" border="0" align="absmiddle" title="Edit User">
				</a>
				
				<a href="javascript:confirmDelete('#user_id#')" title="Delete Record">
				<img id="delete_#user_id#" src="#getSetting('sesBaseURL')#/includes/images/bin_closed.png" border="0" align="absmiddle" title="Delete Record">
				</a>
			</td>
	
		</tr>
		</cfloop>
	</table>
	
</form>

</cfoutput>