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
<cfsetting showdebugoutput="false">
<div id="content">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function loadLookup(lookupClass){
			window.location='#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupClass=' + lookupClass;
		}
		function submitForm(){
			$('##_loader').fadeIn();
			$('##lookupForm').submit();
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
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/cog.png" align="absmiddle"> System Lookup Manager</h2>
<p>From here you can manage all the lookup tables in the system.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form>

	<div id="_loader" class="float-right formloader">
		<p>
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<p><strong>Choose a table to manage:</strong>
	<select name="lookupClass" id="lookupClass" onChange="loadLookup(this.value)">
		<cfloop from="1" to="#ArrayLen(rc.SystemLookupsKeys)#" index="i">
			<option value="#rc.systemLookups[rc.SystemLookupsKeys[i]]#" <cfif rc.lookupClass eq rc.systemLookups[rc.SystemLookupsKeys[i]]>selected</cfif>>#rc.SystemLookupsKeys[i]#</option>
		</cfloop>
	</select>
	<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupclass=#rc.lookupclass#" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/arrow_refresh.png" border="0" align="absmiddle">
			Reload Listing
		</span>
	</a>
	&nbsp;
	<a href="#getSetting('sesBaseURL')#/#rc.xehLookupClean#" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/arrow_refresh.png" border="0" align="absmiddle">
			Reload Dictionary
		</span>
	</a>
	</p>
</form>

<!--- Results Form --->
<div>
	<form name="lookupForm" id="lookupForm" action="#getSetting('sesBaseURL')#/#rc.xehLookupDelete#" method="post">
	<!--- The lookup class selected for deletion purposes --->
	<input type="hidden" name="lookupclass" id="lookupclass" value="#rc.lookupClass#">

	<!--- Add / Delete --->
	<div class="buttons float-right" style="margin-top:12px;">
		<a href="#getSetting('sesBaseURL')#/#rc.xehLookupCreate#?lookupClass=#rc.lookupClass#" id="buttonLinks">
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
		<em>Records Found: #rc.qListing.recordcount#</em>
		</p>
	</div>

	<cfif rc.qListing.recordcount>
	<br />
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
			<th align="center" width="60">ACTIONS</th>
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

			<!--- Display Commands --->
			<td align="center">
				<a href="#getSetting('sesBaseURL')#/#rc.xehLookupEdit#?lookupClass=#rc.lookupClass#&id=#rc.qListing[rc.mdDictionary.PK][currentrow]#" title="Edit Record">
				<img src="#getSetting('sesBaseURL')#/includes/images/page_edit.png" border="0" align="absmiddle" title="Edit Record">
				</a>

				<a href="javascript:confirmDelete('#rc.qListing[rc.mdDictionary.PK][currentrow]#')" title="Edit Record">
				<img id="delete_#rc.qListing[rc.mdDictionary.PK][currentrow]#" src="#getSetting('sesBaseURL')#/includes/images/bin_closed.png" border="0" align="absmiddle" title="Edit Record">
				</a>
			</td>

		</tr>
		</cfloop>
	</table>
	</cfif>

	<div  style="margin-top:20px"></div>
	</form>
</div>
</div>
</cfoutput>