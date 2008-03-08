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

				$.post("#getSetting('sesBaseURL')#/model/wiki/remote/RemoteWikiService.cfc", data,
					function(string, status)
					{
						 show.slideUp("normal");
						 show.html(string)
						 show.slideDown("normal");
					}
				);
			}
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->	
<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/history.png" border="0" align="absmiddle">
	<a href="#pageShowRoot()##URLEncodedFormat(rc.page.getName())#.cfm">#rc.page..getName()#</a>: History
</h1>

<ol>
	<cfloop query="rc.history">
	<li>
		<a href="javascript: doDisplay('#contentid#')">Version #version#, created on #DateFormat(createddate, "dd-mmmm-yyyy")# #TimeFormat(createddate, "hh:mm:ss tt")#</a>
		<cfif isActive>
		| <img src="#getSetting('htmlBaseURL')#/includes/images/asterisk_orange.png" align="absmiddle"> <strong>Active Version</strong>
		<cfelse>
		| <img src="#getSetting('htmlBaseURL')#/includes/images/arrow_merge.png" align="absmiddle"> <a href="#getSetting('sesBaseURL')#/#rc.onReplaceActive#/id/#contentid#.cfm">rollback</a>
		| <img src="#getSetting('htmlBaseURL')#/includes/images/bin_closed.png" align="absmiddle"> <a href="#getSetting('sesBaseURL')#/#rc.onDelete#/id/#contentid#.cfm">delete</a>
		</cfif>
		<div>
			#XMLFormat(comment)#
		</div>
		<div style="display: none;" id="contentshow_#contentid#" loaded="0">
		 <span class="loading">Loading...</span>
		</div>
	</li>
	</cfloop>
</ol>
</cfoutput>