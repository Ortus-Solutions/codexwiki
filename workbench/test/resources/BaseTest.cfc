<cfcomponent output="false" extends="coldbox.system.extras.testing.baseMXUnitTest" >
	
	<cfscript>
		instance = structnew();
		
		/* Public Properties */
		this.loadColdbox = false;
		
		/* Our testing COldBox config */
		instance.testConfigPath = getDirectoryFromPath(getMetadata(this).path) & "coldbox.xml.cfm";
		/* Our Mock factory, from coldbox 3.0 */
		instance.mockFactory = createObject("component","codexwiki.workbench.test.resources.MockFactory").init();
	</cfscript>

	<cffunction name="setup" output="false" access="public" returntype="any" hint="">
		<cfscript>
			if( this.loadColdbox ){
				/* prepare cbox app */
				setAppMapping("/codex");
				setConfigMapping(instance.testConfigPath);
				/* boot it */
				super.setup();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="teardown" output="false" access="public" returntype="any" hint="">
		<cfscript>
			if( this.loadColdbox ){
				super.teardown();
			}				
		</cfscript>
	</cffunction>
	
	
<!------------------------------------------- UTILITY METHODS ------------------------------------------>

	<!--- getMockFactory --->
	<cffunction name="getMockFactory" output="false" access="private" returntype="any" hint="Get the mock Factory">
		<cfreturn instance.mockFactory>
	</cffunction>
	
	<!--- getBean --->
	<cffunction name="getBean" output="false" access="private" returntype="any" hint="Get a bean">
		<cfargument name="beanName" type="string" required="true" hint="The bean name to retrieve from the object factory">
		<cfreturn getController().getPlugin("ioc").getBean(arguments.beanName)>
	</cffunction>
	
	<cffunction name="dumpit" access="private" hint="Facade for cfmx dump" returntype="void">
		<cfargument name="var" required="yes" type="any">
		<cfargument name="abort" type="boolean" required="false" default="false"/>
		<cfdump var="#var#"><cfif arguments.abort><cfabort></cfif>
	</cffunction>
	<cffunction name="abortit" access="private" hint="Facade for cfabort" returntype="void" output="false">
		<cfabort>
	</cffunction>	
	<cffunction name="throwit" access="private" hint="Facade for cfthrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="message" 	type="string" 	required="yes">
		<cfargument name="detail" 	type="string" 	required="no" default="">
		<cfargument name="type"  	type="string" 	required="no" default="Framework">
		<!--- ************************************************************* --->
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#">
	</cffunction>	
	<cffunction name="sleeper" access="private" returntype="void" output="false" hint="Make the main thread of execution sleep for X amount of seconds.">
		<!--- ************************************************************* --->
		<cfargument name="milliseconds" type="numeric" required="yes" hint="Milliseconds to sleep">
		<!--- ************************************************************* --->
		<cfset CreateObject("java", "java.lang.Thread").sleep(arguments.milliseconds)>
	</cffunction>	

</cfcomponent>