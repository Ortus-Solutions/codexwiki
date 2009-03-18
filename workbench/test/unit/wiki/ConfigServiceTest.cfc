<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="ConfigServiceTest" extends="coldbox.system.extras.testing.baseMXUnitTest" output="false">
	
	<cfscript>
		//Uncomment the following if you dont' need the controller in application scope for testing.
		//this.PERSIST_FRAMEWORK = false;
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false">
		<cfscript>
		//Setup ColdBox Mappings For this Test
		setAppMapping("/codex");
		setConfigMapping(ExpandPath(instance.AppMapping & "/config/coldbox.xml.cfm"));
			
		//Call the super setup method to setup the app.
		super.setup();
		
		this.cs = getController().getPlugin("ioc").getBean("ConfigService");
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