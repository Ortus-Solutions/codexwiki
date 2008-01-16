<cfcomponent extends="transfer.com.TransferDecorator" hint="Page Content" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setPageName" hint="sets the page name, if a page does not exist, creates it" access="public" returntype="void" output="false">
	<cfargument name="pageName" hint="the page name" type="string" required="Yes">
	<cfscript>
		var page = 0;
		if(NOT hasPage())
		{
			page = getWikiService().getPage();
			setPage(page);
		}

		getPage().setName(arguments.pageName);
	</cfscript>
</cffunction>

<cffunction name="processForm" hint="processes the form details" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="takes a memento" type="struct" required="Yes">
	<cfscript>
		getBeanPopulator().populate(this, arguments.memento);
		setPageName(arguments.memento.pageName);
	</cfscript>
</cffunction>

<cffunction name="setBeanPopulator" access="public" returntype="void" output="false">
	<cfargument name="beanPopulator" type="codex.model.transfer.BeanPopulator" required="true">
	<cfset instance.beanPopulator = arguments.beanPopulator />
</cffunction>

<cffunction name="setWikiService" access="public" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="configure" hint="initial setup" access="public" returntype="string" output="false">
	<cfscript>
		setVersion(1);
		setIsActive(true);
	</cfscript>
</cffunction>

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

<cffunction name="getBeanPopulator" access="private" returntype="codex.model.transfer.BeanPopulator" output="false">
	<cfreturn instance.beanPopulator />
</cffunction>

</cfcomponent>