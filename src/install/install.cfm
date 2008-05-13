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
