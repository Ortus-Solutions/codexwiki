<cfcomponent hint="The Config Service layer" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- Init --->
	<cffunction name="init" hint="Constructor" access="public" returntype="ConfigService" output="false">
		<cfargument name="transfer" hint="the Transfer ORM" type="transfer.com.Transfer" required="Yes">
		<cfargument name="transaction" hint="The Transfer transaction" type="transfer.com.sql.transaction.Transaction" required="Yes">
		<cfscript>
			instance = StructNew();

			setTransfer(arguments.transfer);

			arguments.transaction.advise(this, "^save");

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

<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
		<cfreturn instance.transfer />
	</cffunction>

	<cffunction name="setTransfer" access="private" returntype="void" output="false">
		<cfargument name="transfer" type="transfer.com.Transfer" required="true">
		<cfset instance.transfer = arguments.transfer />
	</cffunction>

</cfcomponent>