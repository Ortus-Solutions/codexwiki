<cfcomponent hint="Renders feed data" extends="AbstractRenderable" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="FeedRenderable" output="false">
	<cfargument name="feedTag" hint="" type="string" required="Yes">
	<cfargument name="baseURL" hint="the base url to draw links from" type="string" required="Yes">
	<cfargument name="coldboxOCM" hint="the coldbox cache. For injecting into Transients" type="coldbox.system.cache.cacheManager" required="Yes">
	<cfargument name="rssManager" hint="the rss manager" type="codex.model.rss.RSSManager" required="Yes">
	<cfscript>
		var xFeed = 0;

		super.init(true);

		//constants
		instance.static.CACHE_PREFIX = "codex:";

		setFeedTag(arguments.feedTag);
		setCacheManager(arguments.coldboxOCM);
		setRssManager(arguments.rssManager);

		if(NOT arguments.feedTag.endsWith("/>"))
		{
			arguments.feedTag = replace(arguments.feedTag, ">", "/>");
		}

		if(NOT isXML(arguments.feedTag))
		{
			//if not valid xml, just return it as is.
			setIsValidFeedTag(false);
			return this;
		}

		xFeed = xmlParse(arguments.feedTag);
		xFeed = xFeed[1].feed.xmlAttributes; //convenience

		//if not url, just return it
		if(NOT StructKeyExists(xFeed, "url"))
		{
			setIsValidFeedTag(false);
			return this;
		}

		if(NOT (lCase(xFeed.url).startsWith("http://") OR lCase(xFeed.url).startsWith("/feed/")))
		{
			setIsValidFeedTag(false);
			return this;
		}

		//default display is 'ul'
		xFeed.listType = "ul";

		if(StructKeyExists(xFeed, "display") AND xFeed.display eq "numbered")
		{
			xFeed.listType = "ol";
		}

		setFeedData(xFeed);

		setIsValidFeedTag(true);

		return this;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders the output" access="public" returntype="string" output="false">
	<cfset var feedData = 0 />
	<cfset var key = 0 />
	<cfset var renderedFeed = 0 />
	<cfset var args = 0 />

	<cfscript>
		if(NOT getIsValidFeedTag())
		{
			return XMLFormat(getFeedTag());
		}

		//setup the cache key
		feedData = getFeedData();
		key = instance.static.CACHE_PREFIX & feedData.url & ":" & feedData.listType;
	</cfscript>

	<cfif StructKeyExists(feedData, "cache")>
		<cfset key &= ":" & feedData.cache />
	</cfif>

	<!--- make sure only 1 feed renderable tries it at once --->
	<cfif NOT getCacheManager().lookup(key)>
		<cflock name="codex.FeedRenderable.#key#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT getCacheManager().lookup(key))
			{
				args = StructNew();
				args.objectKey = key;
				args.myObject = getRenderedFeed();

				//if there is no cache item, use the CB default value
				if(StructKeyExists(feedData, "cache"))
				{
					args.timeout = feedData.cache;
				}

				getCacheManager().set(argumentCollection=args);
			}
		</cfscript>
		</cflock>
	</cfif>
	<cfscript>
		renderedFeed = getCacheManager().get(key);

		//if for some reason the feed was not cached, just do a non cached render.
		if(isStruct(renderedFeed))
		{
			return getRenderedFeed();
		}

		return renderedFeed;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getRenderedFeed" hint="returns the rendered feed" access="private" returntype="string" output="false">
	<cfset var feedData = getFeedData() />
	<cfset var data = 0 />
	<cfset var path = 0 />
	<cfset var html = 0 />

	<!--- if anything goes wrong, display error --->
	<cftry>
		<cfif feedData.url.startsWith("http://")>
			<cffeed action="read" source="#feedData.url#" name="data" timeout="30">
		<cfelse>
			<!--- I have to push it to a temporary file. sucks. --->
			<cfset path = "/" & createObject("java", "java.util.UUID").randomUUID() />
			<cfset path = expandPath(path) />
			<cffile action="write" file="#path#" output="#getRelativeFeed()#">
			<cffeed action="read" source="#path#"  name="data">
			<cffile action="delete" file="#path#">
		</cfif>
		<cfcatch type="Application">
			<cfsavecontent variable="html">
			<cfoutput>
				<div class="rssList">
					<p>
						<strong>Error with feed at: <a href="#feedData.url#">#feedData.url#</a></strong>
					</p>
					<p>
						#cfcatch.message#
					</p>
				</div>
			</cfoutput>
			</cfsavecontent>
			<cfreturn html />
		</cfcatch>
	</cftry>

	<cfif FindNoCase("rss", data.version)>
		<cfreturn buildRSSFeed(data, feedData.url, feedData.listType) />
	<cfelseif FindNoCase("atom", data.version)>
		<cfreturn buildAtomFeed(data, feedData.url, feedData.listType) />
	<cfelse>
		<cfreturn "Not atom, not rss... what is it? - #data.verson# -"/>
	</cfif>
</cffunction>

<cffunction name="getRelativeFeed" hint="return a relative feed through the RSS Manager" access="public" returntype="xml" output="false">
	<!---
	/feed/page/listByCategory.cfm
	 --->
	<cfscript>
		var feedData = getFeedData();
		var url = replace(feedData.url, "/feed/", "");
		var root = ListGetAt(url, 1, "?");
		var queryString = "";
		var source = listGetAt(root, "1", "/");
		var feed = replaceNoCase(listGetAt(root, "2", "/"), ".cfm", "");

		if(ListLen(url, "?") eq 2)
		{
			queryString = ListGetAt(url, 2, "?");
		}

		return getRssManager().getRss(source, feed, queryStringToStruct(queryString));
	</cfscript>
</cffunction>

<cffunction name="queryStringToStruct" hint="returns a struct from a query string" access="public" returntype="struct" output="false">
	<cfargument name="queryString" hint="the query string" type="string" required="Yes">
	<cfscript>
		var key = 0;
		var item = 0;
		var result = StructNew();
	</cfscript>
	<cfloop list="#arguments.queryString#" index="item" delimiters="&">
		<cfscript>
			key = URLDecode(ListGetAt(item, 1, "="));
			result[key] = URLDecode(ListGetAt(item, 2, "="));
		</cfscript>
	</cfloop>

	<cfreturn result />
</cffunction>

<cffunction name="buildRSSFeed" hint="taks an rss feed, and builds the display for htat" access="private" returntype="string" output="false">
	<cfargument name="data" hint="the rss feed arguments.data" type="struct" required="Yes">
	<cfargument name="url" hint="the url the rss feed has" type="string" required="Yes">
	<cfargument name="listType" hint="the list type to display, ul, or ol" type="string" required="Yes">
	<cfscript>
		var html = 0;
		var item = 0;
		var category = 0;
		var list = 0;
	</cfscript>

	<cfsavecontent variable="html">
	<cfoutput>
	<div class="rssList">
		<p>
			<strong>
			<cfif structKeyExists(arguments.data, "link")>
				<a href="#arguments.data.link#">#arguments.data.title#</a>
			<cfelse>
				#arguments.data.title#
			</cfif>
			</strong>

			<cfif StructKeyExists(arguments.data, "lastBuildDate")>
			(Last Built: #arguments.data.lastBuildDate#)
			</cfif>
			[<a href="#arguments.url#">rss</a>]
		</p>
		<cfif StructKeyExists(arguments.data, "description")>
			<p class="description">
				#arguments.data.description#
			</p>
		</cfif>
		<#arguments.listType#>
		<cfloop array="#arguments.data.item#" index="item">
			<li>
				<p class="title">
					<cfif StructKeyExists(item, "link")>
						<a href="#item.link#">#item.title#</a>
					<cfelse>
						#item.title#
					</cfif>
				</p>
				<p class="description">
				<cfif StructKeyExists(item, "description")>
					#item.description.value#
				</cfif>
				</p>

				<cfif StructKeyExists(item, "category")>
					<p> Categories:
					<cfset list = ""/>
					<cfloop array="#item.category#" index="category">
						<cfset list = listAppend(list, ' <a href="#category.domain#">#category.value#</a>') />
					</cfloop>
					#list#
					</p>
				</cfif>

				<cfif StructKeyExists(item, "pubDate")>
				<p class="pubdate">
					(#item.pubDate#)
				</p>
				</cfif>
			</li>
		</cfloop>
		</#arguments.listType#>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn html />
</cffunction>

<cffunction name="buildAtomFeed" hint="taks an atom feed, and builds the display for htat" access="private" returntype="string" output="false">
	<cfargument name="data" hint="the rss feed arguments.data" type="struct" required="Yes">
	<cfargument name="url" hint="the url the rss feed has" type="string" required="Yes">
	<cfscript>
		var html = 0;
		var entry = 0;
		var category = 0;
		var list = 0;
	</cfscript>

	<cfsavecontent variable="html">
	<cfoutput>
	<div class="rssList">
		<p>
			<strong>
			<cfif structKeyExists(arguments.data, "id")>
				<a href="#arguments.data.id#">#arguments.data.title.value#</a>
			<cfelse>
				#arguments.data.title.value#
			</cfif>
			</strong>

			<cfif StructKeyExists(arguments.data, "updated")>
			(Last Built: #arguments.data.updated#)
			</cfif>
			[<a href="#arguments.url#">atom</a>]
		</p>

		<cfif StructKeyExists(arguments.data, "description")>
			<p class="description">
				#arguments.data.description#
			</p>
		</cfif>
		<#arguments.listType#>
		<cfloop array="#arguments.data.entry#" index="entry">
			<li>
				<p class="title">
					<cfif StructKeyExists(entry, "id")>
						<a href="#entry.id#">#entry.title.value#</a>
					<cfelse>
						#item.title.value#
					</cfif>
				</p>
				<p class="description">
				<cfif StructKeyExists(entry, "summary")>
					#entry.summary.value#
				</cfif>
				</p>

				<cfif StructKeyExists(entry, "category")>
					<p> Categories:
					<cfset list = ""/>
					<cfloop array="#entry.category#" index="category">
						<cfset list = listAppend(list, ' <a href="#category.scheme#">#category.label#</a>') />
					</cfloop>
					#list#
					</p>
				</cfif>

				<cfif StructKeyExists(entry, "updated")>
				<p class="pubdate">
					(#entry.updated#)
				</p>
				</cfif>
			</li>
		</cfloop>
		</#arguments.listType#>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn html />
</cffunction>

<cffunction name="getFeedData" access="private" returntype="struct" output="false">
	<cfreturn instance.feedData />
</cffunction>

<cffunction name="setFeedData" access="private" returntype="void" output="false">
	<cfargument name="feedData" type="struct" required="true">
	<cfset instance.feedData = arguments.feedData />
</cffunction>

<cffunction name="getFeedTag" access="private" returntype="string" output="false">
	<cfreturn instance.feedTag />
</cffunction>

<cffunction name="setFeedTag" access="private" returntype="void" output="false">
	<cfargument name="feedTag" type="string" required="true">
	<cfset instance.feedTag = arguments.feedTag />
</cffunction>

<cffunction name="getIsValidFeedTag" access="private" returntype="boolean" output="false">
	<cfreturn instance.isValidFeedTag />
</cffunction>

<cffunction name="setIsValidFeedTag" access="private" returntype="void" output="false">
	<cfargument name="isValidFeedTag" type="boolean" required="true">
	<cfset instance.isValidFeedTag = arguments.isValidFeedTag />
</cffunction>

<cffunction name="setRssManager" access="private" returntype="void" output="false">
	<cfargument name="rssManager" type="codex.model.rss.RSSManager" required="true">
	<cfset instance.rssManager = arguments.rssManager />
</cffunction>

<cffunction name="getRssManager" access="private" returntype="codex.model.rss.RSSManager" output="false">
	<cfreturn instance.rssManager />
</cffunction>

<cffunction name="getCacheManager" access="private" returntype="coldbox.system.cache.cacheManager" output="false">
	<cfreturn instance.cacheManager />
</cffunction>

<cffunction name="setCacheManager" access="private" returntype="void" output="false">
	<cfargument name="cacheManager" type="coldbox.system.cache.cacheManager" required="true">
	<cfset instance.cacheManager = arguments.cacheManager />
</cffunction>

</cfcomponent>