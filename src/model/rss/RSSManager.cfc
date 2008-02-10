<cfcomponent hint="Central management CFCs for all the RSS feeds that come off the wiki" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RssManager" output="false">
	<cfscript>
		setFeedCollection(StructNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getRSS" hint="returns an rss feed structure" access="public" returntype="struct" output="false">
	<cfargument name="sourceName" hint="the name of the feed source" type="string" required="Yes">
	<cfargument name="feed" hint="the name of the feed to pass back" type="string" required="Yes">
	<cfargument name="feedArgs" hint="the rss feed arguments" type="struct" required="Yes">
	<cfscript>
		var source = getSource(arguments.sourceName);
		var result = StructNew();
	</cfscript>

	<cfif isObject(source) AND StructKeyExists(source, arguments.feed)>
		<cfinvoke component="#source#" method="#arguments.feed#" argumentcollection="#feedArgs#" returnvariable="result">
	</cfif>

	<cfscript>
		return result;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSource" hint="Returns the source CFC" access="private" returntype="any" output="false">
	<cfargument name="sourceName" hint="the name of the souce" type="string" required="Yes">
	<cfscript>
		var source = 0;
	</cfscript>
	<cfif NOT StructKeyExists(getFeedCollection(), arguments.sourceName)>
		<cflock name="codex.RssManager.getFeed.#arguments.sourceName#" throwontimeout="true" timeout="60">
		<cfscript>
			if(NOT StructKeyExists(getFeedCollection(), arguments.sourceName))
			{
				if(NOT FileExists(getDirectoryFromPath(getMetaData(this).path) & "source/" & arguments.sourceName & ".cfc"))
				{
					return 0;
				}

				source = createObject("component", "codex.model.rss.source.#arguments.sourceName#").init();

				StructInsert(getFeedCollection(), arguments.sourceName, source);
			}
		</cfscript>
		</cflock>
	</cfif>
	<cfreturn StructFind(getFeedCollection(), arguments.sourceName) />
</cffunction>

<cffunction name="getFeedCollection" access="private" returntype="struct" output="false">
	<cfreturn instance.feedCollection />
</cffunction>

<cffunction name="setFeedCollection" access="private" returntype="void" output="false">
	<cfargument name="feedCollection" type="struct" required="true">
	<cfset instance.feedCollection = arguments.feedCollection />
</cffunction>

</cfcomponent>