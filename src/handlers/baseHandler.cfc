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
	
	<!--- Set Next Route --->
	<cffunction name="setNextRoute" access="Public" returntype="void" hint="I Set the next ses route to relocate to. This method pre-pends the baseURL"  output="false">
		<!--- ************************************************************* --->
		<cfargument name="route"  		required="yes" 	 type="string" hint="The route to relocate to, do not prepend the baseURL or /.">
		<cfargument name="persist" 		required="false" type="string" default="" hint="What request collection keys to persist in the relocation">
		<cfargument name="varStruct" 	required="false" type="struct" hint="A structure key-value pairs to persist.">
		<cfargument name="addToken"		required="false" type="boolean" default="false"	hint="Wether to add the tokens or not. Default is false">
		<cfargument name="suffix" 		type="string" 	required="true" default="" hint="String to append after .cfm"/>
		<!--- ************************************************************* --->
		<cfset var event = getController().getRequestService().getContext()>
		<cfset arguments.route = arguments.route & event.getRewriteExtension() & arguments.suffix>
		<cfset getController().setNextRoute(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="setNextEvent" access="Public" returntype="void" hint="I Set the next event to run and relocate the browser to that event. If you are in SES mode, this method will use routing instead"  output="false">
		<!--- ************************************************************* --->
		<cfargument name="event"  			type="string"  required="false" default="#getSetting("DefaultEvent")#" hint="The name of the event to run.">
		<cfargument name="queryString"  	type="string"  required="false" default="" hint="The query string to append, if needed.">
		<cfargument name="addToken"		 	type="boolean" required="false" default="false"	hint="Whether to add the tokens or not. Default is false">
		<cfargument name="persist" 			type="string"  required="false" default="" hint="What request collection keys to persist in the relocation">
		<cfargument name="varStruct" 		type="struct"  required="false" default="#structNew()#" hint="A structure key-value pairs to persist.">
		<!--- ************************************************************* --->
		<cfset var _event = getController().getRequestService().getContext()>
		
		<cfif len(arguments.queryString)>
			<cfset arguments.queryString = arguments.queryString & _event.getRewriteExtension()>
		<cfelse>
			<cfset arguments.event = arguments.event & _event.getRewriteExtension()>
		</cfif>
		<cfset getController().setNextEvent(argumentCollection=arguments)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- Throw Facade --->
	<cffunction name="$throw" access="private" hint="Facade for cfthrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="message" 	type="string" 	required="yes">
		<cfargument name="detail" 	type="string" 	required="no" default="">
		<cfargument name="type"  	type="string" 	required="no" default="Framework">
		<!--- ************************************************************* --->
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#">
	</cffunction>

</cfcomponent>