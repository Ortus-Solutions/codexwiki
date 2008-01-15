<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE beans SYSTEM "/home/mark/wwwroot/codexWiki/src/config/spring-beans.dtd">
<beans default-autowire="byName">

	<!--Transfer Factory: PERSISTANCE MANAGED BY COLDSPRING -->
	<bean id="TransferFactory" class="transfer.TransferFactory" singleton="true" autowire="no">
		<constructor-arg name="datasourcePath">
			<value>/config/datasource.xml.cfm</value>
		</constructor-arg>
		<constructor-arg name="configPath">
			<value>/config/transfer.xml.cfm</value>
		</constructor-arg>
		<constructor-arg name="definitionPath">
			<value>/config/definitions</value>
		</constructor-arg>
	</bean>

	<bean id="Transfer" factory-bean="TransferFactory" factory-method="getTransfer" />
	<bean id="Datasource" factory-bean="TransferFactory" factory-method="getDatasouce" />

	<bean id="TDOBeanInjectorObserver" class="model.transfer.TDOBeanInjectorObserver" lazy-init="false" />


	<!-- wiki -->

	<bean id="WikiService" class="model.wiki.WikiService" />

</beans>