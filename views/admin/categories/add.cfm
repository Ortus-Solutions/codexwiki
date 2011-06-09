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
		$('##categoriesForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});			
	});
	function submitForm(){
		$('##categoriesForm').submit();		
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

<cfoutput>
	
<!--- BACK --->
<div class="backbutton">
	<img src="includes/images/arrow_left.png" alt="left" />
	<a href="#event.buildLink(rc.xehListing)#">Back</a>
</div>

<!--- Title --->
<h2><img src="includes/images/tag_blue.png" alt="blue" /> Categories Management : Create Category</h2>
<p>Create a new category in the wiki system, this also creates the special category page.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="categoriesForm" id="categoriesForm" action="#event.buildLink(rc.xehCreate)#" method="post">
	
	<fieldset>
	<legend><strong>Category Information</strong></legend>
	
	<label for="role">Name</label>
	<label class="helptext">The name of the new namespace.</label>
	<input type="text" name="name" id="name" dName="name" size="30" value="#event.getValue("name","")#" 
		   required="true">
	</fieldset>
	
	<br />

	<!--- Loader Bar --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
	
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>	
	
	<!--- Create / Cancel --->
	<div id="_buttonbar" class="buttons align-center">
		<a href="#event.buildLink(rc.xehListing)#" class="buttonLinks">
			<span>
				<img src="includes/images/cancel.png" border="0" alt="cancel" />
				Cancel
			</span>
		</a>
		&nbsp;
		<a href="javascript:submitForm()" class="buttonLinks">
			<span>
				<img src="includes/images/add.png" border="0" alt="add" />
				Create Category
			</span>
		</a>
	</div>
	<br />
</form>
</cfoutput>