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
		var args = StructNew();

		args.stringBuilder = createObject("java", "java.lang.StringBuilder").init();

		if(NOT hasRenderedContent())
		{
			translate();
		}

		//use a command
		eachRenderable(renderRenderableCommand, args);

		return args.stringBuilder.toString();
	</cfscript>
</cffunction>

<cffunction name="setContent" hint="sets the value of the content, clears the rendered content" access="public" returntype="void" output="false">
	<cfargument name="content" hint="the content" type="string" required="Yes">
	<cfscript>
		getTransferObject().setContent(arguments.content);

		if(getIsDirty())
		{
			clearRenderedContent();
			translate();
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

<cffunction name="visitContent" hint="takes a visitor object and calls 'vistContent' on each of the Content items" access="public" returntype="void" output="false">
	<cfargument name="visitor" hint="the visitor that comes in" type="any" required="Yes">
	<cfargument name="visitData" hint="the struct of visitor data" type="struct" required="Yes">
	<cfargument name="visitDynamicContent" hint="whether or not to visit dyanmic content. Defaults to false." type="boolean" required="No" default="false">
	<cfscript>
		if(hasRenderedContent())
		{
			arguments.content = getRenderedContent();
		}
		else
		{
			/*
			use an array list, as it passes by reference.
			Don't need to synchronise it, as it only ever get's populated by a single thread, and then it is read only
			*/
			arguments.content = createObject("java", "java.util.ArrayList").init();
			ArrayAppend(arguments.content, createObject("component", "codex.model.wiki.parser.renderable.StaticRenderable").init(getContent()));
		}

		eachRenderable(visitContentCommand, arguments, arguments.content);

		setRenderedContent(arguments.content);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="translate" hint="translates the wiki page content" access="public" returntype="string" output="false">
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
				data.content = this;
				getInterceptorService().processState("onWikiPageTranslate",data);

				if(getIsDirty()) //only do this if the content has been changed - i.e. not on populate
				{
					if(StructKeyExists(data, "categories"))
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
			}
		</cfscript>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="eachRenderable" hint="runs a command against each visitor" access="private" returntype="void" output="false">
	<cfargument name="command" hint="a method command" type="any" required="Yes">
	<cfargument name="commandArgs" hint="the comand arguments" type="struct" required="false" default="#StrctNew()#">
	<cfargument name="renderedContent" hint="the rendered content collection" type="array" required="no" default="#getRenderedContent()#">
	<cfscript>
		var len = ArrayLen(arguments.renderedContent);
		var counter = 1;
		var call = arguments.command;

		for(; counter <= len; counter++)
		{
			arguments.commandArgs.renderable = arguments.renderedContent[counter];
			arguments.commandArgs.index = counter;

			//this won't work if it's arguments.command - go figure.
			call(argumentCollection=arguments.commandArgs);
		}
	</cfscript>
</cffunction>

<!--- Commands --->

<cffunction name="renderRenderableCommand" hint="a commnd for displaying a renderable item" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="a renderable object" type="any" required="Yes">
	<cfargument name="stringBuilder" hint="the string builder to build this from" type="any" required="Yes">
	<cfscript>
		arguments.stringBuilder.append(arguments.renderable.render());
	</cfscript>
</cffunction>

<cffunction name="visitContentCommand" hint="a command to enable visitors to visit each renderable item" access="public" returntype="string" output="false">
	<cfargument name="renderable" hint="a renderable object" type="any" required="Yes">
	<cfargument name="content" hint="the array of renderable content" type="array" required="Yes">
	<cfargument name="index" hint="the index of the current item we are at" type="numeric" required="Yes">
	<cfargument name="visitor" hint="the visitor that comes in" type="any" required="Yes">
	<cfargument name="visitData" hint="the struct of visitor data" type="struct" required="Yes">
	<cfargument name="visitDynamicContent" hint="whether or not to visit dyanmic content. Defaults to false." type="boolean" required="No" default="false">
	<cfscript>
		//use local, as may return null
		var local = StructNew();

		//if you can visit dynamic content, then visit it, otherwise, ignore it
		if(NOT arguments.renderable.getIsDynamic() OR visitDynamicContent == true)
		{
			local.returnVar = arguments.visitor.visitRenderable(arguments.renderable, arguments.visitData);

			if(StructKeyExists(local, "returnVar"))
			{
				//if an object replace
				if(isObject(local.returnVar))
				{
					arguments.content[arguments.index] = local.returnVar;
				}
				else if(isArray(local.returnVar)) //if an array, repace that item with the array contents
				{
					arguments.content.addAll(index, local.returnVar);
					ArrayDeleteAt(arguments.content, index);
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="getRenderedContent" access="private" returntype="array" output="false">
	<cfreturn instance.renderedContent />
</cffunction>

<cffunction name="setRenderedContent" access="private" returntype="void" output="false">
	<cfargument name="renderedContent" type="array" required="true">
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