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
<cfcomponent name="Timestamp" 
			 hint="A Timestamp wiki plugin" 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Timestamp" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Timestamp");
  		setpluginVersion("1.0");
  		setpluginDescription("A time stamp wiki plugin");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.coldbox.org");
  		setPluginURL("http://www.codexwiki.org");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today's date and time in a specific format">
		<cfargument name="format" type="string" required="true" default="full" hint="Full,Short, Medium"/>
		<cfargument name="noTime" type="boolean" required="false" default="false" hint="Flag to print also the time or not"/>
		<Cfif arguments.noTime>
			<cfreturn dateformat(now(),arguments.format)>
		<cfelse>
			<cfreturn dateformat(now(),arguments.format) & " " & timeFormat(now(),arguments.format)>
		</cfif>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>