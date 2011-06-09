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
<!--- create a non found wiki page --->
<cfsetting showdebugoutput="false">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function prepareSubmit(){
	$('##_loader').fadeIn("slow");
}
$(document).ready(function() {
	/* Form Validation */
	$('##passwordForm').formValidation({
		err_class 	: "invalidLookupInput",
		err_list	: true,
		callback	: 'prepareSubmit'
	});			
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="includes/images/page_edit.png" alt="edit" /> Protected:
	"<a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.content.getPage().getName())))#">#rc.content.getPage().getCleanName()#</a>"
</h1>

<!--- MessageBox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehPasswordCheck)#" method="post" name="passwordForm" id="passwordForm">

	<input type="hidden" name="pageID" value="#rc.content.getPage().getPageID()#" />
	<p>This page is protected. Please enter the page password below and then click on the submit button.</p>
	
	<label for="content"><em>*</em> Password</label>
	<input type="password" name="PagePassword" id="PagePassword" value="" size="30" required="true" />
		
	<input type="submit" class="submitButton" value="submit"></input>

	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>
	
	<p>&nbsp;</p>
</form>
</cfoutput>