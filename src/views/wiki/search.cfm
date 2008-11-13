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
<!--- search output --->

<cfoutput>
<!--- Title --->

<h1>
	<img src="includes/images/magnifier.png" align="absmiddle"> Search: #event.getValue("search_query", "")#
</h1>

<cfif StructKeyExists(rc.result, "error")>
	<p>
		#getPlugin("messagebox").renderit()#
	</p>

<cfelse>
	<p>
		Found #rc.result.results.recordCount# results in #rc.result.searched# records in #rc.result.time#ms
	</p>

	<cfif StructKeyExists(rc.result, "suggestedQuery")>
		<p>
			Did you mean: <em><a href="?search_query=#rc.result.suggestedQuery#">#rc.result.suggestedQuery#</a></em>?
		</p>
	</cfif>

	<ol>
	<cfloop query="rc.result.results">
		<li>
			#(numberFormat((score * 100), 000) + 0)#% -
			<a href="#pageShowRoot(title)#.cfm">#replaceNoCase(title, "_", " ", "all")# </a><br/>
			#printDate(custom1)# #printTime(custom1)#<br/>
			#XMLFormat(summary)#
		</li>
	</cfloop>
	</ol>

</cfif>

</cfoutput>

