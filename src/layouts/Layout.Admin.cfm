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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>	<cfoutput>	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />	<meta name="Robots" content="index,no-follow" />
	<!--- Meta Tags --->
	#renderView('tags/meta')#
	
	<!--- Base HREF --->
	<base href="#getSetting('htmlBaseURL')#/" />
		<!--- Main CSS --->	<link rel="stylesheet" type="text/css" href="includes/css/style.css" />	<!--- loop around the cssAppendList, to add page specific css --->	<cfloop list="#event.getValue("cssAppendList", "")#" index="css">		<link rel="stylesheet" type="text/css" href="includes/css/#css#.css" />	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList", "")#" index="css">
		<link rel="stylesheet" type="text/css" href="#css#.css" />
	</cfloop>	<!--- Global JS --->	<script type="text/javascript" src="includes/scripts/jquery-latest.pack.js"></script>	<script type="text/javascript" src="includes/scripts/codex.js"></script>	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">		<script type="text/javascript" src="includes/scripts/#js#.js"></script>	</cfloop>
	<cfloop list="#event.getValue("jsFullAppendList", "")#" index="js">
		<script type="text/javascript" src="#js#.js"></script>
	</cfloop>
		<!--- Render Title --->	#renderView('tags/title')#
	</cfoutput></head><cfoutput><body>	<div id="wrap">		<!--- Header Bar --->
		#renderView('tags/header')#		<div id="sidebar" >
			#renderView('tags/adminsidebar')#		</div>				<div id="main">			#renderView()#		</div>		</div>	
	<div class="footer">		#renderView('tags/footer')#	</div></body></cfoutput></html>