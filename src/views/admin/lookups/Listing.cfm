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
	function loadLookup(lookupClass){
		window.location='#event.buildLink(linkTo=rc.xehLookupList,override=true)#/lookupClass/' + lookupClass + '#event.getRewriteExtension()#';
	}
	function submitForm(){
		$('##_listloader').fadeIn();
		$('##lookupForm').submit();
	}
	function deleteRecord(recordID){
		if( recordID != null ){
			$('##delete_'+recordID).attr('src','#rc.imgPath#/ajax-spinner.gif');
			$("input[@name='lookupid']").each(function(){
				if( this.value == recordID ){ this.checked = true;}
				else{ this.checked = false; }
			});
		}
		//Submit Form
		submitForm();
	}
	function confirmDelete(recordID){
		if ( confirm("Do you wish to remove the selected record(s)? This cannot be undone!") ){
			deleteRecord(recordID);
		} 
	}
	$(document).ready(function() {
		// call the tablesorter plugin
		$("##lookupTable").tablesorter();
		$("##filter").keyup(function(){
			$.uiTableFilter( $("##lookupTable"), this.value );
		})
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<div id="content">
<!--- Title --->
<h2><img src="#rc.imgPath#/cog.png" alt="manager"/> System Lookup Manager</h2>
<p>From here you can manage all the lookup tables in the system as defined in your coldbox.xml (lookups_tables)</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form>
	<!--- Loader --->
	<div id="_listloader" class="formloader">
		<p> Submitting...<br />
			<img src="#rc.imgPath#/ajax-loader-horizontal.gif" alt="loader"/>
			<img src="#rc.imgPath#/ajax-loader-horizontal.gif" alt="loader"/>
		</p>
	</div>

	<!--- Table To Manage --->
	<p>
		<strong>Table to manage:</strong>
		<select name="lookupClass" id="lookupClass" onChange="loadLookup(this.value)">
			<cfloop from="1" to="#ArrayLen(rc.SystemLookupsKeys)#" index="i">
				<option value="#rc.systemLookups[rc.SystemLookupsKeys[i]]#" <cfif rc.lookupClass eq rc.systemLookups[rc.SystemLookupsKeys[i]]>selected</cfif>>#rc.SystemLookupsKeys[i]#</option>
			</cfloop>
		</select>		
		<!--- Utility Buttons --->
		&nbsp;
		<a href="#event.buildLink(linkTo=rc.xehLookupList & "/lookupClass/" & rc.lookupclass,translate=false)#" class="buttonLinks">
			<span>
				<img src="#rc.imgPath#/arrow_refresh.png" border="0" alt="refresh" />
				Reload Listing
			</span>
		</a>
		&nbsp;
		<a href="#event.buildLink(rc.xehLookupClean)#" class="buttonLinks">
			<span>
			<img src="#rc.imgPath#/book_open.png" border="0" alt="reload" />
			Reload Dictionary
			</span>
		</a>
	</p>
</form>

<!--- Results Form --->
<div>
	<form name="lookupForm" id="lookupForm" action="#event.buildLink(rc.xehLookupDelete)#" method="post">
	<!--- The lookup class selected for deletion purposes --->
	<input type="hidden" name="lookupclass" id="lookupclass" value="#rc.lookupClass#">

	<!--- Add / Delete Button Bar --->
	<div id="listButtonBar">
		<a href="#event.buildLink(linkTo=rc.xehLookupCreate & "/lookupclass/" & rc.lookupclass,translate=false)#" class="buttonLinks">
			<span>
				<img src="#rc.imgPath#/add.png" border="0" alt="add"/>
				Add Record
			</span>
		</a>
		&nbsp;
		<a href="javascript:confirmDelete()" class="buttonLinks">
			<span>
			<img src="#rc.imgPath#/stop.png" border="0" alt="remove" />
			Delete Record(s)
			</span>
		</a>
	</div>
	
	<!--- Records Found --->
	<div id="recordsfound">
		<em>Records Found: #rc.qListing.recordcount#</em>
		<br />
		<label class="inlineLabel">Table Filter: </label>
		<input type="text" size="30" id="filter" value="">
	</div>

	<!--- Render Results --->
	<cfif rc.qListing.recordcount>
	<table class="tablesorter" width="100%" id="lookupTable" cellspacing="1" cellpadding="0" border="0">
		<thead>
		<!--- Display Fields Found in Query --->
		<tr>
			<th id="checkboxHolder" class="{sorter: false}"></th>
			<!--- All Other Fields --->
			<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
				<!---Don't show display eq false --->
				<cfif rc.mdDictionary.FieldsArray[i].display and not rc.mdDictionary.FieldsArray[i].primaryKey>
					<th>#rc.mdDictionary.FieldsArray[i].alias#</th>
				</cfif>
			</cfloop>
			<th id="actions" class="{sorter: false}">ACTIONS</th>
		</tr>
		</thead>
		
		<tbody>
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
				<cfif rc.mdDictionary.FieldsArray[i].display and not rc.mdDictionary.FieldsArray[i].primaryKey>
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
				<!--- Edit Record --->
				<a href="#event.buildLink(linkTo=rc.xehLookupEdit & '/lookupClass',override=true)#/#rc.lookupClass#/id/#rc.qListing[rc.mdDictionary.PK][currentrow]##event.getRewriteExtension()#" title="Edit Record">
				<img src="#rc.imgPath#/page_edit.png" border="0" alt="edit" title="Edit Record"/>
				</a>
				<!--- Delete Record --->
				<a href="javascript:confirmDelete('#rc.qListing[rc.mdDictionary.PK][currentrow]#')" title="Edit Record">
				<img id="delete_#rc.qListing[rc.mdDictionary.PK][currentrow]#" src="#rc.imgPath#/bin_closed.png" border="0" alt="remove" title="Edit Record"/>
				</a>
			</td>

		</tr>
		</cfloop>
		</tbody>
	</table>
	</cfif>

	<div id="formFinalizer"></div>
	</form>
</div><!--- End Form --->
</div><!--- End Content --->
</cfoutput>