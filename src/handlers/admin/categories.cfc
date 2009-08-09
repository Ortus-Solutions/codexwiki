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
<cfcomponent output="false"
			 hint="Categories Controller"
			 extends="codex.handlers.baseHandler"
			 autowire="true">

	<!--- Dependencies --->
	<cfproperty name="LookupService" type="ioc" scope="instance">
	<cfproperty name="WikiService" 	 type="ioc" scope="instance">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- List Namespaces --->
	<cffunction name="list" output="false" access="public" returntype="void" hint="Categories listing">
		<cfargument name="Event" type="any">
		<cfscript>
			var rc = event.getCollection();
			
			/* Exit Handlers */
			rc.xehListing 	= "admin/categories/list";
			rc.xehCreate 	= "admin/categories/new";
			rc.xehEdit 		= "admin/categories/edit";
			rc.xehDelete 	= "admin/categories/doDelete";
			
			/* JS Lookups */
			event.setValue("jsAppendList", "jquery.simplemodal,confirm,jquery.metadata,jquery.tablesorter.min");
			event.setValue("cssFullAppendList","includes/lookups/styles/sort");
			
			/* Get all the categories */
			rc.qCategories = instance.wikiService.listCategories();

			/* Set View */
			event.setView('admin/categories/Listing');
		</cfscript>
	</cffunction>

	<!--- New user panel --->
	<cffunction name="new" output="false" access="public" returntype="void" hint="new categories editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/categories/list";
			rc.xehCreate = "admin/categories/doCreate";
			
			/* JS */
			rc.jsAppendList = "formvalidation";

			/* Set View */
			event.setView("admin/categories/add");
		</cfscript>
	</cffunction>

	<!--- Create a new Namespace --->
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="Namespace Create">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oCategory = "";
			
			//create new category object.
			oCategory = instance.wikiService.getCategory();
			/* Error Checks */
			if( len(event.getTrimValue("name")) eq 0 ){
				getPlugin("messagebox").setMessage(type="error",message="Please enter a category name.");
				new(event);
			}
			else{
				//Populate it
				getPlugin("beanFactory").populateBean(oCategory);
				/* Save */
				instance.wikiService.saveCategory(oCategory);
				/* Info message */
				getPlugin("messagebox").setMessage("info","Category added successfully");
				setNextRoute(route="admin/categories/list");
			}
		</cfscript>
	</cffunction>

	<!--- Edit Panel --->
	<cffunction name="edit" output="false" access="public" returntype="void" hint="categories editor">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();

			/* Exit Handlers */
			rc.xehListing = "admin/categories/list";
			rc.xehUpdate = "admin/categories/doEdit";
			
			/* JS */
			rc.jsAppendList = "formvalidation";
			
			/* Verify incoming user id */
			if( not event.valueExists("category_id") ){
				getPlugin("messagebox").setMessage("warning", "category id not detected");
				setNextRoute("admin/categories/list");
			}

			/* Get the category */
			rc.oCategory =  instance.wikiService.getCategory(categoryID=rc.category_id);

			/* Set View */
			event.setView("admin/categories/edit");
		</cfscript>
	</cffunction>

	<!--- Do Edit --->
	<cffunction name="doEdit" output="false" access="public" returntype="void" hint="Edit a category">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oCategory = "";
			var oClonedCategory = "";
			var errors = ArrayNew(1);
			
			// Get and start checks
			oCategory = instance.wikiService.getCategory(categoryID=rc.category_id);
			oClonedCategory = oCategory.clone();
			getPlugin("beanFactory").populateBean(oClonedCategory);
			
			// If Different, then re-create
			if( oCategory.getName() neq oClonedCategory.getName() ){
				// Remove Old Category
				instance.wikiService.deleteCategory(oCategory.getCategory_id());
				// Create New Category
				instance.wikiService.saveCategory(oClonedCategory);
				getPlugin("messagebox").setMessage("info","Category Updated!");
				setNextRoute(route="admin/categories/list");
			}
			else{
				getPlugin("messagebox").setMessage("warning","Category did not change, no updates made!");
				setNextRoute(route="admin/categories/list");
			}
		</cfscript>
	</cffunction>

	<!--- Delete User --->
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete a categories.">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var oCategory = "";
			var i = 1;

			try{
				/* listing or record sent in? */
				if( event.getValue("category_id","") neq "" ){
					/* Loop and delete */
					for(i=1; i lte listlen(rc.category_id); i=i+1){
						//Remove it.
						instance.wikiService.deleteCategory(listGetAt(rc.category_id,i));
						//set message box
						getPlugin("messagebox").setMessage("info","Category removed");
					}
				}
				else{
					/* Messagebox. */
					getPlugin("messagebox").setMessage("warning", "No Records Selected");
				}
			}
			catch(Any e){
				getPlugin("messagebox").setMessage("error", "Error removing Category. #e.message# #e.detail#");
			}

			/* Relocate back to listing */
			setNextRoute(route="admin/categories/list");
		</cfscript>
	</cffunction>


<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>