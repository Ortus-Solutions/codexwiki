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
<!--- create a non found wiki page --->
<cfoutput>
<h1>#rc.content.getPage().getCleanName()#</h1>
<p>
	There is no page to be found under the title <strong>'#rc.content.getPage().getCleanName()#'</strong>
</p>
<cfif rc.oUser.checkPermission("WIKI_CREATE")>
	<p>
		Would you like to create it?
	</p>
	<p class="buttons">
		<input type="button" class="submitButton" onclick="window.location='#event.buildLink(rc.onCreateWiki & '/' & URLEncodedFormat(rc.page))#'" value="Create Page" />
	</p>
<cfelse>
<p>
	You do not have permission to create new pages
</p>
</cfif>
</cfoutput>