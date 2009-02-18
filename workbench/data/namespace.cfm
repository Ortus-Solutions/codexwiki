<cfset namespace = "Help">
<cfset export = {}>

<!--- Get Namespace Record First --->
<cfquery name="export.namespace" datasource="#request.dsn#">
select *
from wiki_namespace WHERE namespace_name = '#namespace#'
</cfquery>
<!--- Get All Pages First --->
<cfquery name="export.pages" datasource="#request.dsn#">
select *
from wiki_page where FKnamespace_id = '#export.namespace.namespace_id#'
</cfquery>
<!--- Get All The Page Content --->
<cfquery name="export.pagecontent" datasource="#request.dsn#">
select *
from wiki_pagecontent 
where FKpage_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valuelist(export.pages.page_id)#">) 
</cfquery>
<!--- Get All the Page Content Categories --->
<cfquery name="export.pagecontentcategories" datasource="#request.dsn#">
select *
from wiki_pagecontent_category
where FKpagecontent_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valuelist(export.pagecontent.pagecontent_id)#">) 
</cfquery>
<!--- Get All the Categories --->
<cfquery name="export.categories" datasource="#request.dsn#">
select *
from wiki_category
where category_id 
IN (
<cfif export.pagecontentcategories.recordcount>
	<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valuelist(export.pagecontentcategories.FKcategory_id)#">
<cfelse>
''
</cfif>
) 
</cfquery>

<cfdump var="#export#">