<!--- create a non found wiki page --->

<cfsetting showdebugoutput="false">

<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		$(document).ready(function()
			{
				content = $("##content");
				resizeContent();

				content.keyup(function(event)
					{
						if(event.keyCode == 13)
						{
							resizeContent();
						}
					}
				);

			}
		);

		function resizeContent()
		{
			var rows = parseInt(content.attr("rows"));
			var length = content.val().split("\n").length;
			if(length + 3 >= rows)
			{
				content.attr("rows", length + 3);
			}
		}

		function preview()
		{
			$('<div><p style="text-align: right;"><a href="javascript:$.modal.close();">close</a></p>'+ content.val() +'</div>').modal({close:false});
		}
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<h1><a href="#pageShowRoot()##URLEncodedFormat(rc.content.getPage().getName())#.cfm">#rc.content.getPage().getName()#</a></h1>

<form action="#getSetting('sesBaseURL')#/#rc.onSubmit#.cfm" method="post" class="uniForm">
	<div class="blockLabels">
		<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />

	    <div class="ctrlHolder">
	      <label for="content"><em>*</em> Wiki Content</label>
	      <textarea name="content" id="content" rows="20" cols="50">#rc.content.getContent()#</textarea>
	    </div>
	</div>

	<div class="buttonHolder">
		<input type="button" class="cancelButton" onclick="window.location='#getSetting('sesBaseURL')#/#getSetting('showKey')#/#rc.content.getPage().getName()#.cfm'" value="cancel"></input>
   		<input type="button" class="previewButton" onclick="javascript:preview();" value="preview">
   		<input type="submit" class="submitButton" value="submit"></input>
   	</div>
</form>
</cfoutput>