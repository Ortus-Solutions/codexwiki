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
<cfcomponent extends="transfer.com.TransferDecorator" hint="Page Content, autowired by bean injector" output="false">

<!------------------------------------------- DEPENDENCIES ------------------------------------------->

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

<!------------------------------------------- PUBLIC ------------------------------------------->

<!--- checkCategory --->
<cffunction name="checkCategory" output="false" access="public" returntype="boolean" hint="Checks if the sent in category exists in this content object">
	<cfargument name="categoryID" type="string" required="true" hint="The category id to check"/>
	<cfscript>
	var iterator = getTransferObject().getCategoryIterator();
	var category =0;
	
	/* Loop over Categories in the Content */
	while(iterator.hasNext()){
		category = iterator.next();
		if( arguments.categoryID eq category.getCategory_id() ){ return true; }
	}
	
	return false;
	</cfscript>
</cffunction>

<cffunction name="populate" hint="processes the form details" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="takes a memento" type="struct" required="Yes">
	<cfscript>
		getBeanPopulator().populate(this, arguments.memento);
		//setPageName(arguments.memento.pageName);
	</cfscript>
</cffunction>

<cffunction name="validate" hint="returns an array of error messages. If the array is empty, validation has passed" access="public" returntype="array" output="false">
	<cfargument name="isCommentsMandatory" type="boolean" required="true" hint="is Comments Mandatory"/>
	<cfscript>
		var messages = ArrayNew(1);
		/* Validate Content */
		if(NOT Len(Trim(getContent())))
		{
			ArrayAppend(messages, "Content cannot be empty.");
		}
		/* Validate Comments */
		if(arguments.isCommentsMandatory and NOT Len(Trim(getComment())))
		{
			ArrayAppend(messages, "Comment cannot be empty.");
		}
		
		return messages;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders the page content" access="public" returntype="string" output="false">
	<cfscript>
		var args = StructNew();

		args.stringBuilder = createObject("java", "java.lang.StringBuffer").init();

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

<cffunction name="replaceActive" hint="replaces the currently active content, with a copy of this one" access="public" returntype="void" output="false">
	<cfscript>
		getWikiService().saveContentVersion(copy());
	</cfscript>
</cffunction>

<cffunction name="copy" hint="makes a copy of this object" access="public" returntype="Content" output="false">
	<cfscript>
		var content = getWikiService().getContent();
		var memento = getPropertyMemento();

		StructDelete(memento, "isActive");
		StructDelete(memento, "createDate");

		content.populate(memento);
		content.setPage(getPage());

		return content;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="translate" hint="translates the wiki page content" access="private" returntype="string" output="false">
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
	<cfargument name="commandArgs" hint="the comand arguments" type="struct" required="false" default="#StructNew()#">
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

<cffunction name="visitContentCommand" hint="a command to enable visitors to visit each renderable item" access="public" returntype="void" output="false">
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
		if(NOT arguments.renderable.getIsDynamic() OR arguments.visitDynamicContent == true)
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
		setIsActive(false);
		setIsReadOnly(false);
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