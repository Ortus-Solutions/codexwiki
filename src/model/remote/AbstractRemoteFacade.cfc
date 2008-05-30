<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by 
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
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
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
<cfcomponent hint="this is the base class for remote facades to extend" extends="coldbox.system.extras.ColdboxProxy" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- overwrite it, so it is private --->

<cffunction name="process" output="false" access="private" returntype="any" hint="Process a remote call and return data/objects back.">
	<cfreturn super.process() />
</cffunction>

</cfcomponent>