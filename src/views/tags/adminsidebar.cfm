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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function onLoginForm(){
	$('##_buttonbar_login').slideUp("fast");
	$('##_loader_login').fadeIn("slow");
}
function toggleItems(it){
	$("##"+it).slideToggle('fast');
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- ***************************************************************************************************** --->
<!--- WIKI ADMIN SIDEBAR --->
<!--- ***************************************************************************************************** --->

<!--- Admin Main Menu --->
<h1 onclick="toggleItems('sb_admin')"><img src="includes/images/shield.png" alt="admin"/> Admin</h1>
<div class="left-box#isItemVisible('sb_admin')#" id="sb_admin">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehAdmin)#" <cfif event.getCurrentHandler() eq "main">class="linkBold"</cfif>>Admin Dashboard</a></li>
		<li><a href="#event.buildLink(rc.xehAdminUsers)#" <cfif event.getCurrentHandler() eq "users">class="linkBold"</cfif>>User Management</a></li>
		<li><a href="#event.buildLink(rc.xehAdminRoles)#" <cfif event.getCurrentHandler() eq "roles">class="linkBold"</cfif>>Role Management</a></li>
	</ul>
</div>

<!--- Pages --->
<h1 onclick="toggleItems('sb_wikiadmin')"> <img src="includes/images/home.png" alt="home"/> Wiki Admin</h1>
<div class="left-box#isItemVisible('sb_wikiadmin')#" id="sb_wikiadmin">
	<ul class="sidemenu">
		<li>Pages</li>
		<li><a href="#event.buildLink(rc.xehAdminNamespace)#" <cfif event.getCurrentHandler() eq "namespace">class="linkBold"</cfif>>Namespaces</a></li>
		<li><a href="#event.buildLink(rc.xehAdminCategories)#" <cfif event.getCurrentHandler() eq "categories">class="linkBold"</cfif>>Categories</a></li>
		<li><a href="#event.buildLink(rc.xehAdminComments)#" <cfif event.getCurrentHandler() eq "comments">class="linkBold"</cfif>>Comments</a></li>
	</ul>
</div>

<!--- Plugins --->
<h1 onclick="toggleItems('sb_plugins')"> <img src="includes/images/plugin.png" alt="plugins"/> Plugins</h1>
<div class="left-box#isItemVisible('sb_plugins')#" id="sb_plugins">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehAdminPlugins)#" <cfif rc.event eq "admin.plugins.list">class="linkBold"</cfif>>Install/Remove</a></li>
		<li><a href="#event.buildLink(rc.xehAdminPluginDocs)#" <cfif rc.event eq "admin.plugins.docs">class="linkBold"</cfif>>Plugin Documentation</a></li>
	</ul>
</div>

<!--- Tools --->
<h1 onclick="toggleItems('sb_tools')"> <img src="includes/images/tools.png" alt="tools"/> Tools</h1>
<div class="left-box#isItemVisible('sb_tools')#" id="sb_tools">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehAdminAPI)#" <cfif rc.event eq "admin.tools.api">class="linkBold"</cfif>>API Docs</a></li>
		<li>Export</li>
		<li>Import</li>
		<li><a href="#event.buildLink(rc.xehAdminConverter)#" <cfif rc.event eq "admin.tools.converter">class="linkBold"</cfif>>Markup Converter</a></li>
	</ul>
</div>

<!--- Settings --->
<h1 onclick="toggleItems('sb_settings')"> <img src="includes/images/process.png" alt="settings"/> Settings</h1>
<div class="left-box#isItemVisible('sb_settings')#" id="sb_settings">
	<ul class="sidemenu">
		<li><a href="#event.buildLink(rc.xehAdminOptions)#" <cfif rc.event eq "admin.config.options">class="linkBold"</cfif>>General</a></li>
		<li><a href="#event.buildLink(rc.xehAdminCommentOptions)#" <cfif rc.event eq "admin.config.comments">class="linkBold"</cfif>>Comments</a></li>
		<li><a href="#event.buildLink(rc.xehAdminCustomHTML)#" <cfif rc.event eq "admin.config.customhtml">class="linkBold"</cfif>>Custom HTML</a></li>
		<li><a href="#event.buildLink(rc.xehadminlookups)#" <cfif event.getCurrentHandler() eq "lookups">class="linkBold"</cfif>>System Lookups</a></li>
	</ul>
</div>

<!--- ***************************************************************************************************** --->
<!--- User Login Box --->
<!--- ***************************************************************************************************** --->
#renderview("tags/userinfo")#	

<!--- End if not in login event --->
</cfoutput>