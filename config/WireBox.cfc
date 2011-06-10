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
* @hint Codex Platform WireBox Configuration File
**/
component extends="coldbox.system.ioc.config.Binder"{
	
	/**
	* Configure WireBox, that's it!
	*/
	function configure(){
		
		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			},
			// DSL Namespace registrations
			customDSL = {},
			// Custom Storage Scopes
			customScopes = {},
			// Package scan locations
			scanLocations = [],
			// Stop Recursions
			stopRecursions = [],
			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",
			// Register all event listeners here, they are created in the specified order
			listeners = []			
		};
		
		// ColdBox Related Objects
		map("ColdBoxController").toDSL("coldbox");
		map("InterceptorService").toDSL("coldbox:interceptorService");
		map("ConfigBean").toDSL("coldbox:configBean");
		map("ColdboxOCM").toDSL("cachebox:default");
		map("BeanInjector").toDSL("wirebox");
		map("sessionstorage").toDSL("coldbox:plugin:sessionStorage");
		map("CodexDatasource").toDSL("coldbox:datasource:codex");
			
		// Transfer Related Objects
		mapPath("coldbox.system.orm.transfer.TransferConfigFactory").asSingleton();
		map("TransferConfig").toFactoryMethod(factory="TransferConfigFactory",method="getTransferConfig")
			.methodArg(name="configPath",value=getProperty("Transfer_configPath"))
			.methodArg(name="definitionPath",value=getProperty("Transfer_definitionPath"))
			.methodArg(name="dsnBean",ref="CodexDatasource");
		mapPath("coldbox.system.orm.transfer.TDOBeanInjectorObserver")
			.initArg(name="Transfer",ref="Transfer")
			.initArg(name="ColdBoxBeanFactory",ref="BeanInjector")
			.asSingleton().asEagerInit();
		mapPath("transfer.TransferFactory")
			.initArg(name="configuration",ref="TransferConfig")
			.asSingleton();
		map("Transfer")
			.toFactoryMethod(factory="TransferFactory",method="getTransfer")
			.asSingleton();
		map("Datasource").toFactoryMethod(factory="TransferFactory",method="getDatasource")
			.asSingleton();
		map("Transaction").toFactoryMethod(factory="TransferFactory",method="getTransaction")
			.asSingleton();
		
		// Utilities
		mapPath("codex.model.transfer.BeanPopulator")
			.asSingleton();
		mapPath("codex.model.util.JavaLoader")
			.asSingleton().asEagerInit();
		mapPath("codex.model.lookups.LookupService")
			.asSingleton();
			
		// Wiki services
		mapPath("codex.model.wiki.WikiService")
			.asSingleton();
		mapPath("codex.model.wiki.HTML2WikiConverter")
			.asSingleton();
		mapPath("codex.model.comments.CommentsService")
			.asSingleton();
		mapPath("codex.model.wiki.ConfigService")
			.asSingleton();
		
		// Search Integration
		mapPath("codex.model.search.SearchFactory")
			.asSingleton();
		map("SearchEngine").toFactoryMethod(factory="SearchFactory",method="getSearchEngine")
			.asSingleton();
		
		// Wiki Parsers
		mapPath("codex.model.wiki.parser.WikiText")
			.asSingleton();
		mapPath("codex.model.wiki.parser.WikiPlugins")
			.asSingleton();
		mapPath("codex.model.wiki.parser.Feed")
			.asSingleton();
		mapPath("codex.model.wiki.parser.MessageBox")
			.asSingleton();
			
		// RSS Managers
		mapPath("codex.model.rss.RSSManager")
			.asSingleton();
			
		// Data Managers
		mapPath("codex.model.data.DataManager")
			.asSingleton();
			
		// Security Services
		mapPath("codex.model.security.SecurityService")
			.setter(name="sessionstorage",ref="sessionstorage")
			.asSingleton();
		mapPath("codex.model.security.UserService")
			.asSingleton();
	}	

}