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
<cfset setUniqueURLs(false)>

<cfif len(getSetting("AppMapping")) lte 1>
	<cfset setBaseURL("http://#cgi.HTTP_HOST#")>
<cfelse>
	<cfset setBaseURL("http://#cgi.HTTP_HOST#/#getSetting('AppMapping')#")>
</cfif>

<!--- CUSTOM COURSES GO HERE (they will be checked in order) --->
<!--- 404 Errors --->
<cfset addCourse(pattern="notfound/",handler="main",action="notfound")>

<!--- Main Wiki URL's --->
<cfset addCourse(pattern="#getSetting('ShowKey')#/:page?/:print?",handler="page",action="show")>
<!--- Namespace visualizer --->
<cfset addCourse(pattern="#getSetting('SpaceKey')#/:namespace?",handler="space",action="viewer")>
<!--- Namespace directory --->
<cfset addCourse(pattern="spaces",handler="space",action="directory")>

<!--- feed urls --->
<cfset addCourse(pattern="feed/:source/:feed",handler="feed",action="show")>
<!--- User management --->
<cfset addCourse(":handler/:action/sort/:sortby/:sortOrder/:page")>
<cfset addCourse(":handler/:action/user_id/:user_id/permissionID/:permissionID")>
<cfset addCourse(":handler/:action/user_id/:user_id")>
<!--- Page Actions with Page Name and ID --->
<cfset addCourse(pattern="page/:action/id/:contentid",handler="page")>
<cfset addCourse(pattern="page/:action/:page",handler="page")>

<!--- General Routes --->

<!--- STANDARD COLDBOX COURSES, DO NOT MODIFY UNLESS YOU DON'T LIKE THEM --->
<cfset addCourse(":handler/:action?")>