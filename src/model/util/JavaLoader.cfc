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
<cfcomponent name="JavaLoader" 
			 hint="The Java Loader facade. This object loads and sets up the java loader. We do this, so this object can be shared throughtout the application. Not only the parser" 
			 output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" returntype="JavaLoader" output="false">
		<cfargument name="configService" 	hint="the configuration service" type="codex.model.wiki.ConfigService" required="Yes">
		<cfscript>
			var paths = "";
			
			/* Path Location of Lib */
			instance.libPath = expandPath("/codex/model/wiki/parser/lib/bliki/");
			/* Set Static ID for this Application */
			setstaticIDKey("cbox-javaloader-#hash(arguments.configService.getSetting('ApplicationPath'))#");
			/* Get Libs */
			paths = queryJars(instance.libPath);
			/* Set it up */
			setup(loadPaths=paths);
			
			return this;
		</cfscript>
	</cffunction>
	
	<!--- Setup the Loader --->
	<cffunction name="setup" hint="setup the loader" access="public" returntype="any" output="false">
		<!--- ************************************************************* --->
		<cfargument name="loadPaths" hint="An array of directories of classes, or paths to .jar files to load" 
					type="array" default="#ArrayNew(1)#" required="no">
		<cfargument name="loadColdFusionClassPath" hint="Loads the ColdFusion libraries" 
					type="boolean" required="No" default="false">
		<cfargument name="parentClassLoader" hint="(Expert use only) The parent java.lang.ClassLoader to set when creating the URLClassLoader" 
					type="any" default="" required="false">
		<!--- ************************************************************* --->
			<cfset var JavaLoader = "">
			
			<!--- setup the javaloader --->
			<cfif ( not isJavaLoaderInScope() )>
				<cflock name="#getStaticIDKey()#" throwontimeout="true" timeout="30" type="exclusive">
					<cfif ( not isJavaLoaderInScope() )>
						<!--- Place java loader in scope, create it. --->
						<cfset setJavaLoaderInScope( CreateObject("component","coldbox.system.extras.javaloader.JavaLoader").init(argumentCollection=arguments) )>
					</cfif>
				</cflock>
			<cfelse>
				<cflock name="#getStaticIDKey()#" throwontimeout="true" timeout="30" type="readonly">
					<!--- Get the javaloader. --->
					<cfset getJavaLoaderFromScope().init(argumentCollection=arguments)>
				</cflock>
			</cfif>
	</cffunction>

	<!--- Create a Class --->
	<cffunction name="create" hint="Retrieves a reference to the java class. To create a instance, you must run init() on this object" access="public" returntype="any" output="false">
		<cfargument name="className" hint="The name of the class to create" type="string" required="Yes">
		<cfreturn getJavaLoaderFromScope().create(argumentCollection=arguments)>
	</cffunction>

	<!--- Get URL Class Loader --->
	<cffunction name="getURLClassLoader" hint="Returns the java.net.URLClassLoader in case you need access to it" access="public" returntype="any" output="false">
		<cfreturn getJavaLoaderFromScope().getURLClassLoader() />
	</cffunction>

	<!--- Get This Version --->
	<cffunction name="getVersion" hint="Retrieves the version of the loader you are using" access="public" returntype="string" output="false">
		<cfreturn getJavaLoaderFromScope().getVersion()>
	</cffunction>
	
	<!--- Get the static javaloder id --->
	<cffunction name="getstaticIDKey" access="public" returntype="string" output="false" hint="Return the original server id static key">
		<cfreturn instance.staticIDKey>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- setJavaLoaderInScope --->
	<cffunction name="setJavaLoaderInScope" output="false" access="private" returntype="any" hint="Set the javaloader in server scope">
		<!--- ************************************************************* --->
		<cfargument name="javaloader" required="true" type="coldbox.system.extras.javaloader.javaLoader" hint="The javaloader instance to scope">
		<!--- ************************************************************* --->
		<cfscript>
			structInsert(server, getstaticIDKey(), arguments.javaloader);
		</cfscript>
	</cffunction>
	
	<!--- getJavaLoaderFromScope --->
	<cffunction name="getJavaLoaderFromScope" output="false" access="private" returntype="any" hint="Get the javaloader from server scope">
		<cfscript>
			return server[getstaticIDKey()];
		</cfscript>
	</cffunction>
	
	<!--- isJavaLoaderInScope --->
	<cffunction name="isJavaLoaderInScope" output="false" access="private" returntype="boolean" hint="Checks if the javaloader has been loaded into server scope">
		<cfscript>
			return structKeyExists( server, getstaticIDKey());
		</cfscript>
	</cffunction>	
	
	<!--- set the static javaloader id --->
	<cffunction name="setstaticIDKey" access="private" returntype="void" output="false">
		<cfargument name="staticIDKey" type="string" required="true">
		<cfset instance.staticIDKey = arguments.staticIDKey>
	</cffunction>
	
	<!--- Get the jars for our search ESP --->
	<cffunction name="queryJars" hint="pulls a query of all the jars in the folder passed" access="private" returntype="array" output="false">
		<cfargument name="dirPath" type="string" required="true" default="" hint="The directory path to query"/>
		<cfargument name="filter" type="string" required="false" default="*.jar" hint="The directory filter to use"/>
	
		<cfset var qJars = 0>
		<cfset var aJars = ArrayNew(1)>
		<!--- Path To Jar Library --->
		<cfset var path = arguments.dirPath>
		
		<!--- Verify It --->
		<cfif not directoryExists(path)>
			<cfthrow message="Invalid library path" detail="The path is #path#" type="JavaLoader.DirectoryNotFoundException">
		</cfif>
		
		<!--- Get Listing --->
		<cfdirectory action="list" name="qJars" directory="#path#" filter="#arguments.filter#" sort="name desc"/>
		
		<!--- Loop and create the array that we will use to load. --->
		<cfloop query="qJars">
			<cfset ArrayAppend(aJars, directory & "/" & name)>
			<cfset println("Loading: #name#") />
		</cfloop>
	
		<cfreturn aJars>
	</cffunction>
	
	<!--- Print Ln --->
	<cffunction name="println" access="private" returntype="void" output="false">
		<cfargument name="str" type="string" required="Yes">
		<cfscript>
			createObject("Java", "java.lang.System").out.println(arguments.str);
		</cfscript>
	</cffunction>

	
</cfcomponent>
