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
<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	4/26/2008
Description : 			
 Paging plugin
		
Modification History:

----------------------------------------------------------------------->
<cfcomponent name="paging" 
			 hint="A paging plugin" 
			 extends="coldbox.system.plugin" 
			 output="false" 
			 cache="false">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="paging" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("paging");
  		setpluginVersion("1.0");
  		setpluginDescription("Paging plugin");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<!--- Get boundaries --->
	<cffunction name="getboundaries" access="public" returntype="struct" hint="Calculate the startrow and maxrow" output="false" >
		<cfargument name="page" required="true" type="numeric" hint="The page you are on.">
		<cfscript>
			var boundaries = structnew();
			
			boundaries.startrow = ((arguments.page * getSetting("PagingMaxRows")) - getSetting("PagingMaxRows"))+1;
			boundaries.maxrow = boundaries.startrow + getSetting("PagingMaxRows") - 1;
		
			return boundaries;
		</cfscript>
	</cffunction>
	
	<!--- render paging --->
	<cffunction name="renderit" access="public" returntype="any" hint="render plugin tabs" output="false" >
		<!--- ***************************************************************** --->
		<cfargument name="FoundRows"    required="true"  type="numeric" hint="The found rows to page">
		<cfargument name="link"   		required="false" type="string" hint="The normal link to use, you must place the @page@ place holder so the link ca be created correctly">
		<cfargument name="jsLink" 		required="false" type="string" hint="The js link to use, you must place the @page@ place holder so the link can be created correctly.">
		<!--- ***************************************************************** --->
		<cfset var event = getController().getRequestService().getContext()>
		<cfset var pagingTabs = "">
		<cfset var maxRows = getSetting('PagingMaxRows')>
		<cfset var bandGap = getSetting('PagingBandGap')>
		<cfset var totalPages = 0>
		<cfset var theLink = "">
		<!--- Paging vars --->
		<cfset var currentPage = event.getValue("page")>
		<cfset var pageFrom = 0>
		<cfset var pageTo = 0>
		
		<!--- Only page if records found --->
		<cfif arguments.FoundRows neq 0>
			<!--- Calculate Total Pages --->
			<cfset totalPages = Ceiling( arguments.FoundRows / maxRows )>
			
			<!--- Calculate JS link or Normal Link --->
			<cfif not structKeyExists(arguments,"jsLink")>
				<cfset theLink = arguments.link>
			<cfelse>
				<cfset theLink = arguments.jsLink>
			</cfif>
		
			<!--- ***************************************************************** --->
			<!--- Paging Tabs 														--->
			<!--- ***************************************************************** --->
			<cfsavecontent variable="pagingtabs">
			<cfoutput>
			<div class="pagingTabs">
				
				<div class="float-left">
				<strong>Total Records: </strong> #arguments.FoundRows# &nbsp;
				<strong>Total Pages:</strong> #totalPages#
				</div>
				
				<div class="float-right">
					
					<!--- PREVIOUS PAGE --->
					<cfif currentPage-1 gt 0>
						<a href="#replace(theLink,"@page@",currentPage-1)#">&lt;&lt;</a>
					</cfif>
					
					<!--- Calcualte PageFrom Carrousel --->
					<cfset pageFrom=1>
					<cfif (currentPage-bandGap) gt 1>
						<cfset pageFrom=currentPage-bandgap>
						<a href="#replace(theLink,"@page@",1)#">1</a>
						...
					</cfif>
					
					<!--- Page TO of Carrousel --->
					<cfset pageTo=currentPage+bandgap>
					<cfif (currentPage+bandgap) gt totalPages>
						<cfset pageTo=totalPages>
					</cfif>
					<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
						<a href="#replace(theLink,"@page@",pageIndex)#"
						   <cfif currentPage eq pageIndex>class="selected"</cfif>>#pageIndex#</a>
					</cfloop>
					
					<!--- End Token --->
					<cfif (currentPage+bandgap) lt totalPages>
						...
						<a href="#replace(theLink,"@page@",totalPages)#">#totalPages#</a>
					</cfif>
					
					<!--- NEXT PAGE --->
					<cfif (currentPage+bandgap) lt totalPages >
						<a href="#replace(theLink,"@page@",currentPage+1)#">&gt;&gt;</a>
					</cfif>
					
				</div>
									
			</div>
			</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfreturn pagingTabs>
	</cffunction>
    
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>