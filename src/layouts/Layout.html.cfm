<!--- Page --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<cfoutput>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

	<!--- Main CSS --->
	<link rel="stylesheet" type="text/css" href="#getSetting('htmlBaseURL')#/includes/css/style.css" />
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList", "")#" index="css">
		<link rel="stylesheet" type="text/css" href="#getSetting('htmlBaseURL')#/includes/css/#css#.css" />
	</cfloop>
	<!--- Render Title --->
	#renderView('tags/title')#
	<!--- Render Custom HTML --->
	#rc.oCustomHTML.getbeforeHeadEnd()#
	</cfoutput>
</head>
<cfoutput>
<body style="background: none;">
	<!--- Render Custom HTML --->
	#rc.oCustomHTML.getafterBodyStart()#
	<div>
		#renderView()#
	</div>
	<!--- Render Custom HTML --->
	#rc.oCustomHTML.getbeforeBodyEnd()#
</body>
</cfoutput>
</html>