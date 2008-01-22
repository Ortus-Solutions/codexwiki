<?xml version="1.0" encoding="ISO-8859-1"?>
<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://www.coldboxframework.com/schema/config_2.5.0.xsd">
	<Settings>
		<Setting name="AppName"						value="codexwiki"/>
		<Setting name="DebugMode" 					value="false" />
		<Setting name="DebugPassword" 				value=""/>
		<Setting name="ReinitPassword" 				value=""/>
		<Setting name="EventName"					value="event" />
		<Setting name="EnableDumpVar"				value="false" />
		<Setting name="EnableColdfusionLogging" 	value="false" />
		<Setting name="EnableColdboxLogging"		value="true" />
		<Setting name="ColdboxLogsLocation"			value="logs" />
		<Setting name="DefaultEvent" 				value="wiki.show"/>
		<Setting name="RequestStartHandler" 		value="main.onRequestStart"/>
		<Setting name="RequestEndHandler" 			value="main.onRequestEnd"/>
		<Setting name="ApplicationStartHandler" 	value="main.onAppInit"/>
		<Setting name="OwnerEmail" 					value="myemail@gmail.com" />
		<Setting name="EnableBugReports" 			value="false"/>
		<Setting name="UDFLibraryFile" 				value="" />
		<Setting name="ExceptionHandler"			value="main.onException" />
		<Setting name="onInvalidEvent" 				value="wiki.show" />
		<Setting name="CustomErrorTemplate"			value="" />
		<Setting name="MessageboxStyleOverride"		value="false" />
		<Setting name="HandlersIndexAutoReload"   	value="false" />
		<Setting name="ConfigAutoReload"          	value="false" />
		<Setting name="MyPluginsLocation"   		value="" />
		<Setting name="HandlerCaching" 				value="true"/>
		<Setting name="IOCFramework"				value="coldspring" />
		<Setting name="IOCDefinitionFile"			value="config/coldspring.xml.cfm" />
		<Setting name="IOCObjectCaching"			value="false" />
	</Settings>

	<YourSettings>
		<!--Transfer Settings -->
		<Setting name="Transfer.datasourcePath" 	value="/codex/config/datasource.xml.cfm"/>
		<Setting name="Transfer.configPath" 		value="/codex/config/transfer.xml.cfm"/>
		<Setting name="Transfer.definitionPath" 	value="/codex/config/definitions"/>	
		<!-- Page Show Key -->
		<Setting name="showKey" 					value="show"/>
	</YourSettings>

	<MailServerSettings />

	<BugTracerReports />

	<DevEnvironments />
	
	<WebServices />

	<Layouts>
		<!--Declare the default layout, MANDATORY-->
		<DefaultLayout>Layout.Main.cfm</DefaultLayout>
	</Layouts>

	<i18N />

	<Datasources />

	<Cache>
		<ObjectDefaultTimeout>30</ObjectDefaultTimeout>
		<ObjectDefaultLastAccessTimeout>15</ObjectDefaultLastAccessTimeout>
		<ReapFrequency>1</ReapFrequency>
		<MaxObjects>50</MaxObjects>
		<FreeMemoryPercentageThreshold>5</FreeMemoryPercentageThreshold>
		<UseLastAccessTimeouts>true</UseLastAccessTimeouts>
		<EvictionPolicy>LFU</EvictionPolicy>
	</Cache>

	<Interceptors>
        <CustomInterceptionPoints>onWikiPageTranslate</CustomInterceptionPoints>
		<Interceptor class="coldbox.system.interceptors.autowire">
			<Property name="debugMode">false</Property>
		</Interceptor>
		<Interceptor class="coldbox.system.interceptors.environmentControl">
			<Property name="configFile">config/environments.xml.cfm</Property>
		</Interceptor>
		<Interceptor class="coldbox.system.interceptors.ses">
			<Property name="configFile">config/routes.cfm</Property>
		</Interceptor>		
		
		<Interceptor class="codex.interceptors.wiki.WikiText" />
	</Interceptors>


</Config>
