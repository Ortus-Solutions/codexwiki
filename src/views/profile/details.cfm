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
	<img src="includes/images/user.png" alt="profile" /> My Profile
</h2>

<p>
Below you can see your current profile in the system. You can click on the <strong>Edit Profile</strong> button to make changes to your profile.
</p>

#getPlugin("messagebox").renderit()#
	
<!--- Profile Details --->
<fieldset >
	<legend>My Details</legend>
	<p>
	#getMyPlugin("avatar").renderAvatar()#<br />
	<label class="inline">Name: </label> #rc.oUser.getfname()# #rc.oUser.getlname()#<br />
	<label class="inline">Email: </label> #rc.oUser.getEmail()#<br />
	<label class="inline">Username: </label> #rc.oUser.getUsername()#<br />
	<label class="inline">Created On: </label> #printDate(rc.oUser.getcreatedate())# at #printTime(rc.oUser.getcreatedate())#<br />
	<label class="inline">Modified On: </label> #printDate(rc.oUser.getModifyDate())# at #printTime(rc.oUser.getModifyDate())#<br />
	</p>
	
	<!--- Button Bar --->
	<div align="center" id="_buttonbar">
		<a href="#event.buildLink(rc.xehEditProfile)#" class="buttonLinks">
			<span>
				<img src="includes/images/page_edit.png" border="0" alt="edit" />
				Edit Profile
			</span>
		</a>
	</div>
</fieldset>

<!--- Security Info --->
<fieldset >
	<legend>My Permissions</legend>
	<div>
		<p>
			<cfloop collection="#rc.userPerms#" item="key">
			<img src="includes/images/accept.png" alt="accept" /> #key#<br />
			</cfloop>
		</p>
	</div>

</fieldset>

</cfoutput>