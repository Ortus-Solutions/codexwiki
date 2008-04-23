<!--- search output --->

<cfoutput>
<!--- Title --->

<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/magnifier.png" align="absmiddle"> Search: #event.getValue("search_query", "")#
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
			<a href="#pageShowRoot()##title#.cfm">#replaceNoCase(title, "_", " ", "all")# </a><br/>
			#printDate(custom1)# #printTime(custom1)#<br/>
			#XMLFormat(summary)#
		</li>
	</cfloop>
	</ol>

</cfif>

</cfoutput>

