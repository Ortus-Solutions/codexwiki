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
<!--- WIKI PROFILE SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfif refindnocase("^profile",event.getCurrentEvent())>
	<!--- User Main Menu --->
	<h1 onclick="toggleItems('sb_profile')"> <img src="includes/images/shield.png" alt="usermenu"/> User Menu</h1>
	<div class="left-box" id="sb_profile">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(rc.xehUserProfile)#">My Profile</a></li>
			<li><a href="#event.buildLink(rc.xehUserChangePass)#">Change Password</a></li>
		</ul>
	</div>
	
<!--- ***************************************************************************************************** --->
<!--- WIKI MAIN SIDEBAR --->
<!--- ***************************************************************************************************** --->
<cfelse>
	<!--- Wiki Main Menu --->
	<h1 onclick="toggleItems('sb_wikimenu')"> <img src="includes/images/home.png" alt="home"/> SideBar</h1>
	<div class="left-box" id="sb_wikimenu">
		<ul class="sidemenu">
			<li><a href="#event.buildLink(pageShowRoot(rc.CodexOptions.wiki_defaultpage))#">#rc.codexOptions.wiki_defaultpage_label#</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialHelp)#">Help</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialFeeds)#">Rss Feeds</a></li>
			<li><a href="#event.buildLink(rc.xehSpecialCategory)#">Category Listing</a></li>
			<li><a href="#event.buildLink(rc.xehPageDirectory)#">Page Directory</a></li>
			<li><a href="#event.buildLink(rc.xehSpaceDirectory)#">Namespace Directory</a></li>
		</ul>
	</div>
</cfif>


<!--- ***************************************************************************************************** --->
<!--- User Login Box --->
<!--- ***************************************************************************************************** --->
#renderView("tags/userinfo")#

<!--- End if not in login event --->
</cfoutput>