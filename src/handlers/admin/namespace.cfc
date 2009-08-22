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
<cfcomponent name="namespace"
			 output="false"
			 hint="namespace Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="LookupService" type="ioc" scope="instance">
	<cfproperty name="WikiService" 	 type="ioc" scope="instance">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List Namespaces --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="Namespace listing">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			/* Exit Handlers */
			rc.xehListing 	= "admin/namespace/list";
			rc.xehCreate 	= "admin/namespace/new";
			rc.xehEdit 		= "admin/namespace/edit";
			rc.xehDelete 	= "admin/namespace/doDelete";
			rc.xehNamespaceViewer = "#getSetting("spaceKey")#/";
			
			/* JS Lookups */
			event.setValue("jsAppendList", "simplemodal.helper,jquery.simplemodal,confirm,jquery.metadata,jquery.tablesorter.min");
			event.setValue("cssFullAppendList","includes/lookups/styles/sort");
			
			/* Get all the namespaces */
			rc.qNamespaces = instance.wikiService.getNamespaces();

			/* Set View */
			event.setView('admin/namespace/Listing');
		</cfscript>
	</cffunction>

	<!--- New user panel --->
	<cffunction name="new" output="false" access="public" returntype="void" hint="new namespace editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/namespace/list";
			rc.xehCreate = "admin/namespace/doCreate";
			
			/* JS */
			rc.jsAppendList = "formvalidation";

			/* Set View */
			event.setView("admin/namespace/add");
		</cfscript>
	</cffunction>

	<!--- Create a new Namespace --->
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="Namespace Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oNamespace = "";
			var errors = ArrayNew(1);

			//create new Namespace object.
			oNamespace = instance.wikiService.getNamespace();
			//Populate it
			getPlugin("beanFactory").populateBean(oNamespace);
			/* Validate it */
			errors = oNamespace.validate();
			/* Error Checks */
			if( arraylen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				new(event);
			}
			else{
				/* Save Namespace */
				oNamespace.setCreatedDate(now());
				instance.wikiService.save(oNamespace);
				getPlugin("messagebox").setMessage("info","Namespace added successfully");
				setNextRoute(route="admin/namespace/list");
			}
		</cfscript>
	</cffunction>

	<!--- Edit Panel --->
	<cffunction name="edit" output="false" access="public" returntype="void" hint="Namespace editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/namespace/list";
			rc.xehUpdate = "admin/namespace/doEdit";
			
			/* JS */
			rc.jsAppendList = "formvalidation";
			
			/* Verify incoming user id */
			if( not event.valueExists("namespaceID") ){
				getPlugin("messagebox").setMessage("warning", "namespace id not detected");
				setNextRoute("admin/namespace/list");
			}

			/* Get the namespace */
			rc.oNamespace =  instance.wikiService.getNamespace(namespaceID=rc.namespaceID);

			/* Set View */
			event.setView("admin/namespace/edit");
		</cfscript>
	</cffunction>

	<!--- Do Edit --->
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="Edit a namespace">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oNamespace = "";
			var oClonedNamespace = "";
			var errors = ArrayNew(1);
			
			/* Get and start checks */
			oNamespace = instance.wikiService.getNamespace(namespaceID=rc.namespaceID);
			oClonedNamespace = oNamespace.clone();
			getPlugin("beanFactory").populateBean(oClonedNamespace);
			
			/* Validate it */
			errors = oClonedNamespace.validate();
			if( ArrayLen(errors) ){
				getPlugin("messagebox").setMessage(type="error",messageArray=errors);
				edit(event);
			}
			else{
				/* Save it */
				oClonedNamespace.setCreatedDate(now());
				instance.wikiService.save(oClonedNamespace);
				/* Message of success */
				getPlugin("messagebox").setMessage("info","Namespace updated!");
				setNextRoute(route="admin/namespace/list");
			}
		</cfscript>
	</cffunction>

	<!--- Delete User --->
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete a Namespace.">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oNamespace = "";
			var i = 1;

			try{
				/* listing or record sent in? */
				if( event.getValue("namespaceID","") neq "" ){
					/* Loop and delete */
					for(i=1; i lte listlen(rc.namespaceID); i=i+1){
						//Remove it.
						instance.wikiService.deleteNamespace(listGetAt(rc.namespaceID,i));
						//set message box
						getPlugin("messagebox").setMessage("info","Namespace(s) and all of it's associated pages removed");
					}
				}
				else{
					/* Messagebox. */
					getPlugin("messagebox").setMessage("warning", "No Records Selected");
				}
			}
			catch(Any e){
				getPlugin("messagebox").setMessage("error", "Error removing Namespace. #e.message# #e.detail#");
			}

			/* Relocate back to listing */
			setNextRoute(route="admin/namespace/list");
		</cfscript>
	</cffunction>


<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>