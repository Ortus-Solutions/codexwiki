<cfcomponent name="user"
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="Pre handler operation">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>
	</cffunction>
	<cffunction name="editProfile" access="public" returntype="void" output="false" hint="Edit the profile">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>
	</cffunction>
	<cffunction name="changepassword" access="public" returntype="void" output="false" hint="Change password form">
		<cfargument name="Event" type="coldbox.system.beans.requestContext" required="yes">
	    <cfscript>
	</cffunction>
	</cffunction>
	<cffunction name="setUserService" access="public" returntype="void" output="false">
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

		<cfreturn instance.UserService>
	</cffunction>