<cfcomponent hint="Central management CFCs for all the RSS feeds that come off the wiki" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RssManager" output="false">
	<cfargument name="coldBoxController" type="coldbox.system.controller" required="true">
	<cfscript>
		setFeedCollection(StructNew());

		setBaseURL(arguments.coldBoxController.getSetting("sesBaseURL") & "/feed/");

		return this;
	</cfscript>
</cffunction>

<cffunction name="getRSS" hint="returns an rss feed structure" access="public" returntype="xml" output="false">
	<cfargument name="sourceName" hint="the name of the feed source" type="string" required="Yes">
	<cfargument name="feed" hint="the name of the feed to pass back" type="string" required="Yes">
	<cfargument name="feedArgs" hint="the rss feed arguments" type="struct" required="Yes">
	<cfscript>
		var source = getSource(arguments.sourceName);
		var result = "<error>Feed not found</error>";
	</cfscript>

	<cfif isObject(source) AND StructKeyExists(source, arguments.feed)>
		<cfinvoke component="#source#" method="#arguments.feed#" argumentcollection="#feedArgs#" returnvariable="result">
	</cfif>

	<cfscript>
		return result;
	</cfscript>
</cffunction>

<!--- Dependency injection methods for Bean Factory. --->

<cffunction name="setBeanFactory" access="public" returntype="void" output="false" hint="I set the BeanFactory.">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="autowire" hint="autowires the source from CS" access="public" returntype="void" output="false">
	<cfargument name="source" hint="the source to autowire" type="any" required="Yes">
	<cfscript>
		var keys = StructKeyArray(arguments.source);
		var key = 0;
		var meta = 0;
		var args = 0;
		var beanName = 0;
	</cfscript>
	<cfloop array="#keys#" index="key">
		<cfif LCase(key).startsWith("set") AND isCustomFunction(arguments.source[key])>
			<cfset meta = getMetaData(arguments.source[key]) />
			<cfif NOT StructKeyExists(meta, "access") OR meta.access eq "public" AND arrayLen(meta.parameters) eq 1>
				<cfset beanName = Right(key, Len(Key) - 3) />
				<cfif getBeanFactory().containsBean(beanName)>
					<cfset args = StructNew() />
					<cfset args[meta.parameters[1].name] = getBeanFactory().getBean(beanName) />
					<cftry>
						<cfinvoke component="#arguments.source#" method="#key#" argumentcollection="#args#">
						<cfcatch>
							<!--- do nothing --->
						</cfcatch>
					</cftry>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="getBeanFactory" access="private" returntype="any" output="false" hint="I return the BeanFactory.">
	<cfreturn instance.beanFactory />
</cffunction>

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

				source = createObject("component", "codex.model.rss.source.#arguments.sourceName#").init(getBaseURL());
				autowire(source);

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

<cffunction name="getBaseURL" access="private" returntype="string" output="false">
	<cfreturn instance.baseURL />
</cffunction>

<cffunction name="setBaseURL" access="private" returntype="void" output="false">
	<cfargument name="baseURL" type="string" required="true">
	<cfset instance.baseURL = arguments.baseURL />
</cffunction>

</cfcomponent>