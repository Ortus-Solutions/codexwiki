
<cfscript>
	cbFactory = createObject("component", "coldbox.system.extras.ColdboxFactory");
	config = cbFactory.getConfigBean();
	appName = config.getKey('appName');
	rootPath = cbFactory.getColdBox().getAppRootPath();
	cs = cbFactory.getColdBox().getPlugin("ioc");

	wikiService = cs.getBean("WikiService");

	verityPath = rootpath & "/verity/";

	htmlBaseURL = config.getKey('htmlBaseURL');
</cfscript>

<cfoutput>

<p>
	Deleting verity collection...
</p>
<cfflush>
<cftry>
	<cfcollection action="delete"
				collection="#appName#"
				>

	<cfcatch>
		<p>No verity collection to delete</p>
		<cfflush>
	</cfcatch>
</cftry>


<p>
	Creating verity collection...
</p>
<cfflush>
<cfcollection action="create"
				collection="#appName#"
				path="#verityPath#"
				>


<p>
	Deleting scheduled tasks...
</p>
<cfflush>
<cftry>
	<cfschedule action="delete"
			task="#appName#_searchRefresh"
			>

	<cfcatch>
		<p>No scheduled task to delete</p>
		<cfflush>
	</cfcatch>
</cftry>

<p>
	Setting up the scheduled task...
</p>
<cfflush>

<cfschedule action="update"
			task="#appName#_searchRefresh"
			interval="daily"
			operation="HTTPRequest"
			startDate="#Now()#"
			startTime="03:00 AM"
			url="#htmlBaseURL#/system.task/refreshSearch.cfm"
			>

<p>
	Running the scheduled task...
</p>
<cfflush>

<cfschedule action="run"
		task="#appName#_searchRefresh"
		>

	<p>
	Install complete!
	</p>
</cfoutput>
