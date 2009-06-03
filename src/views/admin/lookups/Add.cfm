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
	$(document).ready(function() {
		/* Activate RTE */
		$('.rte-zone').rte("#getSetting('lookups_cssPath')#/lookups.css","#rc.imgPath#/rte/");  
		 
		//Activate Date Pickers
		$(".datepicker").datepicker({ 
		    showOn: "both"
		});
		
		/* Form Validation */
		$('##addform').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			callback	: 'prepareSubmit'
		});
	});
	function submitForm(){
		$('##addform').submit();		
	}
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");		
		return true;
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- Title --->
<h2><img src="#rc.imgPath#/cog.png" alt="add" /> System Lookup Manager > Add Record</h2>
<!--- BACK --->
<div class="backbutton">
	<img src="#rc.imgPath#/arrow_left.png" alt="back"/>
	<a href="#event.buildLink(linkTo=rc.xehLookupList & '/lookupclass/' & rc.lookupclass,translate=false)#">Back</a>
</div>
<p>Add a new <strong>#rc.lookupClass#</strong>. Please fill out all the fields.</p>

<!--- Add Form --->
<form name="addform" id="addform" action="#event.buildLink(rc.xehLookupCreate)#" method="post">
<!--- Lookup Class Choosen to Add --->
<input type="hidden" name="lookupClass" id="lookupClass" value="#rc.lookupClass#">

<fieldset>
<legend><strong>Create Form</strong></legend>

<div id="lookupFields">
	
	<!--- Loop Through Foreign Keys, to create Drop Downs --->
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.ManyToOneArray)#" index="i">
	<cfset qListing = rc["q#rc.mdDictionary.ManyToOneArray[i].alias#"]>
		<label class="labelNormal">#rc.mdDictionary.ManyToOneArray[i].alias#</label>
		<select name="fk_#rc.mdDictionary.ManyToOneArray[i].alias#"
				id="fk_#rc.mdDictionary.ManyToOneArray[i].alias#"
				required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#">
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
			<!--- PROPERTY LABEL --->
			<label class="labelNormal">
				#rc.mdDictionary.FieldsArray[i].alias#
				<cfif not rc.mdDictionary.FieldsArray[i].nullable>*</cfif>
			</label>
			<!--- Help Text --->
			<label class="helptext">#rc.mdDictionary.FieldsArray[i].helptext#</label>
			
			<!--- BOOLEAN TYPES --->
			<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
				<cfif rc.mdDictionary.FieldsArray[i].html eq "radio">
					<input type="radio"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value="1"
							 checked="true"
							 required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#">
					<label class="rbLabel" for="#rc.mdDictionary.FieldsArray[i].alias#">Yes</label>

					<input type="radio"
						   name="#rc.mdDictionary.FieldsArray[i].alias#"
						   id="#rc.mdDictionary.FieldsArray[i].alias#"
						   value="0"
						   required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#">
					<label class="rbLabel" for="#rc.mdDictionary.FieldsArray[i].alias#">No</label>
				<cfelse>
					<select name="#rc.mdDictionary.FieldsArray[i].alias#"
							id="#rc.mdDictionary.FieldsArray[i].alias#"
							required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#"
							class="booleanSelect">
						<option value="1">True</option>
						<option value="0">False</option>
					</select>
				</cfif>
			<!--- DATE TYPE --->
			<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
				<input type="text" size="20" value="" 
					   name="#rc.mdDictionary.FieldsArray[i].alias#"
					   id="#rc.mdDictionary.FieldsArray[i].alias#"
					   required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#"
					   class="datepicker"/> 
				<br />
			<!--- TEXTTYPES --->
			<cfelse>
				<cfif rc.mdDictionary.FieldsArray[i].html eq "text">
					<input type="text"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value=""
							 size="50"
							 required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#"
							 <cfif len(rc.mdDictionary.FieldsArray[i].validate)>
							 	mask="#rc.mdDictionary.FieldsArray[i].validate#"
							 </cfif>>
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "password">
					<input type="password"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value=""
							 size="50"
							 required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#">
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "textarea">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#"
								id="#rc.mdDictionary.FieldsArray[i].alias#"
								rows="10"
								required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#"
							 	></textarea>
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "richtext">
					<textarea name="#rc.mdDictionary.FieldsArray[i].alias#"
							  id="#rc.mdDictionary.FieldsArray[i].alias#"
							  rows="10"
							  class="rte-zone"
							  required="#iif(rc.mdDictionary.FieldsArray[i].nullable,false,true)#"
							  ></textarea>							 	
				</cfif>
			</cfif>
			<br/>
		</cfif>
	</cfloop>
</div>
</fieldset>

<!--- Mandatory Label --->
<p>* Mandatory Fields</p>
<br />

<!--- Hidden Loader --->
<div id="_loader" class="formloader">
	<p>
		Submitting...<br />
		<img src="#rc.imgPath#/ajax-loader-horizontal.gif" alt="loader" />
		<img src="#rc.imgPath#/ajax-loader-horizontal.gif" alt="loader" />
	</p>
</div>

<!--- Create / Cancel --->
<div id="_buttonbar">
	<a href="#event.buildLink(linkTo=rc.xehLookupList & '/lookupclass/' & rc.lookupclass,translate=false)#" class="buttonLinks">
		<span>
			<img src="#rc.imgPath#/cancel.png" border="0" alt="cancel" />
			Cancel
		</span>
	</a>
	&nbsp;
	<a href="javascript:submitForm()" class="buttonLinks">
		<span>
			<img src="#rc.imgPath#/add.png" border="0" alt="add" />
			Create Record
		</span>
	</a>
</div>
<br />
</form>
</cfoutput>