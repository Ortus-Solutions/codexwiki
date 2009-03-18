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
<cfcomponent name="ConfigService"
			 hint="The Config Service layer for all configuration related options" 
			 output="false" 
			 extends="codex.model.baseobjects.BaseService">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- Init --->
	<cffunction name="init" hint="Constructor" access="public" returntype="ConfigService" output="false">
		<cfargument name="transfer"    hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
		<cfargument name="transaction" hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
		<cfargument name="configBean"  hint="the configuration beam" type="coldbox.system.beans.configBean" required="Yes">
		<cfscript>
			/* Init */
			super.init(argumentCollection=arguments);
			/* Save config Bea */
			instance.configBean = arguments.configBean;
			
			return this;
		</cfscript>
	</cffunction>

	<!--- getCustomHTML --->
	<cffunction name="getCustomHTML" output="false" access="public" returntype="codex.model.wiki.CustomHTML" hint="Get the custom HTML">
		<cfscript>
		var tql = 0;
		var query = 0;
		var customHTML = 0;
		</cfscript>
		<cfsavecontent variable="tql">
		<cfoutput>
			from wiki.CustomHTML
		</cfoutput>
		</cfsavecontent>
		<cfscript>
			query = getTransfer().createQuery(tql);
			query.setCacheEvaluation(true);
			customHTML = getTransfer().readByQuery("wiki.CustomHTML", query);

			return customHTML;
		</cfscript>
	</cffunction>

	<!--- Save Custom HTML --->
	<cffunction name="saveCustomHTML" hint="Saves the custom HTML" access="public" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="customHTML" hint="The customHTML object" type="codex.model.wiki.CustomHTML" required="Yes">
		<!--- ************************************************************* --->
		<cfscript>
			arguments.customHTML.setModifyDate(now());
			getTransfer().save(arguments.customHTML);
		</cfscript>
	</cffunction>
	
	<!--- getOptions --->
	<cffunction name="getOptions" output="false" access="public" returntype="struct" hint="Get all the wiki options as a structure">
		<!--- ************************************************************* --->
		<cfargument name="returnFormat" type="string" required="false" default="struct" hint="The return format of the results: struct or query"/>
		<!--- ************************************************************* --->
		<cfscript>
			var qOptions = 0;
			var x=1;
			var rtnStruct = structnew();
			
			/* Get Options */
			qOptions = getTransfer().list('wiki.Option');
			
			/* Query Format? */
			if( arguments.returnFormat eq "query" ){ return qOptions; }
			
			/* Convert To Struct */
			for(x=1; x lte qOptions.recordcount; x+=1){
				rtnStruct[qOptions.name[x]] = qOptions.value[x];
			}
			/* Return */
			return rtnStruct;
		</cfscript>
	</cffunction>
	
	<!--- Get Option --->
	<cffunction name="getOption" output="false" access="public" returntype="codex.model.wiki.Option" hint="Returns to you a specific wiki option.">
		<!--- ************************************************************* --->
		<cfargument name="option_id" type="string" required="false" default="" hint="Option id"/>
		<cfargument name="name" 	 type="string" required="false" default="" hint="Option name"/>
		<!--- ************************************************************* --->
		<cfscript>
			var oOption = "";
			var sqlProps = structnew();
	
			/* prepare sqlProps */
			if( len(arguments.option_id) ){
				sqlProps.option_id = arguments.option_id;
			}
			if( len(arguments.name) ){
				sqlProps.name = arguments.name;
			}
			
			/* Get user now. */
			oOption = getTransfer().readByPropertyMap('wiki.Option', sqlProps);
						
			return oOption;
		</cfscript>
	</cffunction>

	<!--- Get the application's config Bean --->
	<cffunction name="getConfigBean" access="public" output="false" returntype="coldbox.system.beans.configBean" hint="Get configBean">
		<cfreturn instance.configBean/>
	</cffunction>
	
	<!--- Get Setting --->
	<cffunction name="getSetting" access="public" returntype="any" hint="Get an application setting from the config bean. If the setting does not exists, then _NONE_ will be returned." output="false" >
		<!--- ************************************************************* --->
		<cfargument name="key"	 			type="string" required="true" hint="The named key to return.">
		<cfargument name="defaultValue" 	type="any" required="false" default="_NONE_" hint="A default value to return"/>
		<!--- ************************************************************* --->
		<cfreturn getConfigBean().getKey(argumentcollection=arguments)>
	</cffunction>
	
	<!--- Setting Exists --->
	<cffunction name="settingExists" access="public" returntype="any" output="false" hint="Check if a setting exists in the structure.">
		<!--- ************************************************************* --->
		<cfargument name="key" type="string" required="true">
		<!--- ************************************************************* --->
		<cfreturn getConfigBean().keyExists(argumentCollection=arguments)>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>