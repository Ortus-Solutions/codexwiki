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
				data.method = "getContentHTML";
				data.contentid = id;
				//post the retrieval
				$.post("#getSetting('sesBaseURL')#/model/wiki/remote/RemoteWikiService.cfc", data, function(data, status){
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
	<a href="#pageShowRoot()##URLEncodedFormat(rc.page.getName())#.cfm">#rc.page.getCleanName()#</a>: History
</h1>

<ol>
	<cfloop query="rc.history">
	<li>
		<a href="javascript:doDisplay('#contentid#')">Version #version#, created on #printDate(createddate)# #printTime(createddate)# by #username#</a>
		<cfif isActive>
		| <img src="includes/images/asterisk_orange.png" align="absmiddle"> <strong>Active Version</strong>
		<cfelse>
			<cfif rc.oUser.checkPermission("WIKI_ROLLBACK_VERSION")>
			| <img src="includes/images/arrow_merge.png" align="absmiddle">
			  <a href="#getSetting('sesBaseURL')#/#rc.onReplaceActive#/id/#contentid#.cfm" class="rollback" version="#version#">rollback</a>
			</cfif>
			<cfif rc.oUser.checkPermission("WIKI_DELETE_VERSION")>
			| <img src="includes/images/bin_closed.png" align="absmiddle">
			  <a href="#getSetting('sesBaseURL')#/#rc.onDelete#/id/#contentid#.cfm" class="delete" version="#version#">delete</a>
			</cfif>
		</cfif>
		<div>
			#Replace(XMLFormat(comment), chr(10), "<br/>", "all")#
		</div>
		<div class="historyload" id="contentshow_#contentid#" loaded="0">
		 <span class="loading">Loading...</span>
		</div>
	</li>
	</cfloop>
</ol>
</cfoutput>