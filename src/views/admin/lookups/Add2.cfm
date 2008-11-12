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

<!--- BACK --->
<div class="backbutton">
	<img src="#getSetting("htmlBaseURL")#/includes/images/arrow_left.png" align="absmiddle">
	<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupclass=#rc.lookupclass#">Back</a>
</div>

<!--- Title --->
<h2><img src="#getSetting('htmlBaseURL')#/includes/images/cog.png" align="absmiddle"> System Lookup Manager > Add Record</h2>

<!--- Add Form --->
<p>Add a new <strong>#rc.lookupClass#</strong> record. Please fill out all the fields.</p>

<cfform name="addform" id="addform" action="#getSetting('sesBaseURL')#/#rc.xehLookupCreate#">
<!--- Lookup Class Choosen to Add --->
<input type="hidden" name="lookupClass" id="lookupClass" value="#rc.lookupClass#">

<fieldset>
	<legend><strong>Create Form</strong></legend>
<div id="lookupFields">

	<!--- Loop Through Foreign Keys, to create Drop Downs --->
	<cfloop from="1" to="#arrayLen(rc.mdDictionary.ManyToOneArray)#" index="i">
	<cfset qListing = rc["q#rc.mdDictionary.ManyToOneArray[i].alias#"]>
		<label style="width: 180px">#rc.mdDictionary.ManyToOneArray[i].alias#</label>
		<cfselect name="fk_#rc.mdDictionary.ManyToOneArray[i].alias#"
				  id="fk_#rc.mdDictionary.ManyToOneArray[i].alias#"
				  required="true"
				  message="#rc.mdDictionary.ManyToOneArray[i].alias# is required">
			<cfloop query="qListing">
			<option value="#qListing[rc.mdDictionary.ManyToOneArray[i].PK][currentrow]#">#qListing[rc.mdDictionary.ManyToOneArray[i].DisplayColumn][currentRow]#</option>
			</cfloop>
		</cfselect>
		<br/>
	</cfloop>

	<!--- Loop through Fields --->
	<cfloop from="1" to="#ArrayLen(rc.mdDictionary.FieldsArray)#" index="i">
		<!--- Do not show the ignore Inserts or PK --->
		<cfif not rc.mdDictionary.FieldsArray[i].primaryKey and not rc.mdDictionary.FieldsArray[i].ignoreInsert>
			<!--- PROPERTY LABEL --->
			<label style="width: 180px">#rc.mdDictionary.FieldsArray[i].alias#</label>

			<!--- BOOLEAN TYPES --->
			<cfif rc.mdDictionary.FieldsArray[i].datatype eq "boolean">
				<cfif rc.mdDictionary.FieldsArray[i].html eq "radio">
					<cfinput type="radio"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value="1"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 checked="true"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
					<label class="inline" for="#rc.mdDictionary.FieldsArray[i].alias#">Yes</label>

					<cfinput type="radio"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value="0"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
					<label class="inline" for="#rc.mdDictionary.FieldsArray[i].alias#">No</label>
				<cfelse>
					<cfselect name="#rc.mdDictionary.FieldsArray[i].alias#"
							  id="#rc.mdDictionary.FieldsArray[i].alias#"
							  required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							  message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
						<option value="1">True</option>
						<option value="0">False</option>
					</cfselect>
				</cfif>
			<!--- DATE TYPE --->
			<cfelseif rc.mdDictionary.FieldsArray[i].datatype eq "date">
				<cfinput type="datefield"
						 name="#rc.mdDictionary.FieldsArray[i].alias#"
						 id="#rc.mdDictionary.FieldsArray[i].alias#"
						 value=""
						 size="20"
						 validate="date"
						 validateat="onBlur"
						 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
						 required="#not rc.mdDictionary.FieldsArray[i].nullable#">
				  <br />
			<!--- TEXTTYPES --->
			<cfelse>
				<cfif rc.mdDictionary.FieldsArray[i].html eq "text">
					<cfinput type="text"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value=""
							 size="40"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "password">
					<cfinput type="password"
							 name="#rc.mdDictionary.FieldsArray[i].alias#"
							 id="#rc.mdDictionary.FieldsArray[i].alias#"
							 value=""
							 size="40"
							 required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory">
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "textarea">
					<cftextarea name="#rc.mdDictionary.FieldsArray[i].alias#"
								id="#rc.mdDictionary.FieldsArray[i].alias#"
								rows="10"
								message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
								required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 	></cftextarea>
				<cfelseif rc.mdDictionary.FieldsArray[i].html eq "richtext">
					<cftextarea name="#rc.mdDictionary.FieldsArray[i].alias#"
								id="#rc.mdDictionary.FieldsArray[i].alias#"
								richtext="true"
								toolbar="Basic"
								message="#rc.mdDictionary.FieldsArray[i].alias# is mandatory"
								required="#not rc.mdDictionary.FieldsArray[i].nullable#"
							 	style="background-color: white"></cftextarea>
				</cfif>
			</cfif>
			<br/>
		</cfif>
	</cfloop>
</div>

</fieldset>
<br />

<div id="_loader" class="align-center formloader">
	<p>
		Submitting...<br />

		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
	</p>
</div>

<!--- Create / Cancel --->
<div id="_buttonbar" class="buttons align-center" style="margin-top:8px;">
	<a href="#getSetting('sesBaseURL')#/#rc.xehAdminLookups#?lookupclass=#rc.lookupclass#" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/cancel.png" border="0" align="absmiddle">
			Cancel
		</span>
	</a>
	&nbsp;
	<a href="javascript:submitForm()" id="buttonLinks">
		<span>
			<img src="#getSetting('sesBaseURL')#/includes/images/add.png" border="0" align="absmiddle">
			Create Record
		</span>
	</a>
</div>
<br />
</cfform>
</cfoutput>