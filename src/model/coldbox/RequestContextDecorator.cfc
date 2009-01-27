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
<cfcomponent name="RequestContextDecorator" output="false" extends="coldbox.system.beans.requestContextDecorator">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->
	
	<cffunction name="Configure" access="public" returntype="void" hint="My Configuration" output="false" >
		<cfscript>
			/* Setup Rewrite Flag to build Links */
			instance.usingRewrite = getController().getSetting("usingRewrite");
		</cfscript>
	</cffunction>	
	
	
<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<cffunction name="buildLink" access="public" output="false" returntype="any" hint="Builds a link to a passed event, either SES or normal link. If the ses interceptor is declared it will create routes.">
		<!--- ************************************************************* --->
		<cfargument name="linkto" 		required="true" 	type="string"  hint="The event or route you want to create the link to">
	    <cfargument name="translate"  	required="false" 	type="boolean" default="true" hint="Translate between . and / depending on the ses mode. So you can just use dot notation."/>
	    <cfargument name="ssl" 			required="false"    type="boolean" default="false" hint="If true, it will change http to https if found in the ses base url."/>
	    <cfargument name="baseURL" 		required="false" 	type="string"  default="" hint="If not using SES, you can use this argument to create your own base url apart from the default of index.cfm. Example: https://mysample.com/index.cfm"/>
	    <cfargument name="override" 	required="false" 	type="boolean" default="false" hint="Return with no extension, no matter what state">
	    <!--- ************************************************************* --->
		<cfscript>
			/* Determine rewrite mode */
			if( instance.usingRewrite or arguments.override){
				/* Return normal link Creation */
				return getrequestContext().buildLink(argumentCollection=arguments);
			}
			else{
				/* Using onMissingTemplate method(). append .cfm */
				return getrequestContext().buildLink(argumentCollection=arguments) & ".cfm";
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getRewriteExtension" access="public" returntype="any" hint="Get the rewrite extension used" output="false" >
		<cfif instance.usingRewrite>
			<cfreturn "">
		<cfelse>
			<cfreturn ".cfm">
		</cfif>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>