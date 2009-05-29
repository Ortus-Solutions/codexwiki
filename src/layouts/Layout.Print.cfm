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
<!--- Setup the Wiki Title Name due to cf8 bug on cfdocumentitem --->
<cfset docTitle = rc.CodexOptions.wiki_name>
<!--- Header for download on other browsers --->
<cfif event.valueExists("content") >
	<cfset fileTitle = rc.content.getPage().getFileSafeName()>
<cfelse>
	<cfset fileTitle = "webprint">
</cfif>
<!--- Content Disposition --->
<cfheader name="Content-Disposition" value="inline; filename=#fileTitle#.#rc.layout_extension#">
<!--- CFFDocument --->
<cfdocument pagetype="letter" format="#Event.getValue("print","flashpaper")#">
	
	<!--- Header --->
	<cfdocumentitem type="header">
	<cfoutput>
	<div style="font-size: 9px; text-align: left;">
	#docTitle# - #dateformat(now(),"MMM DD, YYYY")# at #timeFormat(now(),"full")#
	</div>
	</cfoutput>
	</cfdocumentitem>
	
	<!--- Footer --->
	<cfdocumentitem type="footer">
	<cfoutput>
	<div style="font-size: 9px; text-align: right;">
	Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
	</div>
	</cfoutput>
	</cfdocumentitem>
	
	<!--- Page --->
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<cfoutput>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<!--- Meta Tags --->
		#renderView('tags/meta')#
		<!--- Base HREF --->
		<base href="#getSetting('htmlBaseURL')#">
		
		<!--- Main CSS --->
		<link rel="stylesheet" type="text/css" href="includes/style.css" />
	
		<!--- loop around the cssAppendList, to add page specific css --->
		<cfloop list="#event.getValue("cssAppendList", "")#" index="css">
			<link rel="stylesheet" type="text/css" href="includes/css/#css#.css" />
		</cfloop>
		
		<!--- Title --->
		#renderView('tags/title')#
		<!--- Render Custom HTML --->
		#rc.oCustomHTML.getbeforeHeadEnd()#
		</cfoutput>
	</head>
	<cfoutput>
	<body>
		<!--- Render Custom HTML --->
		#rc.oCustomHTML.getafterBodyStart()#
		<div id="wrap">
			<div id="main">
				#renderView()#
			</div>
		</div>
		<!--- Render Custom HTML --->
		#rc.oCustomHTML.getbeforeBodyEnd()#
	</body>
	</cfoutput>
	</html>
</cfdocument>