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
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##pageName").focus();
});
function createPage(){
	var page = $("##pageName").val();
	if( page.length == 0){
		alert("Please enter a page name!");
		return false;
	}
	// cleanup page
	page = page.replace(/ /g,"_");
	
	if( $("##namespace").val().length > 0){
		page = $("##namespace").val() + ":" + page;
	}
	$('##_buttonbar').slideUp("fast");
	$('##_loader').fadeIn("slow");
			
	// relocate
	window.location='#event.buildLink(linkto=rc.xehCreate,override=true)#/'+page+"#event.getRewriteExtension()#";
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<h1><img src="includes/images/add.png" border="0" alt="add" /> Create a new page</h1>

<form name="newPageForm" id="newPageForm">
	<fieldset>
	<legend>Page Details:</legend>
	<label>Name your page: </label>
	<input type="text" name="pageName" id="pageName" size="40"  />

	<label>Choose the namespace:</label>
	<select name="namespace" id="namespace">
		<cfloop query="rc.qNamespaces">
			<option value="#rc.qNamespaces.name#">
				<cfif len(rc.qNamespaces.name)>
					#rc.qNamespaces.name#
				<cfelse>
					Default
				</cfif>
			</option>
		</cfloop>
	</select>
	
	</fieldset>
	
	<!--- Loader Bar --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
	
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>	
	
	<!--- Button Bar --->
	<div align="center" id="_buttonbar">
		<a href="javascript:createPage()" class="buttonLinks">
			<span>
				<img src="includes/images/accept.png" border="0" alt="accept" />
				Create Page
			</span>
		</a>
	
	</div>
	
	<br/><br/>
</form>

</cfoutput>