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
	<img src="includes/images/history.png" border="0" align="absmiddle">
	<a href="#event.buildLink(rc.onShowHistory)#/#rc.page.getName()#.cfm">Back To History</a>
</div>

<!--- Title --->
<h2>
	<img src="includes/images/history.png" border="0" align="absmiddle">
	Changes between Version <strong>#event.getValue('version',"")#</strong> and 
	<strong>#event.getValue("old_version",'')#</strong> of 
	<a href="#pageShowRoot(URLEncodedFormat(rc.page.getName()))#.cfm">#rc.page.getCleanName()#</a>
</h2>

<br />
<table class="diff tablelisting" cellspacing="0" border="1">
	<tr>
		<th colspan="2" class="center">Version #rc.version#<br />
		#printDate(rc.currentContent.getcreatedDate())# at #printTime(rc.currentContent.getCreatedDate())#<br />
		(by #rc.CurrentContent.getUser().getUsername()#)
		</th>
		<th colspan="2" class="center">Version #rc.old_version#<br />
			#printDate(rc.currentContent.getcreatedDate())# at #printTime(rc.currentContent.getCreatedDate())#<br />
			(by #rc.oldContent.getUser().getUsername()#)
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