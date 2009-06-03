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
<cfcomponent hint="Renders feed data" extends="AbstractRenderable" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="FeedRenderable" output="false">
	<cfargument name="feedTag" 		 		type="string" 								required="Yes" hint="">
	<cfargument name="baseURL" 		 		type="string" 								required="Yes" hint="the base url to draw links from">
	<cfargument name="coldboxOCM" 	 		type="coldbox.system.cache.cacheManager" 	required="Yes" hint="the coldbox cache. For injecting into Transients">
	<cfargument name="rssManager" 	 		type="codex.model.rss.RSSManager" 			required="Yes" hint="the rss manager">
	<cfargument name="rewriteExtension"  	type="string" 								required="Yes" hint="the rewrite extension">
	<cfscript>
		var xFeed = 0;
		var cleanFeed = 0;

		super.init(true);

		//constants for caching
		instance.static.CACHE_PREFIX = "codex:";
		
		setFeedTag(arguments.feedTag);
		setCacheManager(arguments.coldboxOCM);
		setRssManager(arguments.rssManager);
		setrewriteExtension(arguments.rewriteExtension);
		
		/* Cleanup of end tag if it does not exist */
		if(NOT arguments.feedTag.endsWith("/>"))
		{
			arguments.feedTag = replace(arguments.feedTag, ">", "/>");
		}
		/* Check if it is valid XML or not? */
		if(NOT isXML(arguments.feedTag))
		{
			/* Try to escape attributes and clean tag contents. */
			cleanFeed = escapeAttributes(arguments.feedTag);
			
			if(NOT isXML(cleanFeed))
			{
				//if not valid xml, just return it as is.
				setIsValidFeedTag(false);
				return this;
			}

			arguments.feedTag = cleanFeed;

		}
		/* Parse into XML */
		xFeed = xmlParse(arguments.feedTag);
		xFeed = xFeed.feed.xmlAttributes; //convenience

		//if not url, just return it
		if(NOT StructKeyExists(xFeed, "url"))
		{
			setIsValidFeedTag(false);
			return this;
		}
		/* Check for valid URL's for feeds */
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
		
		/* Max Items 0=unlimited */
		if(NOT StructKeyExists(xFeed, "maxitems") OR NOT isNumeric(xFeed.maxItems) OR xFeed.maxItems LT 0 )
		{
			xFeed.maxItems = 0;
		}

		/* Store feed tag data and validation */
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
		/* Check if feed is valid */
		if(NOT getIsValidFeedTag())
		{
			return XMLFormat(getFeedTag());
		}

		/* Get Feed data */
		feedData = getFeedData();
		//setup the cache key
		key = instance.static.CACHE_PREFIX & feedData.url & ":" & feedData.listType;
		/* Check the cache time */
		if ( StructKeyExists(feedData, "cache") ){
			key &= ":" & feedData.cache;
		}
	</cfscript>

	<!--- make sure only 1 feed renderable tries it at once --->
	<cfif NOT getCacheManager().lookup(key)>
		<cflock name="codex.FeedRenderable.#key#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT getCacheManager().lookup(key))
			{
				args = StructNew();
				args.objectKey = key;
				/* Get the rendered Feed Content */
				args.myObject = getRenderedFeed();

				//if there is no cache item, use the CB default value
				if(StructKeyExists(feedData, "cache"))
				{
					args.timeout = feedData.cache;
				}
				/* Cache this feed content. */
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
		<!--- Try to render an external feed param --->
		<cfif feedData.url.startsWith("http://")>
			<cffeed action="read" source="#feedData.url#" name="data" timeout="30" userAgent="CodexWiki - http://www.codexwiki.org">
		<cfelse>
			<!--- I have to push it to a temporary file. sucks. --->
			<cfset path = expandPath(getRSSManager().getTempRSSDirectory() & createObject("java", "java.util.UUID").randomUUID()) />
			<cffile action="write" file="#path#" output="#getRelativeFeed()#">
			<cffeed action="read" source="#path#"  name="data">
			<cffile action="delete" file="#path#">
		</cfif>
		<cfcatch type="Application">
			<cfsavecontent variable="html">
			<cfoutput>
				<div class="rssList">
					<p>
						<strong>Error with feed at: <a href="#feedData.url#" class="externallink">#feedData.url#</a></strong>
					</p>
					<p>
						#cfcatch.message#
					</p>
				</div>
				<cfdump var="#cfcatch#" output="console">
			</cfoutput>
			</cfsavecontent>
			<cfreturn html />
		</cfcatch>
	</cftry>
	
	<!--- Parse the content according to rss type --->
	<cfif FindNoCase("rss", data.version)>
		<cfreturn buildRSSFeed(data, feedData.url, feedData.listType, feedData.maxitems) />
	<cfelseif FindNoCase("atom", data.version)>
		<cfreturn buildAtomFeed(data, feedData.url, feedData.listType, feedData.maxitems) />
	<cfelse>
		<cfreturn "Not atom, not rss... what is it? - #data.version# - #getRelativeFeed()#"/>
	</cfif>
</cffunction>

<cffunction name="getRelativeFeed" hint="return a relative feed through the RSS Manager. Returns xml" access="private" returntype="any" output="false">
	<!---
	/feed/page/listByCategory(.cfm)
	 --->
	<cfscript>
		var feedData = getFeedData();
		var urlString = replace(feedData.url, "/feed/", "");
		var root = ListGetAt(urlString, 1, "?");
		var queryString = "";
		var source = listGetAt(root, "1", "/");
		var feed = replaceNoCase(listGetAt(root, "2", "/"), ".cfm","");
		
		if(ListLen(urlString, "?") eq 2)
		{
			queryString = ListGetAt(urlString, 2, "?");
		}

		return getRssManager().getRss(source, feed, queryStringToStruct(queryString));
	</cfscript>
</cffunction>

<cffunction name="queryStringToStruct" hint="returns a struct from a query string" access="private" returntype="struct" output="false">
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
	<cfargument name="data"  		type="struct" 	required="true" 	hint="the rss feed arguments.data">
	<cfargument name="urlString"  	type="string" 	required="true" 	hint="the url the rss feed has">
	<cfargument name="listType"  	type="string" 	required="true" 	hint="the list type to display, ul, or ol">
	<cfargument name="maxItems" 	type="numeric" 	required="true" 	hint="The max items to query">
	<cfscript>
		var html = 0;
		var item = 0;
		var category = 0;
		var list = 0;
		var breakCounter = 0;
	</cfscript>

	<cfsavecontent variable="html">
	<cfoutput>
	<div class="rssList">
		<p>
			<strong>
			<a href="#arguments.urlString#"><img src="includes/images/feed.png" border="0" alt="feed" /></a>
			<cfif structKeyExists(arguments.data, "link")>
				<a href="#arguments.data.link#">#arguments.data.title#</a>
			<cfelse>
				#arguments.data.title#
			</cfif>
			</strong>

			<cfif StructKeyExists(arguments.data, "lastBuildDate")>
			(Last Built: #arguments.data.lastBuildDate#)
			</cfif>			
		</p>
		<cfif StructKeyExists(arguments.data, "description")>
			<p class="description">
				#arguments.data.description#
			</p>
		</cfif>
		<#arguments.listType#>
		<cfif structKeyExists(arguments.data,"item") and ArrayLen(arguments.data.item) gt 0>
			<!--- Verify the Max items Count --->
			<cfif arguments.maxItems NEQ 0 AND arrayLen(arguments.data.item) LTE arguments.maxItems>
				<cfset arguments.maxItems = arrayLen(arguments.data.item)>
			</cfif>
			<!--- Start Looping --->
			<cfloop array="#arguments.data.item#" index="item">
				<cfset breakCounter++>
				<li>
					<p class="title">
						<cfif StructKeyExists(item, "link")>
							<a href="#item.link#" class="externallink">#item.title#</a>
						<cfelse>
							#item.title#
						</cfif>
					</p>
					<p class="description">
					<cfif StructKeyExists(item, "description") and StructKeyExists(item.description,"value")>
						#item.description.value#
					</cfif>
					</p>
	
					<cfif StructKeyExists(item, "category")>
						<p> Categories:
						<cfset list = ""/>
						<cfloop array="#item.category#" index="category">
							<cfif StructKeyExists(category, "domain")>
								<cfset list = listAppend(list, ' <a href="#category.domain#" class="externallink">#category.value#</a>') />
							<cfelse>
								<cfset list = listAppend(list, ' #category.value#') />
							</cfif>
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
				<!--- Break Counter Check --->
				<cfif arguments.maxItems NEQ 0 AND breakCounter EQ arguments.maxItems>
					<cfbreak />
				</cfif>
			</cfloop>
		<cfelse>
			<em>No Records Found</em>
		</cfif>
		</#arguments.listType#>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn html />
</cffunction>

<cffunction name="buildAtomFeed" hint="taks an atom feed, and builds the display for htat" access="private" returntype="string" output="false">
	<cfargument name="data"  		type="struct" 	required="true" 	hint="the rss feed arguments.data">
	<cfargument name="urlString"  	type="string" 	required="true" 	hint="the url the rss feed has">
	<cfargument name="listType"  	type="string" 	required="true" 	hint="the list type to display, ul, or ol">
	<cfargument name="maxItems" 	type="numeric" 	required="true" 	hint="The max items to query">
	<cfscript>
		var html = 0;
		var entry = 0;
		var category = 0;
		var list = 0;
		var breakCounter = 0;
	</cfscript>

	<cfsavecontent variable="html">
	<cfoutput>
	<div class="rssList">
		<p>
			<strong>
			<a href="#arguments.urlString#"><img src="includes/images/feed.png" border="0" alt="feed" /></a>
			<cfif structKeyExists(arguments.data, "id")>
				<a href="#arguments.data.id#">#arguments.data.title.value#</a>
			<cfelse>
				#arguments.data.title.value#
			</cfif>
			</strong>

			<cfif StructKeyExists(arguments.data, "updated")>
			(Last Built: #arguments.data.updated#)
			</cfif>
		</p>

		<cfif StructKeyExists(arguments.data, "description")>
			<p class="description">
				#arguments.data.description#
			</p>
		</cfif>
		<#arguments.listType#>
			<cfif structKeyExists(arguments.data,"entry") and ArrayLen(arguments.data.entry) gt 0>
				<!--- Verify the Max items Count --->
				<cfif arguments.maxItems NEQ 0 AND arrayLen(arguments.data.entry) LTE arguments.maxItems>
					<cfset arguments.maxItems = arrayLen(arguments.data.entry)>
				</cfif>
				<cfloop array="#arguments.data.entry#" index="entry">
					<cfset breakCounter++>
					<li>
						<p class="title">
							<cfif StructKeyExists(entry, "id")>
								<a href="#entry.id#" class="externallink">#entry.title.value#</a>
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
								<cfset list = listAppend(list, ' <a href="#category.scheme#" class="externallink">#category.label#</a>') />
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
					<!--- Break Counter Check --->
					<cfif arguments.maxItems NEQ 0 AND breakCounter EQ arguments.maxItems>
						<cfbreak />
					</cfif>
				</cfloop>
			<cfelse>
			<em>No Records Found</em>
			</cfif>
		</#arguments.listType#>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn html />
</cffunction>

<cffunction name="escapeAttributes" hint="returns the string with clean attributes" access="private" returntype="string" output="false">
	<cfargument name="feedTag" hint="the feed tag" type="string" required="Yes">
	<cfscript>
		var builder = createObject("java", "java.lang.StringBuffer").init(arguments.feedTag);
		var pattern = createObject("java", "java.util.regex.Pattern").compile('"([^"]+)"');
		var matcher = pattern.matcher(builder);

		while(matcher.find())
		{
			builder.replace(matcher.start(1), matcher.end(1), xmlFormat(matcher.group(1)));
		}

		return builder.toString();
	</cfscript>
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

<cffunction name="getrewriteExtension" access="private" output="false" returntype="string" hint="Get rewriteExtension">
	<cfreturn instance.rewriteExtension/>
</cffunction>

<cffunction name="setrewriteExtension" access="private" output="false" returntype="void" hint="Set rewriteExtension">
	<cfargument name="rewriteExtension" type="string" required="true"/>
	<cfset instance.rewriteExtension = arguments.rewriteExtension/>
</cffunction>

</cfcomponent>