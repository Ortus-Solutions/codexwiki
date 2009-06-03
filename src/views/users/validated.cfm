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
<cfoutput>
<h2>
	<img src="includes/images/user.png" alt="Registration" /> Registration Validation
</h2>

<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<p>
	<cfif rc.oUser.getisConfirmed()>
		You can now start using this wiki. Please follow this <a href="#event.buildLink(rc.xehUserLogin)#">link to login</a> to the system.
	<cfelse>
		Your user could not be confirmed. Either your user does not exist or the confirmation number is wrong.
	</cfif>
</p>

</cfoutput>