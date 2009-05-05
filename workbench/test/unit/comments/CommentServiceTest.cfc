<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="CommentServiceTest" extends="codexwiki.workbench.test.resources.BaseTest" output="false">
	
	<cfscript>
		this.loadColdbox = true;
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false">
		<cfscript>
		//Call the super setup method to setup the app.
		super.setup();
		
		cs = getBean("CommentsService");
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetPageComments" access="public" returntype="void" output="false">
		<cfscript>
			comments = cs.getPageComments(pageName="Dashboard",active=false,approved=true);
			Debug(comments);
			AssertTrue( isQuery(comments) );
			
			comments = cs.getPageComments(pageID="123");
			Debug(comments);
			AssertTrue( isQuery(comments) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetComment" access="public" returntype="any" hint="" output="false" >
		<cfscript>
			comment = cs.getComment();
			
			assertFalse( comment.getIsPersisted() );
		</cfscript>
	</cffunction>
	
	
	
</cfcomponent>