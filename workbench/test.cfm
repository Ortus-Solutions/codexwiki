<cfset namespace = "3-1-Functions,3-1-Tags">

<!--- Get all pages to delete --->
<cfquery name="qPages" datasource="codex" >
SELECT a.page_id
FROM wiki_page a, wiki_namespace b
WHERE a.FKnamespace_id = b.namespace_id AND
	  b.namespace_name IN ( <cfqueryparam value="#namespace#" list="true" cfsqltype="cf_sql_varchar"> )
</cfquery>
<cfset idList = valueList(qPages.page_id)>
<cfif listLen(idList)>
<!--- Remove ALL pagecontent categories First --->
<cfquery name="qDelete" datasource="codex" >
	DELETE FROM
		wiki_pagecontent_category
	WHERE
	FKpagecontent_id IN
		(
			SELECT
				wiki_pagecontent.pagecontent_id
			FROM
				wiki_pagecontent
			WHERE
				FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">)
		)
</cfquery>
<!--- Remove All wiki page content --->
<cfquery name="qDelete" datasource="codex" >
	DELETE FROM
		wiki_pagecontent
	WHERE
		(FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
</cfquery>
<cftry>
<!--- Remove All wiki page comments --->
<cfquery name="qDelete" datasource="codex" >
	DELETE FROM
		wiki_comments
	WHERE
		(FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
</cfquery>
<cfcatch type="any"></cfcatch>
</cftry>
<!--- Remove the Actual Pages --->
<cfquery name="qDelete" datasource="codex" >
	DELETE FROM
		wiki_page
	WHERE
	(page_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#idList#">))
</cfquery>
<!--- Remove the Namespace --->
<cfquery name="qDelete" datasource="codex" >
	DELETE FROM
		wiki_namespace
	WHERE
	namespace_name  IN ( <cfqueryparam value="#namespace#" list="true" cfsqltype="cf_sql_varchar"> )
</cfquery>

</cfif>

Done...