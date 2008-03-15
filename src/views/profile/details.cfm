<cfoutput>
<h1>
	<img src="#getSetting('htmlBaseURL')#/includes/images/user.png" align="absmiddle"> My Profile
</h1>

<p>
Below you can see your current profile in the system. You can click on the <strong>Edit Profile</strong> button to make changes to your profile.
</p>

#getPlugin("messagebox").renderit()#
	
<!--- Profile Details --->
<fieldset >
	<legend>My Details</legend>
	<div>
		<p>
		<label class="inline">Name: </label> #rc.oUser.getfname()# #rc.oUser.getlname()#<br />
		<label class="inline">Email: </label> #rc.oUser.getEmail()#<br />
		<label class="inline">Username: </label> #rc.oUser.getUsername()#<br />
		<label class="inline">Created On: </label> #printDate(rc.oUser.getcreatedate())# at #printTime(rc.oUser.getcreatedate())#<br />
		<label class="inline">Modified On: </label> #printDate(rc.oUser.getModifyDate())# at #printTime(rc.oUser.getModifyDate())#<br />
		</p>
	</div>
	
	<!--- Button Bar --->
	<div align="center" id="_buttonbar">
		<a href="#getSetting('sesBaseURL')#/#rc.xehEditProfile#" id="buttonLinks">
			<span>
				<img src="#getSetting('sesBaseURL')#/includes/images/page_edit.png" border="0" align="absmiddle">
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
			<img src="#getSetting('sesBaseURL')#/includes/images/accept.png" align="absmiddle"> #key#<br />
			</cfloop>
		</p>
	</div>

</fieldset>

</cfoutput>