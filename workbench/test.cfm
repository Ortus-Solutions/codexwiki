<cfscript>
	helpsql = fileRead(expandPath('sql/0.5/assets/helpcontent.sql'));
	split = "INSERT INTO";
	helpstatements = helpsql.split(split);
</cfscript>
<cfloop array="#helpstatements#" index="statement">
	<cfif statement.startsWith(' `wiki_pagecontent`')>

		<cfset statement = rereplace(statement, ";[\s]*$", "") />

		<cfsavecontent variable="temp">
			<cfoutput>
			#split#
			#PreserveSingleQuotes(statement)#
			</cfoutput>
		</cfsavecontent>
		<cfdump var="#temp#">
	<cfelse>
		<p>
			<cfoutput><strong>Statement ignored:</strong> [#statement#];</cfoutput>
		</p>
	</cfif>
</cfloop>