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
<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	9/28/2007
Description :
	This is an interceptor for ses support. This code is based almost totally on
	Adam Fortuna's ColdCourse cfc, which is an AMAZING SES component
	All credits go to him: http://coldcourse.riaforge.com
----------------------------------------------------------------------->
<cfcomponent name="ses"
			 hint="This is a ses support internceptor"
			 output="false"
			 extends="coldbox.system.interceptors.ses">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="This is where the ses plugin configures itself." output="false" >
		<cfscript>
			super.configure();
		</cfscript>
	</cffunction>

<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->



<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getCGIElement" access="private" returntype="string" hint="The request element override method" output="true" >
		<cfargument name="cgielement" required="true" type="string" hint="">
		<cfscript>
			/* Are we in request ses mode? */
			if ( structKeyExists(request,"ses") ){
				return replace(request.ses[arguments.cgielement],"//","/","all");
			}
			/* We are in cgi ses mode. */
			else{
				return replace(super.getCGIElement(arguments.cgielement),"//","/","all");
			}
		</cfscript>
	</cffunction>

</cfcomponent>