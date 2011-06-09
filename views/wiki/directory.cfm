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
<!--- show the history if a wiki page --->
<!--- js --->
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
	function filterPages(){
		$("##namespace_spinner").toggle();
		var data = new Object();
		data.pagesTable = "True";
		data.namespaces = "";
		/* Get ID's' */
		$(".namespaces").each(function(){
			if(this.checked == true){
				data.namespaces += this.value + ",";
			}
		});
		$("##wikiPagesDiv").load('#event.buildLink(rc.xehPageDirectory)#',data,function(){
			$("##namespace_spinner").toggle();
			attachTableFilter();
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
	Page Directory
</h2>

<p>Below is the current page directory for this wiki.  You can filter to find specific pages or click on
the page name to visit the page.</p>

<label>Show Namespace(s): 
<img src="includes/images/ajax-spinner.gif" name="namespace_spinner" id="namespace_spinner" class="hidden" alt="spinner" />
</label>

<cfloop query="rc.qNamespaces">
	<input type="checkbox" name="namespace" id="namespace" class="namespaces"
		   value="#namespace_id#" onclick="filterPages()"
		   <cfif isDefault>checked="checked"</cfif>><cfif len(name)>#name#<cfelse>#description#</cfif>
</cfloop>

<br /><br />

<label class="inlineLabel">Page Filter: </label>
<input name="pageFilter" id="pageFilter" value="Type Here To Filter"
	   size="50" type="text"
	   onclick="if(this.value='Type Here To Filter'){this.value='';}">


<div id="wikiPagesDiv">#renderView('wiki/directoryPagesTable')#</div>
</cfoutput>