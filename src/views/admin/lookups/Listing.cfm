<cfoutput>
<cfsetting showdebugoutput="false">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function loadLookup(lookupClass){
			window.location='#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupClass=' + lookupClass;
		}
		function submitForm(){
			$('##lookupForm').submit();
		}
		function confirmDelete(){
			if( confirm("Do you wish to remove the selected record(s)?") ){
				return submitForm();
			}
			else
				return false;
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<h2>System Lookup Manager - #rc.lookupClass#</h2>
<p>From here you can manage all the lookup tables in the system.</p>

<!--- Table Manager Jumper --->
<form>
	<p><strong>Choose a table to manage:</strong>
	<select name="lookupClass" id="lookupClass" onChange="loadLookup(this.value)">
		<cfloop from="1" to="#ArrayLen(rc.SystemLookupsKeys)#" index="i">
			<option value="#rc.systemLookups[rc.SystemLookupsKeys[i]]#" <cfif rc.lookupClass eq rc.systemLookups[rc.SystemLookupsKeys[i]]>selected</cfif>>#rc.SystemLookupsKeys[i]#</option>
		</cfloop>
	</select>
	</p>
</form>



<!--- Results Form --->
<div>
	<form name="lookupForm" id="lookupForm" action="#getSetting('sesBaseURL')#/#rc.xehLookupDelete#" method="post">
	<!--- The lookup class selected for deletion purposes --->
	<input type="hidden" name="lookupclass" id="lookupclass" value="#rc.lookupClass#">
	
	<!--- Add / Delete --->
	<p class="buttons align-right">
		<a href="#getSetting('sesBaseURL')#/#rc.xehLookupCreate#?lookupClass=#rc.lookupClass#')" id="buttonLinks">
			<span>Add Record</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" id="buttonLinks">
			<span>Delete Record(s)</span>
		</a>
	</p>
	
	<!--- Records Found --->
	<div style="margin-top: 12px">
		<p>
		<em>Records Found: #rc.qListing.recordcount#</em>
		</p>
	</div>
	
	<cfif rc.qListing.recordcount>
	<!--- Render Results --->
	<table class="tablelisting" width="100%">
	
		<!--- Display Fields Found in Query --->
		<tr>
			<th style="width: 20px"></th>
	
			<!--- All Other Fields --->
			<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
				<!---Don't show display eq false --->
				<cfif rc.mdDictionary.FieldsArray[i].display>
					<th>
					<!--- Sort Indicator --->
					<cfif event.getValue("sortBy","") eq rc.mdDictionary.FieldsArray[i].alias>&##8226;</cfif>
	
					<!--- Sort Column --->
					<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupClass=#rc.lookupClass#&sortby=#rc.mdDictionary.FieldsArray[i].alias#&sortOrder=#rc.sortOrder#">
						#rc.mdDictionary.FieldsArray[i].alias#
					   </a>
					   <!--- Sort Orders --->
					   <cfif event.getValue("sortBy","") eq rc.mdDictionary.FieldsArray[i].alias>
					   		<cfif rc.sortOrder eq "ASC">&raquo;<cfelse>&laquo;</cfif>
					   </cfif>
					</th>
				</cfif>
			</cfloop>
			<th align="center" width="60">CMDS</th>
		</tr>
	
		<!--- Loop Through Query Results --->
		<cfloop query="rc.qListing">
		<tr <cfif rc.qListing.CurrentRow MOD(2) eq 1> class="even"</cfif>>
			<!--- Delete Checkbox with PK--->
			<td>
				<input type="checkbox" name="lookupid" id="lookupid" value="#rc.qListing[rc.mdDictionary.PK][currentrow]#" />
			</td>
	
			<!--- Loop Through Columns --->
			<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
				<!---Don't show display eq false --->
				<cfif rc.mdDictionary.FieldsArray[i].display>
				<td>
					<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
						#yesnoFormat(rc.qListing[rc.mdDictionary.FieldsArray[i].Alias][currentrow])#
					<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
						#dateFormat(rc.qListing[rc.mdDictionary.FieldsArray[i].Alias][currentrow],"MMM-DD-YYYY")#
					<cfelse>
						#rc.qListing[rc.mdDictionary.FieldsArray[i].Alias][currentrow]#
					</cfif>
				</td>
				</cfif>
			</cfloop>
	
			<!--- Display Edit Command --->
			<td align="center">
				<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupClass=#rc.lookupClass#&id=#rc.qListing[rc.mdDictionary.PK][currentrow]#" title="Edit Record">
				<img src="#getSetting('sesBaseURL')#/includes/images/page_edit.png" border="0" align="absmiddle" title="Edit Record">
				</a>
				
				<a href="" title="Edit Record">
				<img src="#getSetting('sesBaseURL')#/includes/images/bin_closed.png" border="0" align="absmiddle" title="Edit Record">
				</a>
			</td>
	
		</tr>
		</cfloop>
	</table>
	</cfif>
	</form>
</div>
</cfoutput>