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
<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/page_edit.png" align="absmiddle"> Editing: 
	<a href="#pageShowRoot()##URLEncodedFormat(rc.content.getPage().getName())#.cfm">#rc.content.getPage().getName()#</a>
</h1>

<form action="#getSetting('sesBaseURL')#/#rc.onSubmit#.cfm" method="post" class="uniForm">
	<div class="blockLabels">
		<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />
		
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