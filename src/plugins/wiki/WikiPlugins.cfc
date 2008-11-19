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
				
		<cfdirectory action="list" name="qPlugins" directory="#instance.wikiPluginsPath#" filter="*.cfc" sort="asc">
		
		<cfsavecontent variable="content">
		<cfoutput>
		<h2>Installed Plugins</h2>
		<ul>
		<cfloop query="qPlugins">
			<li>#ripExtension(name)#</li>	
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