<cfcomponent hint="the media wiki parser" output="false">


<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiText" output="false">
	<cfscript>
		var path = getDirectoryFromPath(getMetaData(this).path) & "/lib/bliki/";
		var qFiles = 0;
		var paths = ArrayNew(1);
	</cfscript>
	<cfdirectory action="list" filter="*.jar" directory="#path#" name="qFiles">
	<cfloop query="qFiles">
		<cfset ArrayAppend(paths, directory & "/" & name) />
	</cfloop>
	<cfscript>
		setJavaLoader(createObject("component", "coldbox.system.extras.javaloader.JavaLoader").init(paths));

		setParser(getJavaLoader().create("info.bliki.wiki.model.WikiModel").init("/{image}", "/?page=${title}"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders out wiki text to html" access="public" returntype="string" output="false">
	<cfargument name="wikiText" hint="the wiki text to render" type="string" required="Yes">
	<cfscript>
		return getParser().render(arguments.wikiText);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getParser" access="private" returntype="any" output="false">
	<cfreturn instance.Parser />
</cffunction>

<cffunction name="setParser" access="private" returntype="void" output="false">
	<cfargument name="Parser" type="any" required="true">
	<cfset instance.Parser = arguments.Parser />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldbox.system.extras.javaloader.JavaLoader" output="false">
	<cfreturn instance.javaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldbox.system.extras.javaloader.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader />
</cffunction>

</cfcomponent>