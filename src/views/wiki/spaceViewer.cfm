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
$(window).ready(function(){
	attachTableFilter()
});
function attachTableFilter(){
	//Page Filter
	theTable = $('##wikiPagesTable');
	$("##pageFilter").keyup(function(){
		$.uiTableFilter(theTable,this.value);
	});
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h2>
	<img src="includes/images/directory.png" border="0" alt="directory" />
	Namespace Directory: <cfif len(rc.namespace)>#rc.namespace#<cfelse>Default Namespace</cfif>
</h2>
<p>Below is the current page directory for the <strong><cfif len(rc.namespace)>#rc.namespace#<cfelse>Default</cfif></strong> namespace.  
You can filter to find specific pages or click on the page name to visit the page.</p>

<!--- Page Filter --->
<label class="inlineLabel">Page Filter: </label>
<input name="pageFilter" id="pageFilter" value="Type Here To Filter"
	   size="50" type="text"
	   onclick="if(this.value='Type Here To Filter'){this.value='';}">
<br /><br />
<!--- Render Pages --->
<div id="wikiPagesDiv">#renderView('wiki/directoryPagesTable')#</div>
</cfoutput>