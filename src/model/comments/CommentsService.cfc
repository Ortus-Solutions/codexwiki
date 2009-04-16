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
<cfcomponent hint="The Wiki Commenting layer" output="false" extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiService" output="false">
	<cfargument name="transfer" 		hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
	<cfargument name="datasource" 		hint="the datasource bean" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="transaction" 		hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
	<cfargument name="securityService" 	hint="the security service" type="codex.model.security.SecurityService" required="Yes">
	<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfscript>
		/* Init */
		super.init(argumentCollection=arguments);
		
		/* Properties */
		setSecurityService(arguments.securityService);
		
		/* Return */
		return this;
	</cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


<cffunction name="getSecurityService" access="private" returntype="codex.model.security.SecurityService" output="false">
	<cfreturn instance.securityService />
</cffunction>

<cffunction name="setSecurityService" access="private" returntype="void" output="false">
	<cfargument name="securityService" type="codex.model.security.SecurityService" required="true">
	<cfset instance.securityService = arguments.securityService />
</cffunction>


</cfcomponent>
