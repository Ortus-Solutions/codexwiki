<!-----------------------------------------------------------------------
Author 	 :	
Date     :	11/18/2008
Description : 			
 
		
Modification History:

----------------------------------------------------------------------->
<cfcomponent name="DateTime" 
			 hint="A wiki plugin to interact with installed plugins." 
			 extends="coldbox.system.plugin" 
			 output="false" 
			 cache="false">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="WikiPlugins" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Messagebox");
  		setpluginVersion("1.0");
  		setpluginDescription("A messagebox plugin. Valid Types are info, warning, error");
  		//My own Constructor code here
  		
  		instance.wikiPluginsPath = getSetting("MyPluginsPath") & "/wiki";
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		
		<cfset var qPlugins = "">
		<cfset var content = "" />
		<cfset var thisPlugin = "">
		<cfset var thisMD = "">
		<cfset var oPlugin = 0>
		<Cfset var args = ArrayNew(1)>
				
		<cfdirectory action="list" name="qPlugins" directory="#instance.wikiPluginsPath#" filter="*.cfc" sort="asc">
		
		<cfsavecontent variable="content">
		<cfoutput>
		<h2>Installed Plugins</h2>
		<p>Below is a listing of all installed plugins that can be found in the following directory:
			<em>#instance.wikiPluginsPath#</em>
		</p>
		<ul>
		<cfloop query="qPlugins">
			<cfset thisPlugin = "wiki." & ripExtension(name)>
			<cfset oPlugin = getMyPlugin(thisPlugin)>
			<cfset thisMD = getMetadata(oPlugin.renderit)>
			<cfset args = thisMD.parameters>
			
			<li><strong>#ripExtension(name)#</strong><br />
				<ul>
					<li><strong>Version:</strong> #oPlugin.getpluginVersion()# </li>
					<li><strong>Description:</strong> #oPlugin.getPluginDescription()#</li>
					<li><strong>Hint: </strong> <cfif structKeyExists(thisMD,"hint")>#thisMD.hint#<cfelse>N/A</cfif></li>
					<li><strong>Renderit Arguments: </strong>
						<cfif ArrayLen(args)>
							<table class="tablelisting" width="95%">
								<tr>
									<th>Argument</th>
									<th>Type</th>
									<th>Required</th>
									<th>Default Value</th>
									<th>Hint</th>
								</tr>
							<cfloop array="#args#" index="i">
								<tr>
									<td>#i.name#</td>
									<td><cfif structKeyExists(i,"type")>#i.type#<cfelse>Any</cfif></td>
									<td><cfif structKeyExists(i,"required")>#i.required#<cfelse>true</cfif></td>
									<td><cfif structKeyExists(i,"default")>#i.default#</cfif></td>
									<td><cfif structKeyExists(i,"hint")>#i.hint#</cfif></td>
								</tr>
							</cfloop>
							</table>
						<cfelse>
							No arguments defined
						</cfif>	
					</li>
				</ul>
			</li>
			<br />
		</cfloop>
		</ul>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content> 
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	<!--- Rip Extension --->
	<cffunction name="ripExtension" access="public" returntype="string" output="false" hint="Rip the extension of a filename.">
		<cfargument name="filename" type="string" required="true">
		<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>
	</cffunction>
	
</cfcomponent>