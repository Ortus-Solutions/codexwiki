<!-----------------------------------------------------------------------
Template : wiki.cfc
Author 	 : luis5198
Date     : 10/12/2007 2:49:58 PM
Description :
	This is our main wiki handler

Modification History:
10/12/2007 - Created Template
----------------------------------------------------------------------><cfcomponent name="wiki" extends="coldbox.system.eventhandler" output="false" hint="This is our main wiki handler">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" access="public" returntype="wiki" output="false">
	<cfargument name="controller" type="any" required="yes">
	<cfscript>
		super.init(arguments.controller);

		setWikiService(getPlugin("ioc").getBean("WikiService"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="show" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = 0;

		//default page is the dashboard
		arguments.event.paramValue("page", "Dashboard");

		content = getWikiService().getContent(pageName=arguments.event.getValue("page"));
		arguments.event.setValue("content", content);
		arguments.event.setValue("onEditWiki","wiki.manage");
		arguments.event.setValue("onCreateWiki","wiki.manage");
		arguments.event.setValue("onDeleteWiki","wiki.delete");

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

		arguments.event.setValue("onSubmit","wiki.process");
		arguments.event.setValue("onCancel","wiki.show");

		arguments.event.setView("wiki/manage");
	</cfscript>
</cffunction>

<cffunction name="process" hint="processes the wiki detalis" access="public" returntype="void" output="false">
	<cfargument name="event" type="coldbox.system.beans.requestContext">
	<cfscript>
		var content = getWikiService().getContent(contentid=arguments.event.getValue("contentid", ""));

		content.processForm(arguments.event.getCollection());

		//TODO: may want to validate here later, once a decision has been made on validation

		getWikiService().saveContent(content);

		//move the page name to the page, so it can be persisted
		arguments.event.setValue("page", arguments.event.getValue("pageName"));

		setNextEvent(event="wiki.show", persist="page");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setWikiService" access="private" returntype="void" output="false">
	<cfargument name="wikiService" type="codex.model.wiki.WikiService" required="true">
	<cfset instance.wikiService = arguments.wikiService />
</cffunction>

<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
	<cfreturn instance.wikiService />
</cffunction>

</cfcomponent>