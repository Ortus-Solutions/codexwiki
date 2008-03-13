<!--- create a non found wiki page --->

<cfsetting showdebugoutput="false">

<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function resizeTextArea(id, rows) {
		  var textarea = $('##' + id);
		  textarea.attr('rows',rows);
		}

		function preview()
		{
			var content = $("##content");

			var preview = $('<div style="text-align: center; padding-top: 20px"><span class="loading">Loading Preview...</a></div>').modal({
				close:false,
				onOpen: function(dialog)
					{
					 	dialog.overlay.fadeIn("normal", function()
						 	{
						 		dialog.container.fadeIn("fast", function()
						 			{
										var data = {method: "getPreviewHTML", content: content.val()};

										$.post("#getSetting('sesBaseURL')#/model/wiki/remote/RemoteWikiService.cfc", data,
											function(string, status)
											{
												dialog.container.html('<div><p class="align-right"><img src="#getSetting('htmlBaseURL')#/includes/images/cross.png" align="absmiddle"><a href="javascript:$.modal.close();">close</a></p><div class="modalContent">' + string + '</div></div>');
											}
										);
						 			}
						 		)

						 	}
						 )
					}
				});



		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/page_edit.png" align="absmiddle"> Editing:
	"<a href="#pageShowRoot()##URLEncodedFormat(rc.content.getPage().getName())#.cfm">#rc.content.getPage().getName()#</a>"
</h1>

<!--- Form --->
<form action="#getSetting('sesBaseURL')#/#rc.onSubmit#.cfm" method="post" class="uniForm">
	<div class="blockLabels">
		<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />

		<!--- Right Floating Toolbar --->
		<div id="wikiToolbarRight">
			<label for="winheight">Adjust edit area height: </label>
			<select onchange="resizeTextArea('content', this.options[selectedIndex].value)"
					id="winheight"
					name="winheight"
					size="1">
			  <option value="8">8</option>
			  <option value="12">12</option>
			  <option value="16">16</option>
			  <option selected="selected" value="20">20</option>
			  <option value="24">24</option>
			  <option value="28">28</option>
			  <option value="32">32</option>
			  <option value="36">36</option>
			  <option value="40">40</option>
			</select>
	     </div>

		<!--- Control Holder & Text Area --->
		<div class="ctrlHolder">
	      <label for="content"><em>*</em> Wiki Content</label>
	      <textarea name="content" id="content" rows="20" cols="50">#rc.content.getContent()#</textarea>
	    </div>

		<!--- Comment Editing --->
		<div class="ctrlHolder">
	      <label for="comment"><em>*</em> Edit Comment</label>
	      <textarea name="comment" id="comment" rows="3" cols="50"></textarea>
	    </div>
	</div>

	<!--- Management Toolbar --->
	<div class="buttonHolder">
		<input type="button" class="cancelButton" onclick="window.location='#getSetting('sesBaseURL')#/#getSetting('showKey')#/#rc.content.getPage().getName()#.cfm'" value="cancel"></input>
   		<input type="button" class="previewButton" onclick="javascript:preview();" value="preview">
   		<input type="submit" class="submitButton" value="submit"></input>
   	</div>

</form>
</cfoutput>