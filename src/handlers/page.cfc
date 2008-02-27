<cfcomponent name="page"
			 extends="baseHandler"
			 output="false"
			 hint="This is our main page handler"
			 autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" access="public" returntype="page" output="false">
	<cfargument name="controller" type="any" required="yes">
	<cfscript>
		super.init(arguments.controller);

		return this;
	</cfscript>
</cffunction>

<cffunction name="show" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = 0;

		//default page is the dashboard
		arguments.event.paramValue("page", getSetting('DefaultPage') );

		arguments.event.setValue("cssAppendList", "uni-form,wiki.show");

		content = getWikiService().getContent(pageName=arguments.event.getValue("page"));
		arguments.event.setValue("content", content);
		arguments.event.setValue("onEditWiki","page/manage");
		arguments.event.setValue("onCreateWiki","page/manage");
		arguments.event.setValue("onDeleteWiki","page/delete");

		/* Set views according to persistance */
		if(content.getIsPersisted())
		{
			arguments.event.setView("wiki/show");
		}
		else
		{
			arguments.event.setView("wiki/create");
		}
	</cfscript>
</cffunction>

<cffunction name="manage" hint="manage a wiki page" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = getWikiService().getContent(pageName=arguments.event.getValue("page"));
		arguments.event.setValue("content", content);
		arguments.event.setValue("cssAppendList", "uni-form");

		arguments.event.setValue("onSubmit","page/process");
		arguments.event.setValue("onCancel","wiki");

		arguments.event.setView("wiki/manage");
	</cfscript>
</cffunction>

<cffunction name="process" hint="processes the wiki details" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		/*
		var content = getWikiService().getContent(contentid=arguments.event.getValue("contentid", ""));

		if(content.getIsPersisted())
		{
			content.setIsActive(false);
			getWikiService().saveContent(content);
			content = getWikiService().getContent();
			content.setPage(content.getPage());
		}

		content.populate(arguments.event.getCollection());
		*/
		var pageName = arguments.event.getValue("pageName");
		var page = getWikiService().getPage(pageName=pageName);

		page.addContentVersion(arguments.event.getCollection());

		//TODO: may want to validate here later, once a decision has been made on validation

		//getWikiService().saveContent(content);

		//make the page have the right URL
		setNextRoute(route="wiki/" & pageName, persist="page");
	</cfscript>
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