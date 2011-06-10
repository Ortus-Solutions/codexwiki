/**
********************************************************************************
* Copyright Since 2011 CodexPlatform
* www.codexplatform.com | www.coldbox.org | www.ortussolutions.com
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
* @author Luis Majano
* @hint Codex Platform ColdBox Configuration File
**/
component{

	// Configure ColdBox Application
	function configure(){
	
		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Codex-Platform",
			
			//Development Settings
			debugMode				= false,
			debugPassword			= "",
			reinitPassword			= "",
			handlersIndexAutoReload = false,
			configAutoReload		= false,
			
			//Implicit Events
			defaultEvent			= "Page.show",
			requestStartHandler		= "Main.onRequestStart",
			requestEndHandler		= "Main.onRequestEnd",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "Main.onMissingTemplate",
			
			//Extension Points
			UDFLibraryFile 				= "includes/helpers/ApplicationHelper.cfm",
			coldboxExtensionsLocation 	= "",
			modulesExternalLocation		= [],
			pluginsExternalLocation 	= "",
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "codex.model.coldbox.RequestContextDecorator",
			
			//Error/Exception Handling
			exceptionHandler		= "Main.onException",
			onInvalidEvent			= "",
			customErrorTemplate		= "",
				
			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			proxyReturnCollection 	= false,
			flashURLPersistScope	= "session"	
		};
	
		// Codex Settings
		settings = {
			// messagebox style override
			messagebox_style_override = true,
			// Codex info
			Codex = { version = "1.0.0", Suffix = "Alpha" },
			// Transfer Integration
			Transfer_configPath = "/codex/config/transfer.xml.cfm",
			Transfer_definitionPath = "/codex/config/definitions",
			// RSS Settings
			RSSTempDirectory = "/codex/model/rss/tmp",
			// WIKI URL Prefix Keys
			showKey = "wiki",
			spaceKey = "space",
			/** Using Rewrite: boolean flag that determines if using rewrite or onMissingTemplate() approaches.
		    	True:  means you are using mod_rewrite or any other rewrite engine. Then .cfm extension are eliminated from URL's
		     	False: means you are using onMissinTemplate() to simulate SEO, so a .cfm will be appended to every URL to simulate a template.
		     **/
			usingRewrite = true,
			
			// Lookup Transfer Scaffolding
			lookups_tables = {
				Permissions 		= "security.Permission", 
				Roles 				= "security.Role", 
				"Security Rules" 	= "security.SecurityRules",
				"System Options"  	= "wiki.Option"
			},
			lookups_imgPath 	= "includes/lookups/images",
			lookups_cssPath 	= "includes/lookups/styles",
			lookups_jsPath 		= "includes/lookups/js",
			lookups_packagePath = "admin",
			lookups_dsn			= "codex"
		};
		
		// Environments
		environments = {
			development = "^cf9.,^railo."
		};
		
		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = [] 
		};
		
		//LogBox
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" },
				fileAppender  = { class="coldbox.system.logging.appenders.AsyncRollingFileAppender",
								  properties = {
								  	filePath="logs", fileName=coldbox.appName
								 }}
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ],
			debug = ["coldbox.system.ioc"]
		};
		
		//Layout Settings
		layoutSettings = {
			defaultLayout = "Layout.Main.cfm"
		};
		//Register Layouts
		layouts = [
			{ name = "AdminLayout",
		 	  file = "Layout.Admin.cfm",
			  folders = "admin"
			}
		];
		
		//WireBox Integration
		wireBox = { 
			enabled = true,
			singletonReload=false 
		};
		
		//Datasources
		datasources = {
			codex   = {name="codex", dbType="mysql", username="", password=""}
		};
		
		//Interceptor Settings
		interceptorSettings = {
			customInterceptionPoints = "onWikiPageTranslate"
		};
		
		//Register interceptors as an array, we need order
		interceptors = [
			//Autowire
			{class="coldbox.system.Interceptors.Autowire",
			 	properties={
			 		entityInjection = true 
			 	}
			},
			// SES
			{class="codex.interceptors.util.SES"},
			// Codex Security
			{class="coldbox.system.Interceptors.Security", 
				properties= {
					rulesSource = "model", rulesModel = "SecurityService", rulesModelMethod = "getSecurityRules", validatorModel="SecurityService"
				}
			},
			// Wiki Translations
			{class="codex.interceptors.wiki.WikiText", name="codex-WikiText",
				properties={
					ignoreXMLTagList = "feed,messagebox,img,iframe",
					allowedAttributes = "style,url,cache,display,type,maxitems"	
				}
			},
			// RSS Translations
			{class="codex.interceptors.wiki.Feed",name="codex-Feed"},
			// MessageBox Translations
			{class="codex.interceptors.wiki.MessageBox",name="codex-MessageBox"},
			// Custom Wiki Plugins
			{class="codex.interceptors.wiki.WikiPlugins",name="codex-WikiPlugins"}
		];

	}

	/**
	* Development settings
	*/
	function development(){
		// coldbox settings
		coldbox.debugMode = false;
		coldbox.debugPassword = "";
		coldbox.reinitPassword = "";
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching = false;
		coldbox.eventCaching = false;
		coldbox.customErrorTemplate = "";	
		// wirebox
		wirebox.singletonReload = false;
		// paid modules (LM box only)
		arrayAppend(coldbox.modulesExternalLocation, "/codex/_modules");
	}

}