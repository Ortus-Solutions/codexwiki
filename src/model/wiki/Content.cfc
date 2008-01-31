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

<cffunction name="populate" hint="processes the form details" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="takes a memento" type="struct" required="Yes">
	<cfscript>
		getBeanPopulator().populate(this, arguments.memento);
		setPageName(arguments.memento.pageName);
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders the page content" access="public" returntype="string" output="false">
	<cfscript>
		if(NOT hasRenderedContent())
		{
			translate();
		}

		return getRenderedContent();
	</cfscript>
</cffunction>

<cffunction name="setContent" hint="sets the value of the content, clears the rendered content" access="public" returntype="void" output="false">
	<cfargument name="content" hint="the content" type="string" required="Yes">
	<cfscript>
		getTransferObject().setContent(arguments.content);

		if(getIsDirty())
		{
			clearRenderedContent();
			translate(true);
		}
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

<cffunction name="setInterceptorService" access="public" returntype="void" output="false">
	<cfargument name="interceptorService" type="coldbox.system.services.interceptorService" required="true">
	<cfset instance.interceptorService = arguments.interceptorService />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="translate" hint="translates the wiki page content" access="public" returntype="string" output="false">
	<cfargument name="setCategories" hint="whether or not to set the page categories from the parsed markup" type="boolean" required="No" default="false">
	<cfscript>
		var data = 0;
		var category = 0;
		var counter = 1;
		var len = 0;
	</cfscript>
	<cfif NOT hasRenderedContent()>
		<cflock name="codex.wiki.content.render.#getContentID()#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT hasRenderedContent())
			{
				data = StructNew();
				data.content = getContent();
				getInterceptorService().processState("onWikiPageTranslate",data);
				setRenderedContent(data.content);

				if(arguments.setCategories AND StructKeyExists(data, "categories"))
				{
					clearCategory();

					len = ArrayLen(data.categories);
					for(; counter <= len; counter++)
					{
						category = getWikiService().getCategory(categoryName=data.categories[counter]);
						addCategory(category);
					}
				}
			}
		</cfscript>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="getRenderedContent" access="private" returntype="string" output="false">
	<cfreturn instance.renderedContent />
</cffunction>

<cffunction name="setRenderedContent" access="private" returntype="void" output="false">
	<cfargument name="renderedContent" type="string" required="true">
	<cfset instance.renderedContent = arguments.RenderedContent />
</cffunction>

<cffunction name="clearRenderedContent" hint="clears the rendered Content" access="private" returntype="void" output="false">
	<cfset StructDelete(instance, "renderedContent") />
</cffunction>

<cffunction name="hasRenderedContent" hint="clears the rendered Content" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "renderedContent") />
</cffunction>

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

<cffunction name="getInterceptorService" access="private" returntype="coldbox.system.services.interceptorService" output="false">
	<cfreturn instance.interceptorService />
</cffunction>

</cfcomponent>