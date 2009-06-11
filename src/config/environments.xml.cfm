<?xml version="1.0" encoding="utf-8"?>
<!-- Declare as many tiers as you like with a unique name -->
<environmentcontrol>

	<environment name="development" urls="localhost,codex.lmajano,codex.jfetmac,cfcodex.lmajano,cfcodex.jfetmac">
		<Setting name="HandlerCaching"			value="false" />
		<Setting name="EventCaching"			value="false" />
		<Setting name="HandlersIndexAutoReload" value="true" />
		<Setting name="DebugMode"	 			value="false" />
		<Setting name="ConfigAutoReload"        value="false" />
		<Setting name="DebugPassword" 			value="" />
		<Setting name="ReinitPassword" 			value="" />
		<Setting name="CustomErrorTemplate"		value="" />
		<Setting name="ExceptionHandler"		value="main.onException" />
	</environment>

	<environment name="development2" urls="cf:82,cf:75">
		<Setting name="HandlerCaching"			value="false" />
		<Setting name="HandlersIndexAutoReload" value="true" />		
		<Setting name="DebugMode"	 			value="true" />
		<Setting name="ConfigAutoReload"        value="false" />
		<Setting name="DebugPassword" 			value="" />
		<Setting name="ReinitPassword" 			value="" />
		<Setting name="onInvalidEvent"			value="" />
		<Setting name="CustomErrorTemplate"     value="" />
		<Setting name="UsingRewrite"			value="false" />		
	</environment>

</environmentcontrol>