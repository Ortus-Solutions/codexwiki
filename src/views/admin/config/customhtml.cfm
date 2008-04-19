<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
	<script type="text/javascript">
		function submitForm(){
			$('##_buttonbar').slideUp("fast");
			$('##_loader').fadeIn("slow");
		}
		$(document).ready(function() {
			$('.resizable').TextAreaResizer();
		});
	</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2>Custom HTML</h2>
<p>
	Please enter below the custom HTML that should be placed on the wiki pages.
</p>

#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#getSetting('sesBaseURL')#/#rc.xehonSubmit#" method="post" class="uniForm" onsubmit="submitForm()">
	<div class="blockLabels">
		<div class="ctrlHolder">
		     <label for="comment"><em>*</em> Before Head End</label>
		     <textarea name="beforeHeadEnd" id="beforeHeadEnd" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getbeforeHeadEnd()#</textarea>
		</div>
		<div class="ctrlHolder">
		     <label for="comment"><em>*</em> After Body Start</label>
		     <textarea name="afterBodyStart" id="afterBodyStart" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getafterBodyStart()#</textarea>
		</div>
		<div class="ctrlHolder">
		     <label for="comment"><em>*</em> Before Body End</label>
		     <textarea name="beforeBodyEnd" id="beforeBodyEnd" rows="5" cols="50" class="resizable">#rc.oCustomHTML.getbeforeBodyEnd()#</textarea>
		</div>
	</div>

	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="#getSetting('sesBaseURL')#/includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save HTML"></input>
   	</div>
</form>
</cfoutput>