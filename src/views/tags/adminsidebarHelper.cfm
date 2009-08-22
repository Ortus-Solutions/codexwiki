<!--- THis is the sidebar helper. This file is IMPLICITLY loaded by ColdBox as a helper of the sidebar --->
<cfscript>
	function isItemVisible(sb){
		var event = getController().getRequestService().getContext();
		var ce = event.getCurrentEvent();
		switch(arguments.sb){
			case "sb_admin":{
				if(not reFindNoCase("^admin\.(main|users|roles)", ce) ){return " hidden";}
				else {break;}				
			}
			case "sb_wikiadmin":{
				if( not reFindNoCase("^admin\.(namespace|categories|comments|pages)", ce) ){ return " hidden"; }
				else {break;}
			}
			case "sb_tools" :{
				if( not reFindNoCase("^admin\.(tools)", ce) ){ return " hidden"; }
				else {break;}
			}
			case "sb_plugins" :{
				if( not reFindNoCase("^admin\.(plugins)", ce) ){ return " hidden"; }
				else {break;}
			}
			case "sb_settings" :{
				if( not reFindNoCase("^admin\.(config|lookups)", ce) ){ return " hidden"; }
				else {break;}
			}
		}//end switch
	}//end item visible
</cfscript>