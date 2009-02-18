<cfquery name="qNamespace" datasource="codex">
UPDATE `wiki_namespace`
SET `namespace_createddate` = '#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:mm:ss")#'
</cfquery>