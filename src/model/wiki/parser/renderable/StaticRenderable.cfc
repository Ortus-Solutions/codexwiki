<cfcomponent hint="Renders static content" extends="AbstractRenderable" output="false">
<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="StaticRenderable" output="false">
	<cfargument name="content" hint="the content to initialise this with" type="string" required="Yes">
	<cfscript>
		super.init(false);

		setContent(arguments.content);

		return this;
	</cfscript>
</cffunction>

<cffunction name="render" hint="renders the output" access="public" returntype="string" output="false">
	<cfreturn getContent() />
</cffunction>

<cffunction name="getContent" access="public" returntype="string" output="false">
	<cfreturn instance.Content />
</cffunction>

<cffunction name="setContent" access="public" returntype="void" output="false">
	<cfargument name="Content" type="string" required="true">
	<cfset instance.Content = arguments.Content />
</cffunction>

<cffunction name="getStringBuilderContent" hint="gets the Content in a java.lang.StringBuilder" access="public" returntype="any" output="false">
	<cfscript>
		return createObject("java", "java.lang.StringBuilder").init(getContent());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>