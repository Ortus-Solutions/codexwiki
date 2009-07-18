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
<cfcomponent hint="renders <feed> tags" extends="AbstractXMLTag" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Feed" output="false">
	<cfargument name="coldboxOCM" 		hint="the coldbox cache. For injecting into Transients" type="coldbox.system.cache.cacheManager" required="Yes">
	<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
	<cfargument name="rssManager" 		hint="the rss manager" type="codex.model.rss.RSSManager" required="true">
	<cfscript>
		// Init Abstraction
		super.init("feed",arguments.configService);

		setBaseURL(arguments.configService.getSetting("sesBaseURL"));
		
		setCacheManager(arguments.coldboxOCM);
		setRSSManager(arguments.rssManager);
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="doStart" hint="does start of rendering, before the tags are found" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		arguments.state.results = [];
	</cfscript>
</cffunction>

<cffunction name="doStartTag" hint="does the execution of when the tag is opened" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		var static = createObject("component", "codex.model.wiki.parser.renderable.StaticRenderable").init(arguments.builder.substring(0, arguments.matcher.start()));
		var feed = createObject("component", "codex.model.wiki.parser.renderable.FeedRenderable").init(arguments.tag, getBaseURL(), getCacheManager(), getRSSManager(), getRewriteExtension());

		ArrayAppend(arguments.state.results, static);
		ArrayAppend(arguments.state.results, feed);

		arguments.builder.replace(0, arguments.matcher.end(), "");
	</cfscript>
</cffunction>

<cffunction name="doEndTag" hint="does the execution of when the tag is closed" access="private" returntype="void" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="tag" hint="the name of the current matched start/end tag" type="string" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>

		//have to do an end tag, as the bliki parser splits this out to <feed></feed>, even on <feed> tags
		arguments.builder.replace(arguments.matcher.start(), arguments.matcher.end(), "");
	</cfscript>
</cffunction>

<cffunction name="doFinish" hint="does final piece, after the rendering, and returns an optional Renderable / array of renderable objects" access="private" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfargument name="builder" hint="the string builder/buffer that represents the static content" type="any" required="Yes">
	<cfargument name="matcher" hint="the java.util.regex.Matcher object, for the current tag match" type="any" required="Yes">
	<cfargument name="state" hint="the state transported across doStart(), doStartTag(), doEndTag() and doEnd()" type="struct" required="Yes">
	<cfscript>
		//if it's empty, return nothing, as there is nothing to change
		if(ArrayIsEmpty(arguments.state.results))
		{
			return;
		}

		//otherwise

		//finally push whatever is left on the builder into a new static renderable
		if(arguments.builder.length())
		{
			ArrayAppend(arguments.state.results, createObject("component", "codex.model.wiki.parser.renderable.StaticRenderable").init(arguments.builder.toString()));
		}

		//return the array to switch out with
		return arguments.state.results;
	</cfscript>
</cffunction>

<!--- <cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		//do this with Java, as it is fast
		var builder = arguments.renderable.getStringBuilderContent();
		var pattern = createObject("java", "java.util.regex.Pattern").compile("<feed[^>]+>");
		var matcher = pattern.matcher(builder);
		var results = ArrayNew(1);
		var feed = 0;
		var static = 0;
		var feedTag = 0;

		while(matcher.find())
		{
			feedTag = matcher.group();

			static = createObject("component", "codex.model.wiki.parser.renderable.StaticRenderable").init(builder.substring(0, matcher.start()));

			//clear off the 1st section, and the feed tag
			builder.replace(0, matcher.end(), "");
			matcher.reset();

			//going to pass off parsing and validation to the FeedRenderable object
			feed = createObject("component", "codex.model.wiki.parser.renderable.FeedRenderable").init(feedTag, getBaseURL(), getCacheManager(), getRSSManager());

			ArrayAppend(results, static);
			ArrayAppend(results, feed);
		}

		//if it's empty, return nothing, as there is nothing to change
		if(ArrayIsEmpty(results))
		{
			return;
		}

		//finally push whatever is left on the builder into a new static renderable
		if(builder.length())
		{
			ArrayAppend(results, createObject("component", "codex.model.wiki.parser.renderable.StaticRenderable").init(builder.toString()));
		}

		//return the array to switch out with
		return results;
	</cfscript>
</cffunction> --->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getCacheManager" access="private" returntype="coldbox.system.cache.cacheManager" output="false">
	<cfreturn instance.cacheManager />
</cffunction>

<cffunction name="setCacheManager" access="private" returntype="void" output="false">
	<cfargument name="cacheManager" type="coldbox.system.cache.cacheManager" required="true">
	<cfset instance.cacheManager = arguments.cacheManager />
</cffunction>

<cffunction name="setRssManager" access="private" returntype="void" output="false">
	<cfargument name="rssManager" type="codex.model.rss.RSSManager" required="true">
	<cfset instance.rssManager = arguments.rssManager />
</cffunction>

<cffunction name="getRssManager" access="private" returntype="codex.model.rss.RSSManager" output="false">
	<cfreturn instance.rssManager />
</cffunction>


<cffunction name="getBaseURL" access="private" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>

<cffunction name="setBaseURL" access="private" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>

</cfcomponent>