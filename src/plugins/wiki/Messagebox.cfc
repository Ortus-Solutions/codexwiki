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
<cfcomponent name="Messagebox" 
			 hint="A messagebox wiki plugin" 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Messagebox" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Messagebox");
  		setpluginVersion("1.0");
  		setpluginDescription("A messagebox plugin. Valid Types are info, warning, error");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.coldbox.org");
  		setPluginURL("http://www.codexwiki.org");
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="This plugin will create a simple messagebox on the page. Look at the output classes so you can skin them.">
		<cfargument name="message"  required="true" type="string" hint="The message to display"/>
		<cfargument name="type" 	required="true" type="string" default="info" hint="The type of messagebox: info, error, warning">
		
		<cfscript>
			var content = "";
			
			/* Header */
			if(arguments.type eq "info"){
				content = '<div class="cbox_messagebox_info"><p class="cbox_messagebox">';
			}
			else if(arguments.type eq "warning"){
				content = '<div class="cbox_messagebox_warning"><p class="cbox_messagebox">';
			}
			else if(arguments.type eq "error"){
				content = '<div class="cbox_messagebox_error"><p class="cbox_messagebox">';
			}
			
			/* Content */
			content = content & arguments.message & "</p></div>";
			
			return content;			
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>