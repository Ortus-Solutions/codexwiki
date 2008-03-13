<cfcomponent extends="transfer.com.TransferDecorator" hint="An category for a wiki page" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="createCategoryPage" hint="creates the category special page, if it doesn't exist" access="public" returntype="void" output="false">
	<cfscript>
		var content = getWikiService().getContent(pageName="Category:#getName()#");
		var wikiText = 0;
	</cfscript>

	<cfif NOT content.getIsPersisted()>
		<cfsavecontent variable="wikiText">
		<cfoutput>
== Category: #getName()# ==

All pages under the Category '#getName()#':
<feed url="/feed/page/listByCategory.cfm?category=#getName()#" display="numbered" />
		</cfoutput>
		</cfsavecontent>
		<cfscript>
			content.setContent(wikiText);
			content.setIsActive(true);
			getWikiService().saveContent(content);
		</cfscript>
	</cfif>
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

</cfcomponent>