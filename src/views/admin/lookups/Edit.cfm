<cfoutput>
<cfsetting showdebugoutput="false">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function submitForm(){
			if( _CF_checkaddform(document.getElementById('addform')) ){
				$('##_buttonbar').slideUp("fast");
				$('##_loader').fadeIn("slow");
				$('##addform').submit();
			}
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- Title --->
<h2>System Lookup Manager - Edit Record</h2>

<p>Editing <strong>#rc.lookupClass#</strong> Record. Please fill out all the fields.</p>

<!--- Add Form --->
<cfform name="addform" id="addform" action="#getSetting('sesBaseURL')#/#rc.xehLookupCreate#">

<!--- Lookup Class Choosen to Add --->
<input type="hidden" name="lookupClass" id="lookupClass" value="#rc.lookupClass#">
<!--- Primary Key Value --->
<input type="hidden" name="ID" value="#rc.pkValue#">

<fieldset>
	<legend><strong>Create Form</strong></legend>
<div id="lookupFields">
	
	<!--- Loop Through Foreign Keys, to create Drop Downs --->
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.ManyToOneArray)#" index="i">
		<cfset qListing = rc["q#rc.mdDictionary.ManyToOneArray[i].alias#"]>
		<cfset tmpValue = evaluate("rc.oLookup.get#rc.mdDictionary.ManyToOneArray[i].alias#().get#rc.mdDictionary.ManyToOneArray[i].PK#()")>
		<label style="width: 180px">#rc.mdDictionary.ManyToOneArray[i].alias#</label>

		<cfselect name="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" 
				  id="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" 
				  required="true"
				  message="#rc.mdDictionary.ManyToOneArray[i].alias# is required">
			<cfloop query="qListing">
			<option value="#qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow]#" <cfif qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow] eq tmpValue>selected</cfif>>#qListing[rc.mdDictionary.ManyToOneArray[i].DisplayColumn][currentRow]#</option>
			</cfloop>
		</cfselect>
		<br/>
	</cfloop>

	<!--- Loop through Fields --->
	<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
		<!--- Set value --->
		<cfset tmpValue = evaluate("rc.oLookup.get#rc.mdDictionary.FieldsArray[i].alias#()")>
		<!--- Do not show the ignore Updates and PK--->
		<cfif not rc.mdDictionary.FieldsArray[i].primaryKey and not rc.mdDictionary.FieldsArray[i].ignoreUpdate>
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#:</label>

			<!--- BOOLEAN TYPES --->
			<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
				<cfif rc.mdDictionary.FieldsArray[i].html eq "radio">
					<cfinput type="radio" 
							 name="#rc.mdDictionary.FieldsArray[i].alias#" 
							 id="#rc.mdDictionary.FieldsArray[i].alias#" 
							 value="1"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 checked="#tmpValue#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
					<label class="inline" for="#rc.mdDictionary.FieldsArray[i].alias#">Yes</label>
					
					<cfinput type="radio" 
							 name="#rc.mdDictionary.FieldsArray[i].alias#" 
							 id="#rc.mdDictionary.FieldsArray[i].alias#" 
							 value="0"
							 checked="#not tmpValue#"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
					<label class="inline" for="#rc.mdDictionary.FieldsArray[i].alias#">No</label>
				<cfelse>
					<cfselect name="#rc.mdDictionary.FieldsArray[i].alias#" 
							  id="#rc.mdDictionary.FieldsArray[i].alias#"
							  required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							  message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
						<option value="1" <cfif tmpValue>selected="selected"</cfif>>True</option>
						<option value="0" <cfif not tmpValue>selected="selected"</cfif>>False</option>
					</cfselect>
				</cfif>
			<!--- DATE TYPE --->
			<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
				<cfinput type="datefield" 
						 name="#rc.mdDictionary.FieldsArray[i].alias#" 
						 id="#rc.mdDictionary.FieldsArray[i].alias#" 
						 value="#dateFormat(tmpValue, "MM/DD/YYYY")#" 
						 size="10"
						 validate="date"
						 validateat="onBlur"
						 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
						 required="#not rc.mdDictionary.FieldsArray[i].nullable#">
				  <br />
			<cfelse>
				<cfif rc.mdDictionary.FieldsArray[i].html eq "text">
					<cfinput type="text" 
							 name="#rc.mdDictionary.FieldsArray[i].alias#" 
							 id="#rc.mdDictionary.FieldsArray[i].alias#" 
							 value="#tmpValue#" 
							 size="40"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "textarea">
					<cftextarea name="#rc.mdDictionary.FieldsArray[i].alias#" 
								id="#rc.mdDictionary.FieldsArray[i].alias#" 
								rows="10"
								message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
								required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 	>#tmpValue#</cftextarea>
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "richtext">
					<cftextarea name="#rc.mdDictionary.FieldsArray[i].alias#" 
								id="#rc.mdDictionary.FieldsArray[i].alias#" 
								richtext="true" 
								toolbar="Basic"
								message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
								required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 	style="background-color: white">#tmpValue#</cftextarea>
				</cfif>
			</cfif>
			<br />
		<cfelse>
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#:</label>
			<label class="red">#htmlEditFormat(tmpValue)#</label>
		</cfif>
	</cfloop>
</div>
</fieldset>
<br />
<!--- Loader --->
<div id="_loader" class="align-center hidden" style="margin:5px 5px 0px 0px;">
	<p class="bold red">
		Submitting...<br />
		
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
	</p>
	<br />
</div>

<!--- Create / Cancel --->
<div id="_buttonbar" class="buttons align-center" style="margin-top:8px;">
	<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/cancel.png" border="0" align="absmiddle">
			Cancel
		</span>
	</a>
	&nbsp;
	<a href="javascript:submitForm()" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/add.png" border="0" align="absmiddle">
			Update Record
		</span>
	</a>	
</div>
<br />
</cfform>

<!--- ************************************************************************************** --->
<!--- ************************************************************************************** --->
<!--- Many To Many Relations --->
<cfif rc.mdDictionary.hasManyToMany>
	<!--- Title --->
	<h3>Many to Many Manager(s)</h3>

	<cfloop from="1" to="#arrayLen(rc.mdDictionary.manytomanyarray)#" index="relIndex">
	<!--- Working MD M2M Array --->
	<cfset thisArray = rc.mdDictionary.manytomanyarray[relIndex]>
	<!--- Current M2M Listing Query --->
	<cfset qListing = rc["q#thisArray.alias#"]>
	<!--- Relation Array --->
	<cfset relationArray = rc["#thisArray.alias#Array"]>

	<!--- Display Relation Form --->
	<!--- action="?event=lookups.doUpdateRelation" method="post" --->
	<cfform name="add#thisArray.alias#Form" id="add#thisArray.alias#Form">
		<!--- Lookup Class Choosen to Add --->
		<input type="hidden" name="lookupClass" id="lookupClass" value="#rc.lookupClass#">
		<!--- Primary Key Value --->
		<input type="hidden" name="ID" value="#rc.pkValue#">
		<!--- Alias Name --->
		<input type="hidden" name="linkAlias" value="#thisArray.alias#">
		<input type="hidden" name="linkTO"    value="#thisArray.linkToTO#">
		<input type="hidden" name="addRelation" id="addRelation" value="0">
		
		<fieldset>
			<legend><strong>#thisArray.alias# Relation</strong></legend>
				
				<cfif arraylen(relationArray)>
					<cfloop from="1" to="#arrayLen(relationArray)#" index="i">
						<input type="checkbox" name="m2m_#thisArray.alias#_id" id="m2m_#thisArray.alias#_id" value="#relationArray[i][thisArray.linkToPK]#" />
						<label class="onRight" for="m2m_#thisArray.alias#_id">#relationArray[i][thisArray.linkToSortBy]#</label><br/>
					</cfloop>
				<cfelse>
					<p><em>No #thisArray.alias# relation records found.</em></p>
				</cfif>			
		
			<!--- M2M Listing --->
			<select name="m2m_#thisArray.alias#" id="m2m_#thisArray.alias#" class="required">
				<cfloop query="qListing">
				<option value="#qListing[thisArray.linkToPK][currentrow]#">#qListing[thisArray.linkToSortBy][currentrow]#</option>
				</cfloop>
			</select>
			
			<input type="button" 
				class="button" 
				value="add selected relation" 
				onclick="validate.lookupUpdateRelation(add#thisArray.alias#Form, 1)"
				<cfif not qListing.recordcount>disabled="disabled"</cfif>
			/>

			<input type="button" 
				class="button" 
				onclick="validate.lookupUpdateRelation(add#thisArray.alias#Form, 0)" 
				value="remove checked relation(s)" 
			/>
		</fieldset>
	</cfform>
	</cfloop>
</cfif>

</cfoutput>