<!-----------------------------------------------------------------------
Author 	 :	
Date     :	11/18/2008
Description : 			
 
		
Modification History:

----------------------------------------------------------------------->
<cfcomponent name="DateTime" 
			 hint="A datetime wiki plugin" 
			 extends="coldbox.system.plugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Time" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("DateTime");
  		setpluginVersion("1.0");
  		setpluginDescription("A date time stamp wiki plugin");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		<cfargument name="format" type="string" required="true" default="full" hint="Full,Short, Medium"/>
		<cfreturn dateformat(now(),arguments.format) & " " & timeFormat(now(),arguments.format)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>