<cfscript>
	htmlBaseURL = getController().getSetting("htmlBaseURL");
	wikiName = getController().getSetting("WikiName");

	function getSetting(arg)
	{
		return getController().getSetting(arg);
	}
</cfscript>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	<meta name="Robots" content="index,nofollow" />

	<!--- Main CSS --->
	<link rel="stylesheet" type="text/css" href="#htmlBaseURL#/includes/css/style.css" />

	<!--- Code JS --->
	<script type="text/javascript" src="#htmlBaseURL#/includes/scripts/jquery-1.2.3.pack.js"></script>
	<script type="text/javascript" src="#htmlBaseURL#/includes/scripts/codex.js"></script>

	<title>
		#wikiName#
		-
		An Error has occured
		-
		CodexWiki
	</title>
</head>
<body>
	<!-- wrap starts here -->
	<div id="wrap">

		<!--- Main Header And Tabs --->
		<div id="header">
			<span id="slogan">Knowledge is Power...</span>
			<!-- tabs -->
			<ul>
				<!--- Wiki Tab --->
				<li>
					<a href="#getSetting('sesBaseURL')#"><span>Wiki</span></a>
				</li>
			</ul>
		</div>

		<!--- Sub Header --->
		<div id="header-logo">
			<div id="logo">Code<span class="red">X</span></div>
			<form method="post" class="search" action="" onsubmit="window.alert('Not implemented'); return false">
				<p><input name="search_query" class="textbox" type="text" />
						<input name="search" class="searchbutton" value="Search" type="submit" /></p>
			</form>
		</div>

		<div id="main">
			<h2>Uh Oh....</h2>
			<p>
				An unexpected error has occured.
			</p>
			<p>
				This error has been emailed to the system administrator and will be fixed shortly.
			</p>
		</div>
	</div>
	<!-- wrap ends here -->

	<!-- footer starts here -->
	<div class="footer">
		<cfinclude template="/codex/views/tags/footer.cfm">
	</div>
</body>
</html>
</cfoutput>





