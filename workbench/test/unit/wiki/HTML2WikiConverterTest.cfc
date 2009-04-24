<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="HTML2WikiConverterTest" extends="codexwiki.workbench.test.resources.BaseTest" output="false">
	
	<cfscript>
		this.loadColdbox = true;
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false">
		<cfscript>
		//Call the super setup method to setup the app.
		super.setup();
		
		javaloader = getBean("JavaLoader");
		converter = createObject("component","codex.model.wiki.HTML2WikiConverter").init(javaloader);
		</cfscript>
	</cffunction>
	
	<cfscript>
	
	function testGetTranslators(){
		AssertTrue( len(converter.getTranslators()) );
	}	
	
	function testToWiki(){
		text = "<b>hello<em>world</em></b>";
		result = converter.toWiki("WIKIPEDIA",text);
		assertEquals(result, "'''hello''world'''''");	
		
		text = "<b>hello<em>world</em></b>";
		result = converter.toWiki("WIKIPEDIA",text);
		assertEquals(result, "'''hello''world'''''");	
		
		result = converter.toWiki("TRAC",text);
		assertEquals(result, "'''hello''world'''''");
		
		result = converter.toWiki("JSPWiki",text);
		assertEquals(result, "__hello''world''__");
		
		result = converter.toWiki("MOINMOIN",text);
		assertEquals(result, "'''hello''world'''''");
		
		result = converter.toWiki("GOOGLECODE",text);
		assertEquals(result, "*hello_world_*");
	}
	
	</cfscript>
	
	
</cfcomponent>