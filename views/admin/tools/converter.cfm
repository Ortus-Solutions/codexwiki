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
		$('.resizable').TextAreaResizer();
		/* Form Validation */
		$('##converterForm').formValidation({
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
<cfoutput>
<h2><img src="includes/images/code.png" alt="converter" /> CodexWiki Markup Converter</h2>
<p>Please use the form below to convert HTML code to a markup language</p>


#getPlugin("messagebox").renderit()#

<!--- Form --->
<form name="converterForm" id="converterForm" action="#event.buildLink(rc.xehonSubmit)#" method="post">
<div>
	<label for="translator"> Markup Syntax</label>
	<em>Choose the markup syntax to convert to.</em><br />
	<select name="translator" id="translator">
		<cfloop list="#rc.translators#" index="syntax">
			<option value="#syntax#" <cfif syntax eq event.getValue("translator","")>selected="selected"</cfif>>#syntax#</option>
		</cfloop>
	</select>
	
	<label for="htmlString"> HTML Markup</label>
    <textarea dname="HTML String" required="true" name="htmlString" id="htmlString" rows="10" cols="50" class="resizable">#event.getValue("htmlString","")#</textarea>
    
	<cfif structKeyExists(rc,"markup")>
	<label for="wikiMarkup"> Wiki Markup</label>
    <textarea name="wikiMarkup" id="wikiMarkup" rows="10" cols="50" class="resizable">#event.getValue("markup","")#</textarea>
    </cfif>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Convert HTML"></input>
   	</div>
</div>
</form>


</cfoutput>