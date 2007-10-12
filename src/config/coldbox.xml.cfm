<?xml version="1.0" encoding="ISO-8859-1"?>
<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.coldboxframework.com/schema/config_2.5.0.xsd">
	<Settings>
		<Setting name="AppName"						value="codexwiki"/>
		<Setting name="DebugMode" 					value="true" />
		<Setting name="DebugPassword" 				value=""/>
		<Setting name="ReinitPassword" 				value=""/>
		<Setting name="EventName"					value="event" />
		<Setting name="EnableDumpVar"				value="false" />
		<Setting name="EnableColdfusionLogging" 	value="false" />
		<Setting name="EnableColdboxLogging"		value="true" />
		<Setting name="ColdboxLogsLocation"			value="logs" />
		<Setting name="DefaultEvent" 				value="wiki.dsppage"/>
		<Setting name="RequestStartHandler" 		value="main.onRequestStart"/>
		<Setting name="RequestEndHandler" 			value="main.onRequestEnd"/>
		<Setting name="ApplicationStartHandler" 	value="main.onAppInit"/>
		<Setting name="OwnerEmail" 					value="myemail@gmail.com" />
		<Setting name="EnableBugReports" 			value="false"/>
		<Setting name="UDFLibraryFile" 				value="" />
		<Setting name="ExceptionHandler"			value="main.onException" />
		<Setting name="onInvalidEvent" 				value="wiki.showpage" />
		<Setting name="CustomErrorTemplate"			value="includes/generic_error.cfm" />
		<Setting name="MessageboxStyleOverride"		value="false" />
		<Setting name="HandlersIndexAutoReload"   	value="false" />
		<Setting name="ConfigAutoReload"          	value="true" />
		<Setting name="MyPluginsLocation"   		value="" />
		<Setting name="HandlerCaching" 				value="false"/>
		<Setting name="IOCFramework"				value="coldspring" />
		<Setting name="IOCDefinitionFile"			value="includes/coldspring.xml.cfm" />
		<Setting name="IOCObjectCaching"			value="false" />
	</Settings>

	<YourSettings>
		<!--Transfer Settings -->
		<Setting name="Transfer.dsnPath"          value="config/datasource.xml.cfm" />
		<Setting name="Transfer.configPath"       value="config/transfer.xml.cfm" />
		<Setting name="Transfer.definitionsPath"  value="config/definitions" />
		
	</YourSettings>

	<MailServerSettings>
		<MailServer></MailServer>
		<MailPort></MailPort>
		<MailUsername></MailUsername>
		<MailPassword></MailPassword>
	</MailServerSettings>

	<BugTracerReports></BugTracerReports>

	<DevEnvironments>
		<url>dev</url>
		<url>dev1</url>
	</DevEnvironments>

	<WebServices></WebServices>

	<Layouts>
		<!--Declare the default layout, MANDATORY-->
		<DefaultLayout>Layout.Main.cfm</DefaultLayout>
		
		<!--Default View, OPTIONAL
		<DefaultView>home</DefaultView>
		-->
		
		<!--
		Declare other layouts, with view assignments if needed, else do not write them
		<Layout file="Layout.Popup.cfm" name="popup">
			<View>vwTest</View>
			<View>vwMyView</View>
		</Layout>
		-->
	</Layouts>

	<i18N />
	
	<Datasources />
	
	<Cache>
		<ObjectDefaultTimeout>30</ObjectDefaultTimeout>
		<ObjectDefaultLastAccessTimeout>10</ObjectDefaultLastAccessTimeout>
		<ReapFrequency>1</ReapFrequency>
		<MaxObjects>50</MaxObjects>
		<FreeMemoryPercentageThreshold>1</FreeMemoryPercentageThreshold>
	</Cache>
	
	<!-- Interceptor Declarations 
	<Interceptors>
		<CustomInterceptionPoints>comma-delimited list</CustomInterceptionPoints>
		<Interceptor class="full class name">
			<Property name="myProp">value</Property>
			<Property name="myArray">[1,2,3]</Property>
			<Property name="myStruct">{ key1:1, key2=2 }</Property>
		</Inteceptor>
		<Interceptor class="no property" />
	</Interceptors>
	-->
	
</Config>
