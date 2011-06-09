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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	$(document).ready(function() {
		/* Form Validation */
		$('##optionForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});
		
		//Page Filter
		theTable = $('##wikiPagesTable');
		$("##pageFilter").keyup(function(){
			$.uiTableFilter(theTable,this.value);
		})				
	});
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
	function selectPage(thePage){
		$('##wiki_defaultpage').val(thePage);
		$('##wikiPageListing').slideToggle();
	}
	function selectSearch(engine){
		$('##wiki_search_engine').val(engine);
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/cog.png" alt="options" /> Codex Options</h2>
<p>
	From here you can manage the overal Codex System Options. Please be careful when editing the main options as it affects the entire wiki installation.
</p>
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
<div>
	<fieldset>
	<legend><strong>General Options</strong></legend>
	 	<div>
	 	<!--- Wiki Name --->
		<label for="wiki_name">Wiki Name</label>
		<em>The global name for this wiki.</em><br />
		<input type="text"
			   dName="Wiki Name"
			   name="wiki_name" id="wiki_name" 
			   value="#rc.CodexOptions.wiki_name#" size="40" required="true">
     	<br /><br />
	
		<!--- Wiki Metadata --->
		<label for="wiki_metadata">Wiki Metadata Description</label>
		<em>The global metadata description content to place in the metadata tag.</em><br />
		<textarea dName="Wiki Metadata"
			      name="wiki_metadata" id="wiki_metadata"
			   	  rows="2"  required="true">#rc.CodexOptions.wiki_metadata#</textarea>
     	<br />
	
		<!--- Wiki Keywords --->
		<label for="wiki_metadata">Wiki Metadata Keywords</label>
		<em>The global metadata keywords to place in the metadata tag.</em><br />
		<textarea dName="Wiki Metadata Keywords"
			      name="wiki_metadata_keywords" id="wiki_metadata_keywords"
			   	  rows="2" required="true">#rc.CodexOptions.wiki_metadata_keywords#</textarea>
     	<br />
		
		<!--- Wiki Outgoing Email --->
		<label for="wiki_outgoing_email">Wiki Administrator Email</label>
		<em>The email to use to send out email and also receive email notifications from.</em><br />
		<input type="text"
			   dName="Wiki Outgoing Email"
			   name="wiki_outgoing_email" id="wiki_outgoing_email" 
			   value="#rc.CodexOptions.wiki_outgoing_email#" 
			   size="40" required="true" mask="email">

		<br /><br />
		
		<!--- Default Page --->
		<label for="wiki_defaultpage_label">Wiki Default Page Label</label>
     	<em>The label for the menu item for the default wiki page.</em><br />
		<input type="text" 
		 	   dName="Default Page Label"
		 	   name="wiki_defaultpage_label" id="wiki_defaultpage_label" 
		 	   value="#rc.CodexOptions.wiki_defaultpage_label#" size="40" required="true"> 
		<br /><br />
		
		<label for="wiki_defaultpage">Wiki Default Page</label>
     	<em>The actual wiki page name to link to.</em><br />
		<input type="text" 
		 	   dName="Default Page"
		 	   name="wiki_defaultpage" id="wiki_defaultpage" 
		 	   value="#rc.CodexOptions.wiki_defaultpage#" size="40" required="true"> 
		<input type="button" name="pageChooser" id="pageChooser" 
			   onclick="$('##wikiPageListing').slideToggle()" value="Choose Page">
		<div id="wikiPageListing" class="wikiChooser">
			<table id="wikiPagesTable" class="tablelisting" width="100%">
				<thead>
					<tr>
						<th>
						<strong>Wiki Page: </strong>
						<input name="pageFilter" id="pageFilter" value="Type Here To Filter" 
							   size="50" type="text"
							   onclick="if(this.value='Type Here To Filter'){this.value='';}">
						</th>
					</tr>
				</thead>
				<tbody>
				<cfloop query="rc.qPages">
					<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
						<td><a href="javascript:selectPage('#name#')">#name#</a></td>
					</tr>
				</cfloop>
				</tbody>
				
			</table>
		</div>
		
		<br /><br />
		
		<!--- Comments  --->
		<label for="wiki_comments_mandatory">Mandatory Page Comments</label> 
		<em>Whether edit comments for pages should be mandatory or not.</em><br />
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif not rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="0">No
		
		</div>
	</fieldset>
	
	
	<fieldset>
	<legend><strong>User Avatars</strong></legend>
		An avatar is an image that follows you from site to site appearing beside your name when you comment on 
			avatar enabled sites.
		<!--- Gravatars  --->
		<label for="wiki_gravatar_display">Show User Avatar</label> 
		<em>Whether to display a user's <a href="http://en.gravatar.com/">gravatar</a> on edits, comments, etc.</em><br />
		<input type="radio" 
			   name="wiki_gravatar_display" id="wiki_gravatar_display"
			   <cfif rc.CodexOptions.wiki_gravatar_display>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_gravatar_display" id="wiki_gravatar_display"
			   <cfif not rc.CodexOptions.wiki_gravatar_display>checked="checked"</cfif>
			   value="0">No
		<br /><br />
		<label for="wiki_gravatar_rating">Avatar Rating</label>
		<em>The maximum avatar display rating.</em><br />
		<select name="wiki_gravatar_rating" id="wiki_gravatar_rating">
			<option value="G"  <cfif rc.CodeXOptions.wiki_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
			<option value="PG" <cfif rc.CodeXOptions.wiki_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
			<option value="R"  <cfif rc.CodeXOptions.wiki_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
			<option value="X"  <cfif rc.CodeXOptions.wiki_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
		</select>
	</fieldset>
	
	<fieldset>
	<legend><strong>Search Engine Options</strong></legend>
		<div>
		<!--- Default Page --->
		<label for="wiki_search_engine">Wiki Search Engine</label>
     	The wiki search engine class to use. You can create your own search engine adapters
	    as long as they implement <em>codex.model.search.adapters.ISearchAdapter</em>.  If you change 
	    this setting, please make sure that you re-initialize Codex in order for the changes to take
	    effect.
	    <br /><br />
	    Codex comes bundled with the following search engine adapters:<br />
		<ul>
			<li><strong>Database Search</strong><br /><a href="javascript:selectSearch('codex.model.search.adapters.DBSearch')">codex.model.search.adapters.DBSearch</a></li>
			<li><strong>Verity Search</strong><br /><a href="javascript:selectSearch('codex.model.search.adapters.VeritySearch')">codex.model.search.adapters.VeritySearch</a></li>
		</ul>
		<input type="text" 
		 	   dName="Search Engine"
		 	   name="wiki_search_engine" id="wiki_search_engine" 
		 	   value="#rc.CodexOptions.wiki_search_engine#" size="60" required="true"> 
		</div>
	</fieldset>
	
	<fieldset>
		<legend>Wiki Registration</legend>
		
		<!--- Wiki Registration --->
		<label for="wiki_registration">Enable/Disable Wiki Registration</label> 
		<em>Activate wiki user registration or not.</em><br />
		<input type="radio" 
			   name="wiki_registration" id="wiki_registration"
			   <cfif rc.CodexOptions.wiki_registration>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_registration" id="wiki_registration"
			   <cfif not rc.CodexOptions.wiki_registration>checked="checked"</cfif>
			   value="0">No
		<br /><br />
		<!--- Wiki Default Role --->
		<label for="wiki_defaultrole_id">Default Role</label>
		<em>The default role assigned to users when they register for this wiki.</em><br />
		<select name="wiki_defaultrole_id" id="wiki_defaultrole_id" required="true" dName="Default Role" style="width:200px">
			<cfloop query="rc.qRoles">
				<option value="#roleid#" <cfif roleid eq rc.CodexOptions.wiki_defaultrole_id>selected="selected"</cfif>>#role#</option>
			</cfloop>
		</select>
	</fieldset>
	
	<fieldset>
		<legend>Paging Options</legend>
		<!--- Max Rows --->
		<label for="wiki_paging_maxrows">Paging Max Rows</label>
		<em>The maximum number of rows for paging.</em><br />
		<select dName="Paging Max Rows" 
				name="wiki_paging_maxrows" id="wiki_paging_maxrows" 
				required="true">
			<cfloop from="5" to="50" step="5" index="i">
				<option value="#i#" <cfif i eq rc.CodexOptions.wiki_paging_maxrows>selected="selected"</cfif>>#i#</option>
			</cfloop>
		</select>
		
		<br /><br />
		<!--- Max Band Gap --->
		<label for="wiki_paging_bandgap">Paging Band Gap</label>
		<em>The number of pages to have in the paging carrousel.</em><br />
		<select dName="Paging Band Gap"
				name="wiki_paging_bandgap" id="wiki_paging_bandgap" 
				required="true">
			<cfloop from="5" to="50" step="5" index="i">
				<option value="#i#" <cfif i eq rc.CodexOptions.wiki_paging_bandgap>selected="selected"</cfif>>#i#</option>
			</cfloop>
		</select>
	</fieldset>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
			<img src="includes/images/ajax-loader-horizontal.gif" alt="loader" />
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save Options"></input>
   	</div>
</div>
</form>
</cfoutput>