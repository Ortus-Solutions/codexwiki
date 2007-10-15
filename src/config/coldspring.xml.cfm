<?xml version="1.0" encoding="UTF-8"?>
<beans>
	
	<!--Transfer Factory: PERSISTANCE MANAGED BY COLDSPRING -->
	<bean id="TransferFactory" class="shared.frameworks.transfer0_63.TransferFactory" singleton="true">
		<constructor-arg name="datasourcePath">
			<value>${Transfer.dsnPath}</value>
		</constructor-arg>
		<constructor-arg name="configPath">
			<value>${Transfer.configPath}</value>
		</constructor-arg>
		<constructor-arg name="definitionPath">
			<value>${Transfer.definitionsPath}</value>
		</constructor-arg>
	</bean>

</beans>