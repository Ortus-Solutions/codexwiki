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
	function doDisplay(id)
	{
		var show = $("##contentshow_" + id).slideToggle("normal");

		if(show.attr("loaded") == 0)
		{
			show.attr("loaded", 1);
			var data = new Object();
			data.contentid = id;
			//post the retrieval
			$.post("#event.buildLink(rc.onPreview)#", data, function(data, status){
					var length = data.split("\n").length;
					show.slideUp("normal",function(){
							var className = "history";
							if(length > 10)
							{
								className += " overflow";
							}
							show.html('<div class="'+ className +'">' + data + '</div>');
							show.slideDown("normal");
						});
			});//end post
		}//if attr loaded
	}//end doDisplay function.

	$(window).ready(function()
		{
			$(".rollback").click(function()
				{
					var _this = this;
					var link = $(this);
					return confirm("Are you sure you want to rollback to version "+ link.attr("version") +"?", function(){gotoLink(_this)});
				}
			)

			$(".delete").click(function()
				{
					var _this = this;
					var link = $(this);
					return confirm("Are you sure you want to delete version "+ link.attr("version") +"?<br/>This cannot be undone!", function(){gotoLink(_this)});
				}
			)
		}
	);
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="includes/images/history.png" border="0" align="absmiddle">
	<a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.page.getName())))#">#rc.page.getCleanName()#</a>: Page History
</h1>

#getPlugin("messagebox").renderit()#

<p>Below is the current history for this page.  You can preview the version by clicking on the version link.</p>

<form name="diffForm" id="diffForm" action="#event.buildLink(rc.onDiff & '/' & rc.page.getName())#" method="get">
	
	<input type="submit" value="View Changes"><br /><br />
	
	<cfloop query="rc.history">
		<cfif isActive>
			<cfset activeVersion = version>
		</cfif>
		<table width="100%" class="tablelisting" border="0">
			<tr>
				<th width="50" class="center">Diff</th>
				<th width="50" class="center">Version</th>
				<th width="140" class="center">Date</th>
				<th width="90" class="center">Author</th>
				<th>Comment</th>
				<th width="125" class="center">Actions</th>
			</tr>
			
			<tr>
				<td>
					<input type="radio" value="#version#" name="old_version" id="old_version" <cfif version eq (activeVersion-1)>checked="checked"</cfif>>
					<input type="radio" value="#version#" name="version" id="version" <cfif isActive>checked="checked"</cfif>>
				</td>
				
				<td class="center">
					<a href="javascript:doDisplay('#contentid#')">#version#</a></td>
				
				<td class="center">#printDate(createddate)# #printTime(createddate,"short")#</td>
				
				<td class="center">#username#</td>
				
				<td>#Replace(XMLFormat(comment), chr(10), "<br/>", "all")#</td>
				
				<td class="center">
					<cfif isActive>
						<img src="includes/images/asterisk_orange.png" align="absmiddle"> <strong>Active Version</strong>
					</cfif>
					<cfif not isActive>
						<cfif rc.oUser.checkPermission("WIKI_ROLLBACK_VERSION")>
						<img src="includes/images/arrow_merge.png" align="absmiddle">
						  <a href="#event.buildLink(rc.onReplaceActive & '/id/' & contentid)#" class="rollback" version="#version#">rollback</a>
						</cfif>
						<cfif rc.oUser.checkPermission("WIKI_DELETE_VERSION")>
						<img src="includes/images/bin_closed.png" align="absmiddle">
						  <a href="#event.buildLink(rc.onDelete & '/id/' & contentid)#" class="delete" version="#version#">delete</a>
						</cfif>
					</cfif>
				</td>
			</tr>
		</table>
		<div class="historyload" id="contentshow_#contentid#" loaded="0">
		 <span class="loading">Loading...</span>
		</div>
	</cfloop>
	<br />
	<input type="submit" value="View Changes">
	
</form>

</cfoutput>