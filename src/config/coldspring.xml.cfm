<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE beans SYSTEM "/home/mark/wwwroot/codexWiki/src/config/spring-beans.dtd">
<beans default-autowire="byName">

	<!--Transfer Factory: PERSISTANCE MANAGED BY COLDSPRING -->
	<bean id="TransferFactory" class="transfer.TransferFactory" singleton="true" autowire="no">
		<constructor-arg name="datasourcePath">
			<value>${Transfer.datasourcePath}</value>
		</constructor-arg>
		<constructor-arg name="configPath">
			<value>${Transfer.configPath}</value>
		</constructor-arg>
		<constructor-arg name="definitionPath">
			<value>${Transfer.definitionPath}</value>
		</constructor-arg>
	</bean>

	<bean id="Transfer" factory-bean="TransferFactory" factory-method="getTransfer" />
	<bean id="Datasource" factory-bean="TransferFactory" factory-method="getDatasouce" />

	<!-- Transfer related beans -->

	<bean id="TDOBeanInjectorObserver" class="codex.model.transfer.TDOBeanInjectorObserver" lazy-init="false" />
	<bean id="BeanPopulator" class="codex.model.transfer.BeanPopulator"/>

	<!-- ColdBox Related Beans -->

	<bean id="ColdboxFactory" class="coldbox.system.extras.ColdboxFactory" autowire="no" />

	<bean id="ColdBoxController" factory-bean="ColdBoxFactory" factory-method="getColdBox" />
	<bean id="InterceptorService" factory-bean="ColdBoxController" factory-method="getinterceptorService" />

	<!-- wiki -->

	<bean id="WikiService" class="codex.model.wiki.WikiService" />

	<!-- Parsers -->
	<bean id="WikiText" class="codex.model.wiki.parser.WikiText" />
	<bean id="Feed" class="codex.model.wiki.parser.Feed" />

</beans>