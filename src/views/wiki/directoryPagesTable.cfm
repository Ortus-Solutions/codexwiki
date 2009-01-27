<cfoutput>
<table id="wikiPagesTable" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>Page Name</th>
			<th width="175">Namespace</th>
		</tr>
	</thead>
	<tbody>
	<cfloop query="rc.qPages">
		<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
			<td><a href="#event.buildLink(pageShowRoot(name))#">#name#</a></td>
			<td><cfif len(namespace)>#namespace#<cfelse>#namespaceDescription#</cfif></td>
		</tr>
	</cfloop>
	</tbody>	
</table>
</cfoutput>