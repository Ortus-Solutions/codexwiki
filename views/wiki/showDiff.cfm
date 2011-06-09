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
	$(window).ready(function(){
	
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>

<!--- Menu bar --->	
<div class="float-right">
	<img src="includes/images/history.png" border="0" alt="history" />
	<a href="#event.buildLink(rc.onShowHistory & "/" & rc.page.getName())#">Back To History</a>
</div>

<!--- Title --->
<h2>
	<img src="includes/images/history.png" border="0" alt-"history" />
	Changes between Version <strong>#event.getValue('version',"")#</strong> and 
	<strong>#event.getValue("old_version",'')#</strong> of 
	<a href="#event.buildLink(pageShowRoot(URLEncodedFormat(rc.page.getName())))#">#rc.page.getCleanName()#</a>
</h2>

<h3>Version Info Comparison</h3>
<!--- Info Table --->
<table class="tablelisting">
	<tr>
		<th class="center">Info</th>
		<th class="center">Version #rc.version#</th>
		<th class="center">Version #rc.old_version#</th>
	</tr>
	<tr>
		<td><strong>Author</strong></td>
		<td><a href="mailto:#rc.currentContent.getUser().getEmail()#">#rc.currentContent.getUser().getUsername()#</a></td>
		<td><a href="mailto:#rc.oldContent.getUser().getEmail()#">#rc.oldContent.getUser().getUsername()#</a></td>
		
	</tr>
	<tr>
		<td><strong>Read Only</strong></td>
		<td>#rc.currentContent.getisReadOnly()#</td>
		<Td>#rc.oldContent.getisReadOnly()#</Td>
	</tr>
	<tr>
		<td><strong>Created Date</strong></td>
		<td>#printDate(rc.currentContent.getCreatedDate())# at  #printTime(rc.currentContent.getCreatedDate())#</td>
		<td>#printDate(rc.oldContent.getCreatedDate())# at #printTime(rc.oldContent.getCreatedDate())#</td>
	</tr>
	<tr>
		<td><strong>Comment</strong></td>
		<td>#rc.currentContent.getComment()#</td>
		<td>#rc.oldContent.getComment()#</td>
	</tr>
</table>


<h3>Content Differences</h3>

<!--- Legend --->
<div id="legend">
  <dl>
	<dt /><dd>Unmodified</dd>
   	<dt class="ins"/><dd>Added</dd>
   	<dt class="del"/><dd>Removed</dd>
   	<dt class="upd"/><dd>Modified</dd>
  </dl>
</div>

<table class="diff tablelisting" cellspacing="0" border="1">
	<tr>
		<th colspan="2" class="center">Version #rc.version#
		</th>
		<th colspan="2" class="center">Version #rc.old_version#
		</th>
	</tr>
<cfloop query="rc.parallel">
	<tr>
		<td class="linenum"><cfif IsNumeric(AtSecond)>#NumberFormat(AtSecond)#<cfelse>&nbsp;</cfif></td>
		
		<td width="50%" class="code<cfif Operation NEQ '-'> #rc.diffcss[Operation]#<cfelse> delLight</cfif>">
			<div class="diffContent">#Replace(HTMLEditFormat(ValueSecond),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL")#</div>
		</td>
		
		<td class="linenum"><cfif IsNumeric(AtFirst)>#NumberFormat(AtFirst)#<cfelse>&nbsp;</cfif></td>
		
		<td width="50%" class="code<cfif Operation NEQ '+'> #rc.diffcss[Operation]#<cfelse> insLight</cfif>">
			<div class="diffContent">#Replace(HTMLEditFormat(ValueFirst),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL")#</div>
		</td>
	</tr>
</cfloop>
</table>

</cfoutput>