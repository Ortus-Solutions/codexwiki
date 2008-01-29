<cfcomponent hint="renders <feed> tags" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Feed" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders out wiki text to html" access="public" returntype="string" output="false">
	<cfargument name="wikiText" hint="the wiki text to render" type="string" required="Yes">
	<cfscript>
		//do this with Java, as it'll be faster
		var builder = createObject("java", "java.lang.StringBuilder").init(arguments.wikiText);
		var pattern = createObject("java", "java.util.regex.Pattern").compile("<feed[^>]+>");
		var matcher = pattern.matcher(builder);
		var group = 0;

		while(matcher.find())
		{
			builder.replace(matcher.start(), matcher.end(), buildFeed(matcher.group()));
		}

		return builder.toString();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildFeed" hint="builds the feed, and returns back the HTML" access="private" returntype="string" output="false">
	<cfargument name="feedTag" hint="the feed tag" type="string" required="Yes">
	<cfscript>
		var xFeed = 0;
		var data = 0;

		if(NOT arguments.feedTag.endsWith("/>"))
		{
			arguments.feedTag = replace(arguments.feedTag, ">", "/>");
		}

		if(NOT isXML(arguments.feedTag))
		{
			//if not valid xml, just return it as is.
			return arguments.feedTag;
		}

		xFeed = xmlParse(arguments.feedTag);
		xFeed = xFeed[1].feed.xmlAttributes; //convenience

		//if not url, just return it
		if(NOT StructKeyExists(xFeed, "url"))
		{
			return arguments.feedTag;
		}
	</cfscript>

	<!--- if anything goes wrong, display error --->
	<cftry>
		<cffeed action="read" source="#xFeed.url#" name="data">
		<cfcatch type="Application">
			<cfsavecontent variable="html">
			<cfoutput>
				<div class="rssList">
					<p>
						<strong>Error with feed at: <a href="#xFeed.url#">#xFeed.url#</a></strong>
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
		<cfreturn buildRSSFeed(data, xFeed.url) />
	<cfelseif FindNoCase("atom", data.version)>
		<cfreturn buildAtomFeed(data, xFeed.url) />
	<cfelse>
		<cfreturn "Not atom, not rss... what is it? - #data.verson# -"/>
	</cfif>
</cffunction>

<cffunction name="buildRSSFeed" hint="taks an rss feed, and builds the display for htat" access="private" returntype="string" output="false">
	<cfargument name="data" hint="the rss feed arguments.data" type="struct" required="Yes">
	<cfargument name="url" hint="the url the rss feed has" type="string" required="Yes">
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
		<ul>
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
		</ul>
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
		<ul>
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
		</ul>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn html />
</cffunction>

</cfcomponent>