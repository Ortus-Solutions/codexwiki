<?xml version="1.0" encoding="utf-8"?>
<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://www.coldboxframework.com/schema/config_2.5.0.xsd">
	<Settings>
		<Setting name="AppName"						value="codexwiki"/>
		<Setting name="AppMapping"					value="/"/>
		<Setting name="DebugMode" 					value="false" />
		<Setting name="DebugPassword" 				value=""/>
		<Setting name="ReinitPassword" 				value=""/>
		<Setting name="EventName"					value="event" />
		<Setting name="EnableDumpVar"				value="false" />
		<Setting name="EnableColdfusionLogging" 	value="false" />
		<Setting name="EnableColdboxLogging"		value="true" />
		<Setting name="ColdboxLogsLocation"			value="logs" />
		<Setting name="DefaultEvent" 				value="page.show"/>
		<Setting name="RequestStartHandler" 		value="main.onRequestStart"/>
		<Setting name="RequestEndHandler" 			value="main.onRequestEnd"/>
		<Setting name="ApplicationStartHandler" 	value="main.onAppInit"/>
		<Setting name="OwnerEmail" 					value="" />
		<Setting name="EnableBugReports" 			value="false"/>
		<Setting name="UDFLibraryFile" 				value="includes/helpers/ApplicationHelper.cfm" />
		<Setting name="ExceptionHandler"			value="main.onException" />
		<Setting name="onInvalidEvent" 				value="" />
		<Setting name="CustomErrorTemplate"			value="" />
		<!--
		Uncomment and remove the setting above in order to have a custom error template 
		<Setting name="CustomErrorTemplate"			value="includes/templates/error.cfm" />
		 -->
		<Setting name="MessageboxStyleOverride"		value="true" />
		<Setting name="HandlersIndexAutoReload"   	value="false" />
		<Setting name="ConfigAutoReload"          	value="false" />
		<Setting name="MyPluginsLocation"   		value="" />
		<Setting name="HandlerCaching" 				value="true"/>
		<Setting name="EventCaching" 				value="true"/>
		<Setting name="IOCFramework"				value="coldspring" />
		<Setting name="IOCDefinitionFile"			value="/codex/config/coldspring.xml.cfm" />
		<Setting name="IOCObjectCaching"			value="false" />
		<Setting name="RequestContextDecorator" 	value="codex.model.coldbox.RequestContextDecorator"/>
	</Settings>

	<YourSettings>
		<!-- Codex System Information -->
		<Setting name="Codex"						value="{'Version':'0.5', 'Suffix':'Beta 2'}" />
		
		<!--Transfer Settings -->
		<Setting name="Transfer_configPath" 		value="/codex/config/transfer.xml.cfm"/>
		<Setting name="Transfer_definitionPath" 	value="/codex/config/definitions"/>
		
		<!-- RSS Settings -->
		<Setting name="RSSTempDirectory" 			value="/codex/model/rss/tmp"/>
		
		<!-- Wiki URL Prefix Keys, they cannot be BLANK -->
		<Setting name="ShowKey" 					value="wiki"/>
		<Setting name="SpaceKey" 					value="space"/>
		
		<!-- UsingRewrite: boolean flag that determines if using rewrite or onMissingTemplate() approaches.
		    
		     True:  means you are using mod_rewrite or any other rewrite engine. Then .cfm extension are eliminated from URL's
		     False: means you are using onMissinTemplate() to simulate SEO, so a .cfm will be appended to every URL to simulate a template.
		 -->
		<Setting name="UsingRewrite"				value="true" />
		
		<!-- Lookups Settings -->
		<Setting name="lookups_tables"				value="{'Permissions':'security.Permission', 
															'Roles':'security.Role', 
															'Security Rules':'security.SecurityRules',
															'System Options':'wiki.Option'}" />		
		<Setting name="lookups_imgPath"				value="includes/lookups/images" />
		<Setting name="lookups_cssPath"				value="includes/lookups/styles" />
		<Setting name="lookups_jsPath"				value="includes/lookups/js" />
		<Setting name="lookups_packagePath"			value="admin" />
		<Setting name="lookups_dsn"					value="codex" />
	</YourSettings>

	<MailServerSettings />

	<BugTracerReports />

	<WebServices />

	<Layouts>
		<!--Declare the default layout, MANDATORY-->
		<DefaultLayout>Layout.Main.cfm</DefaultLayout>
	</Layouts>

	<i18N />

	<Datasources>
		<Datasource alias="codex" name="codex" dbtype="mysql" username="" password=""/>
	</Datasources>

	<Cache>
		<ObjectDefaultTimeout>45</ObjectDefaultTimeout>
		<ObjectDefaultLastAccessTimeout>15</ObjectDefaultLastAccessTimeout>
		<ReapFrequency>1</ReapFrequency>
		<MaxObjects>50</MaxObjects>
		<FreeMemoryPercentageThreshold>0</FreeMemoryPercentageThreshold>
		<UseLastAccessTimeouts>true</UseLastAccessTimeouts>
		<EvictionPolicy>LRU</EvictionPolicy>
	</Cache>

	<Interceptors throwOnInvalidStates="false">
        <CustomInterceptionPoints>onWikiPageTranslate</CustomInterceptionPoints>
		<!-- Environment Control -->
		<Interceptor class="coldbox.system.interceptors.environmentControl">
			<Property name="configFile">config/environments.xml.cfm</Property>
		</Interceptor>
		<!-- autowire -->
		<Interceptor class="coldbox.system.interceptors.autowire" />
		<!-- Custom SES -->
		<Interceptor class="codex.interceptors.util.ses">
			<Property name="configFile">config/routes.cfm</Property>
		</Interceptor>
		<!-- Security -->
		<Interceptor class="coldbox.system.interceptors.security">
			<Property name="useRoutes">true</Property>
			<Property name="queryChecks">false</Property>
			<Property name="rulesSource">ioc</Property>
			<Property name="rulesBean">SecurityService</Property>
			<Property name="rulesBeanMethod">getSecurityRules</Property>
			<Property name="validatorIOC">SecurityService</Property>
		</Interceptor>
		
		<!-- Wiki Translation -->
		<Interceptor class="codex.interceptors.wiki.WikiText">
			<Property name="ignoreXMLTagList">feed,messagebox,img</Property>
			<Property name="allowedAttributes">style,url,cache,display,type,maxitems</Property>
		</Interceptor>
		<!-- Feed Translations -->
		<Interceptor class="codex.interceptors.wiki.Feed">
		</Interceptor>
		<!-- MessageBox Translations -->
		<Interceptor class="codex.interceptors.wiki.MessageBox">
		</Interceptor>	
		<!-- Custom Wiki Plugins -->
		<Interceptor class="codex.interceptors.wiki.WikiPlugins">
		</Interceptor>		
		
	</Interceptors>


</Config>
