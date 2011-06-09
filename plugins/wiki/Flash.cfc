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
<cfcomponent name="Flash" 
			 hint="A Flash Embedder wiki plugin" 
			 extends="codex.model.plugins.BaseWikiPlugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Flash" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("Flash");
  		setpluginVersion("1.0");
  		setpluginDescription("A plugin to embedd flash movies in a wiki page");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.coldbox.org");
  		setPluginURL("http://www.codexwiki.org");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	
	
    <!--- renderit --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="Embed a flash movie in a wiki page">
		<cfargument name="movie" 			type="string"  required="true" default="" hint="The movie path"/>
		<cfargument name="name" 			type="string"  required="false" default="" hint="The name of the movie"/>
		<cfargument name="id" 				type="string"  required="false" default="" hint="The default id for the movie"/>
		<cfargument name="align"			type="string" required="false" default="left" hint="left,center,right"/>
		<cfargument name="width" 			type="string"  required="false" default="100%" hint="Width of the movie"/>
		<cfargument name="height" 			type="string"  required="false" default="100%" hint="Width of the movie"/>
		<cfargument name="quality" 			type="string"  required="false" default="best" hint="The video quality"/>
		<cfargument name="bgColor" 			type="string"  required="false" default="" hint="A background color"/>
		<cfargument name="wmode" 			type="string"  required="false" default="transparent" hint="The wmode of the movie"/>
		<cfargument name="allowFullScreen"  type="boolean" required="false" default="true" hint="Allow full screen"/>
		<cfargument name="allowScriptAccess" type="string" required="false" default="sameDomain" hint="The allow script access arguemnt"/>
		<cfargument name="scale" 			type="string"  required="false" default="showAll" hint="The scale of the movie"/>
		<cfargument name="data" 			type="string"  required="false" default="" hint="A data string to add to the object element"/>
		<cfargument name="FlashVars" 		type="string"  required="false" default="" hint="A flashvars string to add to the object element"/>
		<cfset var content = "">
		
		<cfsavecontent variable="content">
		<cfoutput>
		<div id="swf_holder" class="align-#arguments.align#">
		<object type="application/x-shockwave-flash"
				id="#arguments.id#" 
				width="#arguments.width#"
				height="#arguments.height#"
				data="#arguments.data#">
			
			<param name="movie" 			value="#arguments.movie#" />
			<param name="quality" 			value="#arguments.quality#" />
			<param name="bgColor"			value="#arguments.bgColor#" />
			<param name="allowFullScreen"	value="#arguments.allowFullScreen#" />
			<param name="scale" 			value="#arguments.scale#" />	
			<param name="movie"				value="#arguments.movie#" />
			<param name="FlashVars"			value="#arguments.FlashVars#" />
			<param name="allowScriptAccess" value="#arguments.allowScriptAccess#" />
			<embed height="#arguments.height#"
				   width="#arguments.width#" 
				   allowscriptaccess="#arguments.allowScriptAccess#" 
				   wmode="#arguments.wmode#" 
				   quality="#arguments.quality#" 
				   bgcolor="#arguments.bgColor#" 
				   name="#arguments.name#" 
				   scaleMode="#arguments.scale#"
				   id="#arguments.id#" 
				   src="#arguments.movie#" 
				   type="application/x-shockwave-flash"/>
		</object>
		</div>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>