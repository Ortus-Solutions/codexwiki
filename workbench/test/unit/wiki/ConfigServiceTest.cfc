<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="ConfigServiceTest" extends="codexwiki.workbench.test.resources.BaseTest" output="false">
	
	<cfscript>
		this.loadColdbox = true;
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false">
		<cfscript>
		//Call the super setup method to setup the app.
		super.setup();
		
		this.cs = getBean("ConfigService");
		</cfscript>
	</cffunction>
	
	<cffunction name="testSettingExists" access="public" returntype="void" output="false">
		<cfscript>
			AssertFalse(this.cs.settingExists('App'));
			AssertTrue(this.cs.settingExists('AppMapping'));
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetSetting" access="public" returntype="void" output="false">
		<cfscript>
			AssertTrue(this.cs.getSetting("AppMapping").length());
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetConfigBean" access="public" returntype="void" output="false">
		<cfscript>
			AssertTrue(isObject(this.cs.getConfigBean()));
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetOptions" access="public" returntype="void" output="false">
		<cfscript>
			options = this.cs.getOptions();
			
			AssertFalse( structisEmpty(options) );
			option = this.cs.getOption(name="wiki_name");
			AssertTrue( option.getIsPersisted() );
		</cfscript>
	</cffunction>
	
	
</cfcomponent>