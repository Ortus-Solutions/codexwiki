<!--- 
LICENSE 
Copyright 2008 Brian Kotek

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

File Name: 

	TDOBeanInjectorObserver.cfc (Transfer Decorator Object Bean Injector Observer)

Description: 

	This is a Transfer Observer that will autowire your Transfer Decorators with matching beans from
	ColdSpring when the Decorator is created. This makes it much easier to create "rich" Decorators that can handle
	much more business logic than standard Transfer Objects. The dependencies are cached by this Observer for performance. 
	After the first instance of a Decorator is created, all subsequent Decorators of that type will have their dependencies
	injected using cached information. The component is thread-safe.

Usage:

	Usage of the Observer is fairly straightforward. The ColdSpring XML file might look like this:
	
		<bean id="transferFactory" class="transfer.transferFactory">
		   <constructor-arg name="datasourcePath"><value>/project/config/datasource.xml</value></constructor-arg>
		   <constructor-arg name="configPath"><value>/project/config/transfer.xml</value></constructor-arg>
		   <constructor-arg name="definitionPath"><value>/project/transfer/definitions</value></constructor-arg>
		</bean>
		
		<bean id="transfer" factory-bean="transferFactory" factory-method="getTransfer" />
		
		<bean id="TDOBeanInjectorObserver" class="tests.transfer.TDOBeanInjectorObserver" lazy-init="false">
			<constructor-arg name="transfer"><ref bean="transfer" /></constructor-arg>
		</bean>
		
		<bean id="validatorFactory" class="components.ValidatorFactory" />
	
	Your ColdSpring configuration must be set to inject the Transfer object into the Observer as a constructor argument. 
	The Observer will register itself with Transfer using the transfer.addAfterNewObserver() method. To ensure that this 
	happens at application startup, you have two options:
	
	1. Use the latest version of ColdSpring that supports lazy-init. What this means is that ColdSpring will automatically
	construct all beans that have lazy-init="false" defined in the ColdSpring XML (as the TDOBeanInjectorObserver bean is in
	the above config snippet). You tell ColdSpring to construct all non-lazy beans when you create the BeanFactory:
	
		<cfset beanFactory.loadBeans(beanDefinitionFile=configFileLocation, constructNonLazyBeans=true) />
	
	Using this approach, the TDOBeanInjectorObserver will be registerd with Transfer without you have to do anything else.
	
	2. On older versions of ColdSpring, or if you do not wish to use the lazy-init capability, the only additional step
	required is to create an instance of the Observer after you initialize ColdSpring, like this:
	
		<cfset beanFactory.loadBeans(beanDefinitionFile=configFileLocation) />
		<cfset beanFactory.getBean('TDOBeanInjectorObserver') />
		
	This ensures that the Observer is constructed and registers itself with Transfer.
	
	Your Transfer Decorator would have public setter method(s) for the bean(s) you want to inject, for example:
	
		<cffunction name="setValidatorFactory" access="public" returntype="void" output="false" hint="I set the ValidatorFactory.">
			<cfargument name="validatorFactory" type="any" required="true" hint="ValidatorFactory" />
			<cfset variables.instance.validatorFactory = arguments.validatorFactory />
		</cffunction>
	
	Once the Observer is registered with Transfer, any time you create a Transfer Decorator, the Observer will
	automatically inject any dependent beans into it at creation time. So in the above example, as soon as the
	Decorator is created, it will automatically have the ValidatorFactory injected into it via the setValidatorFactory()
	method. The end result is that any setters in your Decorators that have matching bean IDs in ColdSpring will have those 
	beans injected automatically. As an additional example, a bean with an ID of "productService" would be autowired
	into a Decorator that had a public setter method named setProductService(), and so on.
	
	There is an optional constructor argument called "suffixList" that can be supplied. This is a comma-delimited list
	of propery name suffixes that will be allowed. If you specify a suffixList, the Observer will only inject beans which
	end in one of the suffixes in the list. For example, if you specify a suffixList of "service", setter methods for
	setUserService() and setLoginService() would be called, but setter methods for setValidatorFactory() or setContext()
	would NOT be called. This can be useful in rare situations where your Transfer Object may have database-driven properties
	that conflict with the names of ColdSpring beans. Most people probably won't need to worry about this, but the option
	is here in case the issue arises.
	
	In case you have problems determining whether beans are being properly injected into your Decorators, there is
	an optional init() method argument called "debugMode". By default, this is false. If you set it to true via the ColdSpring
	XML config file, the component will trace successful dependency injections to the debugging output. It will also
	rethrow any errors that occur while trying to inject beans into your Decorators. Obviously, ensure that this is
	remains off in production.

--->

<cfcomponent name="TDOBeanInjectorObserver" hint="">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfargument name="transfer" type="transfer.com.Transfer" required="true" />
		<cfargument name="suffixList" type="string" required="false" default="" />
		<cfargument name="debugMode" type="boolean" required="false" default="false" />
		<cfset variables.DICache = StructNew() />
		<cfset variables.debugMode = arguments.debugMode />
		<cfset variables.suffixList = arguments.suffixList />
		<cfset arguments.transfer.addAfterNewObserver(this) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="actionAfterNewTransferEvent" hint="Do something on the new object" access="public" returntype="void" output="false">
	    <cfargument name="event" hint="" type="transfer.com.events.TransferEvent" required="Yes">
		<cfset var objMetaData = "" />

		<!--- If the DI resolution has already been cached, inject from the cache. --->
		<cfif StructKeyExists(variables.DICache, arguments.event.getTransferObject().getClassName())>
			<cfset injectCachedBeans(arguments.event) />
		<cfelse>
		
			<!--- Double-checked lock based on Transfer Object Class Name to handle race conditions. --->
			<cflock name="Lock_TDOBeanInjectorObserver_#arguments.event.getTransferObject().getClassName()#" type="exclusive" timeout="5" throwontimeout="true">
				
				<cfif StructKeyExists(variables.DICache, arguments.event.getTransferObject().getClassName())>
					<cfset injectCachedBeans(arguments.event) />
				<cfelse>	
					<!--- Create a new cache element for this TDO. --->
					<cfset variables.DICache[arguments.event.getTransferObject().getClassName()] = StructNew() />
					
					<!--- Get the metadata for the TDO. --->
					<cfset objMetaData = GetMetaData(arguments.event.getTransferObject()) />
			    	
			    	<!--- Recurse the inheritance tree of the TDO and attempt to resolve dependencies. --->
			    	<cfset performDIRecursion(arguments.event.getTransferObject(), objMetaData) />
				</cfif>
				
			</cflock>
			
		</cfif>
	</cffunction>
	
	<cffunction name="injectCachedBeans" access="private" returntype="void" output="false" hint="">
		<cfargument name="event" type="transfer.com.events.TransferEvent" required="Yes">
		<cfset var thisProperty = "" />
		<cfif StructCount(variables.DICache[arguments.event.getTransferObject().getClassName()]) gt 0>
			<cfloop collection="#variables.DICache[arguments.event.getTransferObject().getClassName()]#" item="thisProperty">
				<cfset injectBean(arguments.event.getTransferObject(), thisProperty, variables.DICache[arguments.event.getTransferObject().getClassName()][thisProperty]) />
				<cfif variables.debugMode><cftrace text="The cached dependency #thisProperty# was successfully injected into #arguments.event.getTransferObject().getClassName()#." inline="false"></cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="injectBean" access="private" returntype="void" output="false" hint="">
		<cfargument name="targetObject" type="any" required="true" />
		<cfargument name="propertyName" type="string" required="true" />
		<cfargument name="propertyValue" type="any" required="true" />
		<cfinvoke component="#arguments.targetObject#" method="set#arguments.propertyName#">
			<cfinvokeargument name="#arguments.propertyName#" value="#arguments.propertyValue#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="performDIRecursion" access="private" returntype="void" output="false" hint="">
		<cfargument name="targetObject" type="any" required="true" />
		<cfargument name="metaData" type="struct" required="true" />
		<cfset var thisFunction = "" />
		<cfset var propertyName = "" />
		<cfset var thisSuffix = "" />
		<cfset var suffixMatch = true />
		
		<!--- If the metadata element has functions, attempt to resolve dependencies. --->
		<cfif StructKeyExists(arguments.metadata, 'functions')>
			<cfloop from="1" to="#ArrayLen(arguments.metaData.functions)#" index="thisFunction">
				<cfif Left(arguments.metaData.functions[thisFunction].name, 3) eq "set" 
						and (not StructKeyExists(arguments.metaData.functions[thisFunction], 'access') 
							 or 
							 arguments.metaData.functions[thisFunction].access eq 'public')>
					<cfset propertyName = Right(arguments.metaData.functions[thisFunction].name, Len(arguments.metaData.functions[thisFunction].name)-3) />
					<cftry>
						
						<cfif getBeanFactory().containsBean(propertyName)>
							
							<!--- If a suffix List is defined, confirm that the property has the proper suffix. --->
							<cfif Len(variables.suffixList)>
								<cfset suffixMatch = false />
								<cfloop list="#variables.suffixList#" index="thisSuffix" delimiters=",">
									<cfif Right(propertyName, Len(thisSuffix)) eq thisSuffix>
										<cfset suffixMatch = true />
										<cfbreak />
									</cfif>
								</cfloop>
							</cfif>
							
							<cfif suffixMatch>
							
								<!--- Try to call the setter. --->
								<cfset injectBean(arguments.targetObject, propertyName, getBeanFactory().getBean(propertyName)) />
								
								<!--- If the set was successful, add a cache reference to the bean for the current TDO property. --->						
								<cfset variables.DICache[arguments.targetObject.getClassName()][propertyName] = getBeanFactory().getBean(propertyName) />
								
								<cfif variables.debugMode><cftrace text="The dependency #propertyName# was successfully injected into #arguments.targetObject.getClassName()# and cached." inline="false"></cfif>
							
							</cfif>
								
						</cfif>
						
						<cfcatch type="any">
							<!--- Bean injection failed. --->
							<cfif variables.debugMode><cfrethrow /></cfif>
						</cfcatch>
						
					</cftry>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- If the metadata element extends another component, recurse that component. --->		
		<cfif StructKeyExists(arguments.metadata, 'extends') and arguments.metadata.extends.name neq "transfer.com.TransferDecorator">
			<cfset performDIRecursion(arguments.targetObject, arguments.metaData.extends) />
		</cfif>
	</cffunction>
	
	<!--- Dependency injection methods for Bean Factory. --->
	<cffunction name="getBeanFactory" access="public" returntype="any" output="false" hint="I return the BeanFactory.">
		<cfreturn variables.instance.beanFactory />
	</cffunction>
		
	<cffunction name="setBeanFactory" access="public" returntype="void" output="false" hint="I set the BeanFactory.">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.instance.beanFactory = arguments.beanFactory />
	</cffunction>

</cfcomponent>