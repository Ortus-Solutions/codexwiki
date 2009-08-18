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
<cfcomponent name="util" 
			 hint="A utility plugin" 
			 extends="coldbox.system.plugin" 
			 output="false"
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Avatar" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		
  		setpluginName("util");
  		setpluginVersion("1.0");
  		setpluginDescription("A global utility plugin");
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

	<!--- activateURL --->
	<cffunction name="activateURL" output="false" access="public" returntype="any" hint="Activate URL's">
		<cfargument name="text" type="string">
		<cfreturn REReplaceNoCase(arguments.text, "((https?|ftp):\/\/)([^\s]*)\s?","<a href=""\1\3"">\1\3</a> ", "ALL")>
	</cffunction>
    
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>