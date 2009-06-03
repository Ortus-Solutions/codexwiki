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
<cfoutput>
	<!--- Global or per Page Metadata --->
	<cfif event.valueExists("content") AND len(rc.content.getPage().getDescription())>
		<meta name="description" content="#rc.content.getPage().getDescription()#" />
	<cfelse>
		<meta name="description" content="#rc.CodexOptions.wiki_metadata#" />
	</cfif>
	<!--- Global or per Page KeyWords --->
	<cfif event.valueExists("content") AND len(rc.content.getPage().getKeywords())>
		<meta name="keywords" content="#rc.content.getPage().getKeywords()#" />
	<cfelse>
		<meta name="keywords" content="#rc.CodexOptions.wiki_metadata_keywords#" />
	</cfif>
</cfoutput>