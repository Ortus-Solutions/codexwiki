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
		//Page Filter
		theTable = $('##wikiPagesTable');
		$("##pageFilter").keyup(function(){
			$.uiTableFilter(theTable,this.value);
		});		
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="includes/images/directory.png" border="0" align="absmiddle">
	Wiki Page Directory
</h1>

<p>Below is the current page directory for this wiki.  You can filter to find specific pages or click on 
the page name to visit the page.</p>

<table id="wikiPagesTable" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>
			<strong>Page Filter: </strong>
			<input name="pageFilter" id="pageFilter" value="Type Here To Filter" 
				   size="50" type="text"
				   onClick="if(this.value='Type Here To Filter'){this.value='';}">
			</th>
		</tr>
	</thead>
	<tbody>
	<cfloop query="rc.qPages">
		<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
			<td><a href="#pageShowRoot(name)#.cfm">#name#</a></td>
		</tr>
	</cfloop>
	</tbody>
	
</table>
</cfoutput>