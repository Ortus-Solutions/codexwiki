<!--- Header for download on other browsers --->
<cfheader name="Content-Disposition" value="inline; filename=webprint.#rc.layout_extension#">

<!--- Document --->
<cfdocument pagetype="letter" format="#Event.getValue("print","flashpaper")#">

<!--- Header --->
<cfdocumentitem type="header">
<cfoutput>
<div style="font-size: 9px; text-align: left;">
CodeX Wiki - #dateformat(now(),"MMM DD, YYYY")# at #timeFormat(now(),"full")#
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<cfoutput>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	
	<!--- SES Base --->
	<base href="#getSetting('htmlBaseURL')#">
	
	<!--- Main CSS --->
	<link rel="stylesheet" type="text/css" href="includes/style.css" />
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList", "")#" index="css">
		<link rel="stylesheet" type="text/css" href="includes/css/#css#.css" />
	</cfloop>
	
	<!--- Page Title --->
	<title>CodeX Wiki</title>
	</cfoutput>
</head>
<body>
	<!-- wrap starts here -->
	<div id="wrap">
	<cfoutput>
		<!-- header -->
		#renderView('tags/header')#
	
		<!-- Sidebar -->
		<div id="sidebar" >							
			#renderView('tags/sidebar')#	
		</div>		
		
		<div id="main">				
			#renderView()#							
		</div>
	</cfoutput>	
	</div>
	<!-- wrap ends here -->
</body>
</html>
</cfdocument>