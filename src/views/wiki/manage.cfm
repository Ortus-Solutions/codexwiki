<!--- create a non found wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getName()#</h1>

<form action="#getSetting('sesBaseURL')#/#rc.onSubmit#" method="post" class="uniForm">
	<div class="blockLabels">
		<cfif rc.content.getIsPersisted()>
			<input type="hidden" name="contentid" value="#rc.content.getContentID()#" />
		</cfif>
		<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />
	
	    <div class="ctrlHolder">
	      <label for="content"><em>*</em> Wiki Content</label>
	      <textarea name="content" id="content" rows="20" cols="50">#rc.content.getContent()#</textarea>
	    </div>
	</div>
	
	<div class="buttonHolder">
   		<input type="button" class="cancelButton" onclick="window.location='#getSetting('sesBaseURL')#/#rc.onCancel#'" value="cancel"></input>
   		<input type="submit" class="submitButton" value="submit"></input>
   	</div>
</form>
</cfoutput>