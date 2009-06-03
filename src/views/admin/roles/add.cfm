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
		$('##roleForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});			
	});
	function submitForm(){
		$('##roleForm').submit();		
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
	<img src="includes/images/arrow_left.png" alt="back" />
	<a href="#event.buildLink(rc.xehListing)#">Back</a>
</div>

<!--- Title --->
<h2><img src="includes/images/vcard.png" alt="role" /> Role Management : Create Role</h2>
<p>Create a new role in the wiki system.</p>

<!--- Render Messagebox. --->
#getPlugin("messagebox").renderit()#

<!--- Table Manager Jumper --->
<form name="roleForm" id="roleForm" action="#event.buildLink(rc.xehCreate)#" method="post">
	
	<fieldset>
	<legend><strong>Role Information</strong></legend>
	
	<label for="role">Role</label>
	<label class="helptext">The role name to use.</label>
	<input type="text" name="role" id="role" dName="Role" size="30" value="#event.getValue("role","")#" 
		   required="true">
	
	<label for="lname">Description</label>
	<label class="helptext">A brief role description.</label>
	<textarea name="description" id="description" dName="Description" required="true">#event.getValue("description","")#</textarea>

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
				Create Role
			</span>
		</a>
	</div>
	<br />
</form>
</cfoutput>