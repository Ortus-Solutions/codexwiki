<cfcomponent output="false">
<cfscript>
	this.name = "MigrationsCodex-" & hash(getCurrentTemplatePath());
</cfscript>
</cfcomponent>