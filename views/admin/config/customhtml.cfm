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
		function submitForm(){
			$('##_buttonbar').slideUp("fast");
			$('##_loader').fadeIn("slow");
		}
		$(document).ready(function() {
			$('.resizable').TextAreaResizer();
		});
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/html_16x16.png" alt="html" /> Custom HTML</h2>
<p>
	Please enter below the custom HTML that should be placed on the wiki pages.
</p>

#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" class="uniForm" onsubmit="submitForm()">
<div>
	 <label for="beforeHeadEnd"> Before Head End</label>
    <textarea name="beforeHeadEnd" id="beforeHeadEnd" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getbeforeHeadEnd()#</textarea>
    
	<label for="afterBodyStart"> After Body Start</label>
    <textarea name="afterBodyStart" id="afterBodyStart" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getafterBodyStart()#</textarea>
    
	<label for="beforeBodyEnd"> Before Body End</label>
    <textarea name="beforeBodyEnd" id="beforeBodyEnd" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getbeforeBodyEnd()#</textarea>
		
	<label for="beforeSideBar"> Before Side Bar</label>
    <textarea name="beforeSideBar" id="beforeSideBar" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getbeforeSideBar()#</textarea>
	
	<label for="afterSideBar"> After Side Bar</label>
    <textarea name="afterSideBar" id="afterSideBar" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getAfterSideBar()#</textarea>
	
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
		<input type="submit" class="submitButton" value="Save HTML"></input>
   	</div>
</div>
</form>
</cfoutput>