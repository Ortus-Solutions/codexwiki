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
<cfscript>
	htmlBaseURL = getController().getSetting("htmlBaseURL");
	CodexOptions = getController().getColdBoxOCM().get("CodexOptions");
	if( isStruct(CodexOptions) and structKeyExists(CodexOptions,"wiki_name")){
		wikiName = CodexOptions.wiki_name;
	}
	else{
		wikiName = "";
	}

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
	<script type="text/javascript" src="#htmlBaseURL#/includes/scripts/jquery-latest.pack.js"></script>
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





