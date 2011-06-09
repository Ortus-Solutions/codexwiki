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
<cfcomponent name="DataManager" output="false" hint="This service manages all import/export objects">

	<cfscript>
		instance = structnew();
	</cfscript>
	
	<!--- Constructor --->
	<cffunction name="init" access="public" returntype="DataManager" hint="construtor" output="false">
		<cfargument name="ConfigService" type="codex.model.wiki.ConfigService" 		required="true" hint="The config service">
		<cfargument name="beanInjector"  type="any" required="true" hint="the bean injector">
		<cfscript>
			
			return this;
		</cfscript>
	</cffunction>


</cfcomponent>