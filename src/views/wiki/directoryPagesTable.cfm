<cfoutput>
<table id="wikiPagesTable" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>Page Name</th>
			<th width="100">Namespace</th>
		</tr>
	</thead>
	<tbody>
	<cfloop query="rc.qPages">
		<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
			<td><a href="#pageShowRoot(name)#.cfm">#name#</a></td>
			<td>#namespace#</td>
		</tr>
	</cfloop>
	</tbody>	
</table>
</cfoutput>