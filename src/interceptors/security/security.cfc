<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	02/29/2008
Description :
This interceptor is based on the coldbox security interceptor, but for 
permission based systems and local to our application.
----------------------------------------------------------------------->
<cfcomponent name="security"
			 hint="This is a security interceptor"
			 output="false"
			 extends="coldbox.system.interceptor"
			 autowire="true">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="This is the configuration method for your interceptors" output="false" >
		<cfscript>
			/* Start processing properties */
			if( not propertyExists('useRegex') or not isBoolean(getproperty('useRegex')) ){
				setProperty('useRegex',true);
			}
			if( not propertyExists('useRoutes') or not isBoolean(getproperty('useRoutes')) ){
				setProperty('useRoutes',false);
			}
			if( not propertyExists('debugMode') or not isBoolean(getproperty('debugMode')) ){
				setProperty('debugMode',false);
			}

			/* Create the internal properties now */
			setProperty('rules',Arraynew(1));
			setProperty('rulesLoaded',false);
		</cfscript>
	</cffunction>

<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->

	<!--- After Aspects Load --->
	<cffunction name="afterAspectsLoad" access="public" returntype="void" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="event" 		 required="true" type="coldbox.system.beans.requestContext" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<!--- ************************************************************* --->
		<cfscript>
			/* Load Rules */
			loadIOCRules(); 
		</cfscript>
	</cffunction>
	
	<!--- pre-process --->
	<cffunction name="preProcess" access="public" returntype="void" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="event" 		 required="true" type="coldbox.system.beans.requestContext" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<!--- ************************************************************* --->
		<cfscript>
			var rules = getProperty('rules');
			var rulesLen = arrayLen(rules);
			var x = 1;
			var currentEvent = event.getCurrentEvent();
			
			/* Loop through Rules */
			for(x=1; x lte rulesLen; x=x+1){
				/* is current event in this whitelist pattern? then continue to next rule */
				if( isEventInPattern(currentEvent,rules[x].whitelist) ){
					if( getProperty('debugMode') ){
						getPlugin("logger").logEntry("information","#currentEvent# found in whitelist: #rules[x].whitelist#");
					}
					continue;
				}
				/* is currentEvent in the secure list and is user in role */
				if( isEventInPattern(currentEvent,rules[x].securelist) ){
					/* Verify if user is logged in and in permission */	
					if( _isUserInPermission(rules[x].permissions) eq false ){
						/* Log if Necessary */
						if( getProperty('debugMode') ){
							getPlugin("logger").logEntry("warning","User not in appropriate permissions #rules[x].permissions# for event=#currentEvent#");
						}
						/* Redirect */
						if( getProperty('useRoutes') ) 
							setNextRoute(rules[x].redirect);
						else 
							setNextEvent(rules[x].redirect);
						break;
					}//end user in roles
					else{
						if( getProperty('debugMode') ){
							//User is in role. continue.
							getPlugin("logger").logEntry("information","Secure event=#currentEvent# matched and user is in permissions=#rules[x].permissions#. Proceeding");
						}
						break;
					}
				}//end if current event did not match a secure event.
				else{
					if( getProperty('debugMode') ){
						getPlugin("logger").logEntry("information","#currentEvent# Did not match this rule: #rules[x].toString()#");
					}
				}							
			}//end of rules checks
		</cfscript>
	</cffunction>
	
	<!--- Security Service --->
	<cffunction name="setSecurityService" access="public" returntype="void" output="false">
		<cfargument name="SecurityService" type="codex.model.security.SecurityService" required="true">
		<cfset instance.SecurityService = arguments.SecurityService />
	</cffunction>
	<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
		<cfreturn instance.SecurityService />
	</cffunction>
	
<!------------------------------------------- PRIVATE METHDOS ------------------------------------------->
	
	<!--- isEventInPattern --->
	<cffunction name="_isUserInPermission" access="private" returntype="boolean" output="false" hint="Verifies that the user is in any permission">
		<!--- ************************************************************* --->
		<cfargument name="permissionsList" 	required="true" type="string" hint="The permissionsList list needed to match.">
		<!--- ************************************************************* --->
		<cfset var thisPermission = "">
		<cfset var oUser = getSecurityService().getUserSession().getPermissions()>
		
		<!--- Loop Over Permissions --->
		<cfloop list="#arguments.permissionsList#" index="thisPermission">
			<cfif oUser.getPermission( thisPermission ) >
				<cfreturn true>
			</cfif>
		</cfloop>
			
		<cfreturn false>	
	</cffunction>
	
	<!--- isEventInPattern --->
	<cffunction name="isEventInPattern" access="private" returntype="boolean" output="false" hint="Verifies that the current event is in a given pattern list">
		<!--- ************************************************************* --->
		<cfargument name="currentEvent" 	required="true" type="string" hint="The current event.">
		<cfargument name="patternList" 		required="true" type="string" hint="The list to test.">
		<!--- ************************************************************* --->
		<cfset var pattern = "">
		<!--- Loop Over Patterns --->
		<cfloop list="#arguments.patternList#" index="pattern">
			<!--- Using Regex --->
			<cfif getProperty('useRegex')>
				<cfif reFindNocase(pattern,arguments.currentEvent)>
					<cfreturn true>
				</cfif>
			<cfelseif FindNocase(pattern,arguments.currentEvent)>
					<cfreturn true>
			</cfif>	
		</cfloop>	
		<cfreturn false>	
	</cffunction>
		
	<!--- Load IOC Rules --->
	<cffunction name="loadIOCRules" access="private" returntype="void" output="false" hint="Load rules from an IOC bean">
		<cfset var qRules = "">
		<cfset var bean = "">
		
		<!--- Get rules from IOC Container --->
		<cfset bean = getPlugin("ioc").getBean(getproperty('rulesBean'))>
		
		<cfif propertyExists('rulesBeanArgs') and len(getProperty('rulesBeanArgs'))>
			<cfset qRules = evaluate("bean.#getproperty('rulesBeanMethod')#( #getProperty('rulesBeanArgs')# )")>
		<cfelse>
			<!--- Now call method on it --->
			<cfinvoke component="#bean#" method="#getProperty('rulesBeanMethod')#" returnvariable="qRules" />
		</cfif>
		
		<!--- validate query --->
		<cfset validateRulesQuery(qRules)>
		
		<!--- let's setup the array of struct Rules now --->
		<cfset setProperty('rules', queryToArray(qRules))>
		<cfset setProperty('rulesLoaded',true)>
	</cffunction>
	
	<!--- ValidateRules Query --->
	<cffunction name="validateRulesQuery" access="private" returntype="void" output="false" hint="Validate a query as a rules query, else throw error.">
		<!--- ************************************************************* --->
		<cfargument name="qRules" type="query" required="true" hint="The query to check">
		<!--- ************************************************************* --->
		<cfset var validColumns = "whitelist,securelist,permissions,redirect">
		<cfset var col = "">
		<!--- Validate Query --->
		<cfloop list="#validColumns#" index="col">
			<cfif not listfindnocase(arguments.qRules.columnlist,col)>
				<cfthrow message="The required column: #col# was not found in the rules query" type="interceptors.security.invalidRuleQuery">
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- queryToArray --->
	<cffunction name="queryToArray" access="private" returntype="array" output="false" hint="Convert a rules query to our array format">
		<!--- ************************************************************* --->
		<cfargument name="qRules" type="query" required="true" hint="The query to convert">
		<!--- ************************************************************* --->
		<cfscript>
			var x =1;
			var node = "";
			var rtnArray = ArrayNew(1);
			
			/* Loop over Rules */
			for(x=1; x lte qRules.recordcount; x=x+1){
				node = structnew();
				node.whitelist = qRules.whitelist[x];
				node.securelist = qRules.securelist[x];
				node.permissions = qRules.permissions[x];
				node.redirect = qRules.redirect[x];
				ArrayAppend(rtnArray,node);
			}
			/* reutnr array */
			return rtnArray;
		</cfscript>
	</cffunction>
	

</cfcomponent>