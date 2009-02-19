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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	$(document).ready(function() {
		/* Form Validation */
		$('##optionForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});
	});
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/comments.png" align="absmiddle"> Codex Comment Options</h2>
<p>
	The options below have to deal with the Codex Commenting System.
</p>
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
	<fieldset>
	<legend><strong>Comment Options</strong></legend>
	 	<!--- Comments  --->
		<label for="wiki_comments_mandatory">Mandatory Page Comments</label> 
		Whether edit comments for pages should be mandatory or not.<br />
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif not rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="0">No
		<br />
		
		<!--- Wiki Metadata --->
		<label for="wiki_metadata">Wiki Metadata Description</label>
		The global metadata description content to place in the metadata tag.<br />
		<textarea dName="Wiki Metadata"
			      name="wiki_metadata" id="wiki_metadata"
			   	  rows="2"  required="true">#rc.CodexOptions.wiki_metadata#</textarea>
     	<br />
	
		<!--- Wiki Keywords --->
		<label for="wiki_metadata">Wiki Metadata Keywords</label>
		The global metadata keywords to place in the metadata tag.<br />
		<textarea dName="Wiki Metadata Keywords"
			      name="wiki_metadata_keywords" id="wiki_metadata_keywords"
			   	  rows="2" required="true">#rc.CodexOptions.wiki_metadata_keywords#</textarea>
     	<br />
		
		<!--- Wiki Outgoing Email --->
		<label for="wiki_outgoing_email">Wiki Administrator Email</label>
		The email to use to send out email and also receive email notifications from.<br />
		<input type="text"
			   dName="Wiki Outgoing Email"
			   name="wiki_outgoing_email" id="wiki_outgoing_email" 
			   value="#rc.CodexOptions.wiki_outgoing_email#" 
			   size="60" required="true" mask="email">

		<br />
		
		
		
	</fieldset>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save Options"></input>
   	</div>
</form>
</cfoutput>