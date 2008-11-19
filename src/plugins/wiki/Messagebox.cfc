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
   
    <cffunction name="init" access="public" returntype="Messagebox" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Messagebox");
  		setpluginVersion("1.0");
  		setpluginDescription("A messagebox plugin. Valid Types are info, warning, error");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		<cfargument name="message"  required="true" type="string" hint="The message to display"/>
		<cfargument name="type" 	required="true" type="string" default="info" hint="The type of messagebox: info, error, warning">
		
		<cfscript>
			var content = "";
			
			/* Header */
			if(arguments.type eq "info"){
				content = '<div class="cbox_messagebox_info"><p class="cbox_messagebox">';
			}
			else if(arguments.type eq "warning"){
				content = '<div class="cbox_messagebox_warning"><p class="cbox_messagebox">';
			}
			else if(arguments.type eq "error"){
				content = '<div class="cbox_messagebox_error"><p class="cbox_messagebox">';
			}
			
			/* Content */
			content = content & arguments.message & "</p></div>";
			
			return content;			
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>