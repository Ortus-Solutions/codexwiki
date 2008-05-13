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
<cfcomponent name="baseHandler" extends="coldbox.system.eventhandler" output="false" hint="This is our main base handler" autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

	<cffunction name="setNextRoute" access="package" returntype="void" hint="Relocate to the next wiki page" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="route"  	hint="The route to relocate to, do not prepend the baseURL or /." type="string" required="yes" >
		<cfargument name="persist" 	hint="What request collection keys to persist in the relocation" required="false" type="string" default="">
		<cfargument name="qs"  		hint="The query string to append" type="string" required="false" default="" >
		
		<!--- ************************************************************* --->
		<cfset var newRoute = arguments.route & ".cfm">
		<cfif len(qs)>
			<cfset newRoute = newRoute & "?" & arguments.qs>
		</cfif>
		<cfset getController().setNextRoute(route=newRoute,persist=arguments.persist)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>