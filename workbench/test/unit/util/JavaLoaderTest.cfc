<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="ConfigServiceTest" extends="codexwiki.workbench.test.resources.BaseTest" output="false">

	<cffunction name="setUp" returntype="void" access="public" output="false">
		<cfscript>
		this.loadColdbox = false;
		super.setup();
		
		mockConfigService = getMockFactory().createMock("codex.model.wiki.ConfigService");
		mockConfigService.mockMethod("getSetting",getMetadata(this).path);
		
		javaloader = createObject("component","codex.model.util.JavaLoader");
		
		</cfscript>
	</cffunction>
	
	<cffunction name="teardown">
		<cfif structkeyExists(variables,"javaloader")>
			<cfset structdelete(server,javaloader.getstaticIDKey())>
		</cfif>
		<cfset super.teardown()>
	</cffunction>
	
	<!--- testLoading --->
	<cffunction name="testInit">
		<cfscript>
			javaloader = javaloader.init(mockConfigService);
			
			obj = javaloader.create("info.bliki.html.HTML2WikiConverter");
			
			AssertTrue( isObject(obj) );
			
		</cfscript>
	</cffunction>
	
	
	
</cfcomponent>