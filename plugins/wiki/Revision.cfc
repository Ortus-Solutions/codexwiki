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
<cfcomponent name="Revision" 
			 hint="A revision wiki plugin that tells you revision information about the current displayed page" 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="false">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Revision" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		
  		setpluginName("Revision");
  		setpluginVersion("1.0");
  		setpluginDescription("A revision wiki plugin that tells you revision information about the current displayed page");
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
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="A revision wiki plugin that tells you revision information about the current displayed page">
		<cfargument name="format"  type="string" required="true" default="full" hint="The revision information type to render: full, medium, short, timestamp-full or timestamp, timestamp-medium, timestamp-short, useronly"/>
		<cfargument name="content" type="codex.model.wiki.Content" required="true" hint="This argument is passed automatically by codex, DO NOT PASS THIS."/>
		<cfscript>
			var userInfo = "N/A"; 
			
			//Do we have a user
			if( arguments.content.hasUser() ){
				userInfo = arguments.content.getUser().getFullName();	
			}			
			if( arguments.format eq "full" ){
				return "Last edited by #userInfo# on #dateFormat(content.getCreatedDate(),"full")# at #timeformat(content.getCreatedDate(),"full")#";
			}
			if( arguments.format eq "medium" ){
				return "Last edited by #userInfo# on #dateFormat(content.getCreatedDate(),"medium")# at #timeformat(content.getCreatedDate(),"medium")#";
			}
			if( arguments.format eq "short" ){
				return "Last edited by #userInfo# on #dateFormat(content.getCreatedDate(),"short")# at #timeformat(content.getCreatedDate(),"short")#";
			}
			if( arguments.format eq "timestamp" or arguments.format eq "timestamp-full" ){
				return "Last edited on #dateFormat(content.getCreatedDate(),"full")# at #timeformat(content.getCreatedDate(),"full")#";	
			}
			if( arguments.format eq "timestamp-medium" ){
				return "Last edited on #dateFormat(content.getCreatedDate(),"medium")# at #timeformat(content.getCreatedDate(),"medium")#";	
			}
			if( arguments.format eq "timestamp-short" ){
				return "Last edited on #dateFormat(content.getCreatedDate(),"short")# at #timeformat(content.getCreatedDate(),"short")#";	
			}
			if( arguments.format eq "useronly" ){
				return "Last edited by #userInfo#";
			}
			
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>