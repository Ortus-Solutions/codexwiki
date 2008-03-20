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

	#renderView('tags/title')#
	</cfoutput>
</head>
<body style="background: none;">
	<div>
		<cfoutput>#renderView()#</cfoutput>
	</div>
</body>
</html>