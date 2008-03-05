<cfoutput>
<cfsetting showdebugoutput="false">
<script language="javascript">
window.addEvent('domready', function(){
	widgInit();
});
</script>


<!--- Collection Reference --->

<h3>Lookup Manager - Edit Record</h3>
<p>Editing <strong>#rc.lookup#</strong> Record. Please fill out all the fields.</p>

<!--- Add Form --->
<form name="addform" id="addform" class="validated">
<!--- Lookup Class Choosen to Add --->
<input type="hidden" name="lookup" id="lookup" value="#rc.lookup#">
<!--- Primary Key Value --->
<input type="hidden" name="ID" value="#rc.pkValue#">

<fieldset>
<div id="lookupFields">
	<!--- Loop Through Foreign Keys, to create Drop Downs --->
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.ManyToOneArray)#" index="i">
		<cfset qListing = rc["q#rc.mdDictionary.ManyToOneArray[i].alias#"]>
		<cfset tmpValue = evaluate("rc.oLookup.get#rc.mdDictionary.ManyToOneArray[i].alias#().get#rc.mdDictionary.ManyToOneArray[i].PK#()")>
		<label style="width: 180px">#rc.mdDictionary.ManyToOneArray[i].alias#</label>

		<select name="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" id="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" class="required">
			<cfloop query="qListing">
			<option value="#qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow]#" <cfif qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow] eq tmpValue>selected</cfif>>#qListing[rc.mdDictionary.ManyToOneArray[i].DisplayColumn][currentRow]#</option>
			</cfloop>
		</select>
		<br/>
	</cfloop>

	<!--- Loop through Fields --->
	<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
		<!--- Set value --->
		<cfset tmpValue = evaluate("rc.oLookup.get#rc.mdDictionary.FieldsArray[i].alias#()")>
		<!--- Do not show the ignore Updates and PK--->
		<cfif not rc.mdDictionary.FieldsArray[i].primaryKey and not rc.mdDictionary.FieldsArray[i].ignoreUpdate>
			<!--- Set required property --->
			<cfif rc.mdDictionary.FieldsArray[i].nullable>
				<cfset reqClass = "">
			<cfelse>
				<cfset reqClass = "required">
			</cfif>
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#:</label>

			<!---Property Types --->
			<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
				<cfif rc.mdDictionary.FieldsArray[i].html eq "radio">
					<input type="radio" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="1" class="#reqClass#"  <cfif tmpValue>checked</cfif> />
					<label class="onRight" for="#rc.mdDictionary.FieldsArray[i].alias#">Yes</label>
					<input type="radio" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="0" class="#reqClass#"  <cfif not tmpValue>checked</cfif> />
					<label class="onRight" for="#rc.mdDictionary.FieldsArray[i].alias#">No</label>
				<cfelse>
					<select name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#">
						<option value="1" <cfif tmpValue>selected</cfif>>True</option>
						<option value="0" <cfif not tmpValue>selected</cfif>>False</option>
					</select>
				</cfif>
			<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
				<input type="text" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="#dateFormat(tmpValue, "MM/DD/YYYY")#" size="20" class="pickadate #reqClass#">
			<cfelse>
				<cfif rc.mdDictionary.FieldsArray[i].html eq "text">
					<input type="text" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="#tmpValue#" size="30" class="#reqClass# text">
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "textarea">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" rows="10" cols="65">#tmpValue#</textarea>
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "richtext">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" rows="20" cols="85" class="widgEditor">#tmpValue#</textarea>
				</cfif>
			</cfif>
			<br />
		<cfelse>
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#:</label>
			<label class="onRight">#htmlEditFormat(tmpValue)#</label>
			<br/>
		</cfif>
	</cfloop>
</div>
</fieldset>
<div class="buttonBar">
	<span id="msg"></span>
	<a href="javascript: validate.lookupUpdate()">update record</a>
	<a href="javascript: tabMan.go('tabContent','lookups.dspLookups&lookup=#rc.lookup#');">cancel</a>
</div>
</form>

<!--- ************************************************************************************** --->
<!--- ************************************************************************************** --->

<cfif rc.mdDictionary.hasManyToMany>
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.manytomanyarray)#" index="relIndex">
	<!--- Working MD M2M Array --->
	<cfset thisArray = rc.mdDictionary.manytomanyarray[relIndex]>
	<!--- Current M2M Listing Query --->
	<cfset qListing = rc["q#thisArray.alias#"]>
	<!--- Relation Array --->
	<cfset relationArray = rc["#thisArray.alias#Array"]>

	<!--- Display Relation Form --->
	<!--- action="?event=lookups.doUpdateRelation" method="post" --->
	<form name="add#thisArray.alias#Form" id="add#thisArray.alias#Form" class="validated">
		<!--- Lookup Class Choosen to Add --->
		<input type="hidden" name="lookup" id="lookup" value="#rc.lookup#">
		<!--- Primary Key Value --->
		<input type="hidden" name="ID" value="#rc.pkValue#">
		<!--- Alias Name --->
		<input type="hidden" name="linkAlias" value="#thisArray.alias#">
		<input type="hidden" name="linkTO"    value="#thisArray.linkToTO#">
		<input type="hidden" name="addRelation" id="addRelation" value="0">
		
		<fieldset>
			<legend>#thisArray.alias# Relation</legend>
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
	</form>
	</cfloop>
</cfif>

<script language="javascript">
	findDates();
</script>

</cfoutput>