<!--- create a non found wiki page --->
<cfscript>
	content = event.getValue("content");
</cfscript>

<cfoutput>
	<!--- how to we want to handle header inclusion? --->
	<cfsavecontent variable="head">
		<link rel="stylesheet" type="text/css" href="includes/css/uni-form.css" />
	</cfsavecontent>
	<cfhtmlhead text="#head#">

	<h1>#content.getPage().getName()#</h1>

	<form action="?event=#event.getValue("onSubmit")#" method="post" class="uniForm">
		<div class="blockLabels">

		<cfif content.getIsPersisted()>
			<input type="hidden" name="contentid" value="#content.getContentID()#" />
		</cfif>
		<input type="hidden" name="pageName" value="#content.getPage().getName()#" />

          <div class="ctrlHolder">
            <label for="content"><em>*</em> Wiki Content</label>
            <textarea name="content" id="content" rows="25" cols="50">#content.getContent()#</textarea>
          </div>
		</div>
 		<div class="buttonHolder">
      		<button type="button" class="cancelButton" onclick="window.location='?event=#event.getValue("onCancel")#'">Cancel</button>
      		<button type="submit" class="submitButton">Submit</button>
    	</div>
	</form>
</cfoutput>