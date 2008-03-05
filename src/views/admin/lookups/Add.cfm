<cfoutput>
<cfsetting showdebugoutput="false">
<script language="javascript">
window.addEvent('domready', function(){
	widgInit();
});
</script>

<!--- Collection Reference --->


<h3>lookup manager - add record</h3>

<!--- Add Form --->

<p>Add a new <strong>#rc.lookup#</strong> record. Please fill out all the fields.</p>
<!-- <form name="addform" id="addform" action="?event=lookups.doCreate" method="post" > -->
<form name="addform" id="addform" class="validated">
	<!--- Lookup Class Choosen to Add --->
	<input type="hidden" name="lookup" id="lookup" value="#rc.lookup#">
	
<fieldset>
<div id="lookupFields">
	<!--- Loop Through Foreign Keys, to create Drop Downs --->
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.ManyToOneArray)#" index="i">
	<cfset qListing = rc["q#rc.mdDictionary.ManyToOneArray[i].alias#"]>
		<label style="width: 180px">#rc.mdDictionary.ManyToOneArray[i].alias#</label>
		<select name="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" id="fk_#rc.mdDictionary.ManyToOneArray[i].alias#" class="required">
			<cfloop query="qListing">
			<option value="#qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow]#">#qListing[rc.mdDictionary.ManyToOneArray[i].DisplayColumn][currentRow]#</option>
			</cfloop>
		</select>
		<br/>
	</cfloop>

	<!--- Loop through Fields --->
	<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
		<!--- Do not show the ignore Inserts or PK --->
		<cfif not rc.mdDictionary.FieldsArray[i].primaryKey and not rc.mdDictionary.FieldsArray[i].ignoreInsert>
			<!--- Set required property --->
			<cfif rc.mdDictionary.FieldsArray[i].nullable>
				<cfset reqClass = "">
			<cfelse>
				<cfset reqClass = "required">
			</cfif>
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#</label>

				<!---Property Types --->
				<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
					<cfif rc.mdDictionary.FieldsArray[i].html eq "radio">
						<input type="radio" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="1" class="#reqClass#" checked>
						<label class="onRight" for="#rc.mdDictionary.FieldsArray[i].alias#">Yes</label>
						<input type="radio" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="0" class="#reqClass#">
						<label class="onRight" for="#rc.mdDictionary.FieldsArray[i].alias#">No</label>
					<cfelse>
						<select name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#">
							<option value="1">True</option>
							<option value="0">False</option>
						</select>
					</cfif>
				<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
					<input type="text" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="" size="20" class="datepicker #reqClass#">
				<cfelse>
					<cfif rc.mdDictionary.FieldsArray[i].html eq "text">
					<input type="text" name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" value="" size="30" class="#reqClass# text">
					<cfelseif rc.mdDictionary.FieldsArray[i].html eq "textarea">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" rows="10" cols="65"></textarea>
					<cfelseif rc.mdDictionary.FieldsArray[i].html eq "richtext">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#" id="#rc.mdDictionary.FieldsArray[i].alias#" rows="10" cols="65" class="widgEditor">Type your template hither.</textarea>
					</cfif>
				</cfif>
				<br/>
		</cfif>
	</cfloop>
</div>
</fieldset>
	<!--- Create Button --->
	<div class="buttonBar">
		<span id="msg"></span>
		<a href="javascript: validate.lookupAdd()">create record</a>
		<a href="javascript: tabMan.go('tabContent','lookups.dspLookups&lookup=#rc.lookup#');">cancel</a>
	</div>
</form>
</cfoutput>