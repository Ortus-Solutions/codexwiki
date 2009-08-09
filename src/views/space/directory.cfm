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
		theTable = $('##wikiSpaceTable');
		$("##spaceFilter").keyup(function(){
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
	Namespace Directory
</h2>

<p>Below is the current namespace directory for this wiki.  You can filter to find specific spaces or click on
the space name to visit the namespace viewer.</p>

<label class="inlineLabel">Space Filter: </label>
<input name="spaceFilter" id="spaceFilter" value="Type Here To Filter"
	   size="50" type="text"
	   onclick="if(this.value='Type Here To Filter'){this.value='';}">


<div id="wikiSpacesDiv">
	<table id="wikiSpaceTable" class="tablelisting" width="100%">
		<thead>
			<tr>
				<th>Namespace</th>
				<th>Description</th>
			</tr>
		</thead>
		
		<tbody>
		<cfloop query="rc.qNamespaces">
			<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
				<td>
					<a href="#event.buildLink(linkto='#getSetting('spaceKey')#/#rc.qNamespaces.name#',translate=false)#">
					<cfif len(rc.qNamespaces.name)>
					#rc.qNamespaces.name#
					<cfelse>
					Default
					</cfif>
					</a>
				</td>
				<td>#rc.qnamespaces.description#</td>
			</tr>
		</cfloop>
		</tbody>	
		
		<cfif rc.qNamespaces.recordcount eq 0>
		<tr>
			<td colspan="2">No Records Found.</td>
		</tr>
		</cfif>
	</table>
</div>
</cfoutput>