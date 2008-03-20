<cfcomponent name="lookup" 
			 extends="codex.handlers.baseHandler"
			 output="false"
			 hint="This is the lookup builder controller object"
			 autowire="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="display" output="false" access="public" returntype="void" hint="Display System Lookups">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		//Local event reference
		var rc = event.getCollection();
		var key = "";
		
		/* SET XEH */
		rc.xehLookupCreate = "admin.lookups/dspCreate.cfm";
		rc.xehLookupDelete = "admin.lookups/doDelete.cfm";
		rc.xehLookupEdit = "admin.lookups/dspEdit.cfm";
		rc.xehLookupClean = "admin.lookups/cleanDictionary.cfm";
		
		/* JS Lookups */
		event.setValue("jsAppendList", "jquery.simplemodal-1.1.1.pack,confirm");
		
		
		//Get System Lookups
		rc.systemLookups = getSetting("SystemLookups");
		rc.systemLookupsKeys = structKeyArray(rc.systemLookups);
		ArraySort(rc.systemLookupsKeys,"text");
		
		//Param Choosen Lookup
		event.paramValue("lookupClass", rc.systemLookups[ rc.systemLookupsKeys[1] ]);
		
		//Prepare Lookup's Meta Data Dictionary
		rc.mdDictionary = getLookupService().prepareDictionary(rc.lookupClass);

		//Get Lookup Listing
		rc.qListing = getLookupService().getListing(rc.lookupClass);

		//Param sort Order
		if ( event.getValue("sortOrder","") eq "")
			event.setValue("sortOrder","ASC");
		else{
			if ( rc.sortOrder eq "ASC" )
				rc.sortOrder = "DESC";
			else
				rc.sortOrder = "ASC";
		}
		//Test for Sorting
		if ( event.getValue("sortby","") neq "" )
			rc.qListing = getPlugin("queryHelper").sortQuery(rc.qListing,"[#rc.sortby#]",rc.sortOrder);
		else
			event.setValue("sortBy",rc.mdDictionary.sortBy);

		//Set view to render
		event.setView("admin/lookups/Listing");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="cleanDictionary" output="false" access="public" returntype="void" hint="Clean the MD Dictionary">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var rc = event.getCollection();
			
			getLookupService().cleanDictionary();
			/* Messagebox. */
			getPlugin("messagebox").setMessage("info", "Metadata Dictionary Cleaned.");
					
			/* Relocate back to listing */
			setNextRoute(route="admin.lookups/display");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete A Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var i = 1;
		var rc = event.getCollection();
		
		//Check that listing sent in
		if ( event.getValue("lookupid","") neq "" ){
			//Loop throught listing and delete objects
			for(i=1; i lte listlen(rc.lookupid); i=i+1){
				//Delete Entry
				getLookupService().delete(rc.lookupclass,listgetAt(rc.lookupid,i));
			}
			/* Messagebox. */
			getPlugin("messagebox").setMessage("info", "Record(s) Deleted Successfully.");
		}
		else{
			/* Messagebox. */
			getPlugin("messagebox").setMessage("warning", "No Records Selected");
		}
				
		/* Relocate back to listing */
		setNextRoute(route="admin.lookups/display",qs="lookupclass=#rc.lookupclass#");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="dspCreate" output="false" access="public" returntype="void" hint="Create Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		//collection reference
		var rc = event.getCollection();
		var i = 1;
		
		//LookupCheck
		fncLookupCheck(event);
		
		/* exit handlers */
		rc.xehLookupCreate = "admin.lookups/doCreate.cfm";

		//Get Lookup's md Dictionary
		rc.mdDictionary = getlookupService().getDictionary(rc.lookupclass);

		//Check Relations
		if ( rc.mdDictionary.hasManyToOne ){
			//Get Lookup Listings
			for (i=1;i lte ArrayLen(rc.mdDictionary.ManyToOneArray); i=i+1){
				structInsert(rc,"q#rc.mdDictionary.ManyToOneArray[i].alias#",getLookupService().getListing(rc.mdDictionary.ManyToOneArray[i].className));
			}
		}
		//Set view.
		event.setView("admin/lookups/Add");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="Create Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var rc = event.getCollection();
		var oLookup = "";
		var tmpFKTO = "";
		//Get the Transfer Object's Metadata Dictionary
		var mdDictionary = "";
		var i = 1;


		//LookupCheck
		fncLookupCheck(event);

		//Metadata
		mdDictionary = getLookupService().getDictionary(rc.lookupClass);

		//Get New Lookup Transfer Object to save
		oLookup = getLookupService().getLookupObject(rc.lookupClass);

		//Populate it with RC data
		getPlugin("beanFactory").populateBean(oLookup);

		//Check for FK Relations
		if ( ArrayLen(mdDictionary.ManyToOneArray) ){
			//Loop Through relations
			for ( i=1;i lte ArrayLen(mdDictionary.ManyToOneArray); i=i+1 ){
				tmpFKTO = getLookupService().getLookupObject(mdDictionary.ManyToOneArray[i].className,rc["fk_"&mdDictionary.ManyToOneArray[1].alias]);
				//add the tmpTO to oLookup
				evaluate("oLookup.set#mdDictionary.ManyToOneArray[1].alias#(tmpFKTO)");
			}
		}
		//Tell service to save object
		getLookupService().save(oLookup);		
		/* Relocate back to listing */
		setNextRoute(route="admin.lookups/display",qs="lookupclass=#rc.lookupclass#");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="dspEdit" output="false" access="public" returntype="void" hint="Edit System Lookups">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var rc = event.getCollection();
		var i = 1;
		var tmpAlias = "";
		
		//LookupCheck
		fncLookupCheck(event);
		
		/* exit handlers */
		rc.xehLookupCreate = "admin.lookups/doUpdate.cfm";
		rc.xehLookupUpdateRelation = "admin.lookups/doUpdateRelation.cfm";
		
		//Get the passed id's TO Object
		rc.oLookup = getLookupService().getLookupObject(rc.lookupClass,rc.id);

		//Get Lookup's md Dictionary
		rc.mdDictionary = getLookupService().getDictionary(rc.lookupClass);
		rc.pkValue = evaluate("rc.oLookup.get#rc.mdDictionary.PK#()");

		//Check ManyToOne Relations
		if ( ArrayLen(rc.mdDictionary.ManyToOneArray) ){
			//Get Lookup Listings
			for (i=1;i lte ArrayLen(rc.mdDictionary.ManyToOneArray); i=i+1){
				structInsert(rc,"q#rc.mdDictionary.ManyToOneArray[i].alias#",getLookupService().getListing(rc.mdDictionary.ManyToOneArray[i].className));
			}
		}
		//Check ManyToMany Relations
		if ( rc.mdDictionary.hasManyToMany ){
			for (i=1;i lte ArrayLen(rc.mdDictionary.manyToManyArray); i=i+1){
				tmpAlias = rc.mdDictionary.manyToManyArray[i].alias;
				//Get m2m relation query
				structInsert(rc,"q#tmpAlias#",getLookupService().getListing(rc.mdDictionary.manyToManyArray[i].linkToTO));
				//Get m2m relation Array
				structInsert(rc,"#tmpAlias#Array", evaluate("rc.oLookup.get#tmpAlias#Array()"));
			}
		}
		//view to display
		event.setView("admin/lookups/Edit");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doUpdate" output="false" access="public" returntype="void" hint="Update Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			var rc = event.getCollection();
			var oLookup = "";
			var tmpFKTO = "";
			//Get the Transfer Object's Metadata Dictionary
			var mdDictionary = "";
			var i = 1;

			//LookupCheck
			fncLookupCheck(event);

			//Metadata
			mdDictionary = getLookupService().getDictionary(rc.lookupClass);
			//Get Lookup Transfer Object to update
			oLookup = getLookupService().getLookupObject(rc.lookupClass, rc.id);
			//Populate it with RC data
			getPlugin("beanFactory").populateBean(oLookup);
			
			//Check for FK Relations
			if ( ArrayLen(mdDictionary.ManyToOneArray) ){
				//Loop Through relations
				for ( i=1;i lte ArrayLen(mdDictionary.ManyToOneArray); i=i+1 ){
					tmpFKTO = getLookupService().getLookupObject(mdDictionary.ManyToOneArray[i].className,rc["fk_"&mdDictionary.ManyToOneArray[1].alias]);
					//add the tmpTO to current oLookup before saving.
					evaluate("oLookup.set#mdDictionary.ManyToOneArray[1].alias#(tmpFKTO)");
				}
			}

			//Save Record(s)
			getLookupService().save(oLookup);

			/* Relocate back to listing */
			setNextRoute(route="admin.lookups/display",qs="lookupclass=#rc.lookupclass#");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doUpdateRelation" output="false" access="public" returntype="void" hint="Update a TO's m2m relation">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
			//Local Variables
			var rc = event.getCollection();
			var mdDictionary = "";
			var oLookup = "";
			var oRelation = "";
			var i = 1;
			var deleteRelationList = "";
			
			/* Incoming Args: lookupClass, Lookup id, addrelation[boolean], linkTO, linkAlias, m2m_{alias} = listing */

			//LookupCheck
			fncLookupCheck(event);

			//Get Lookup Transfer Object to update
			oLookup = getLookupService().getLookupObject(rc.lookupClass, rc.id);
			
			//Metadata
			mdDictionary = getLookupService().getDictionary(rc.lookupClass);

			//Adding or Deleting
			if ( event.getValue("addRelation",false) ){
				//Get the relation object
				oRelation = getLookupService().getLookupObject(rc.linkTO, rc["m2m_#rc.linkAlias#"]);
				//Check if it is already in the collection
				if ( not evaluate("oLookup.contains#rc.linkAlias#(oRelation)") ){
					//Add Relation to parent
					evaluate("oLookup.add#rc.linkAlias#(oRelation)");
				}
			}
			else{
				//Del Param
				event.paramValue("m2m_#rc.linkAlias#_id","");
				deleteRelationList = rc["m2m_#rc.linkAlias#_id"];
				//Remove Relations
				for (i=1; i lte listlen(deleteRelationList); i=i+1){
					//Get Relation Object
					oRelation = getLookupService().getLookupObject(rc.linkTO,listGetAt(deleteRElationList,i));
					//Remove Relation to parent
					evaluate("oLookup.remove#rc.linkAlias#(oRelation)");
				}
			}

			//Save Records
			getLookupService().save(oLookup);

			/* Relocate back to edit */
			setNextRoute(route="admin.lookups/dspEdit",qs="lookupclass=#rc.lookupclass#&id=#rc.id###m2m_#rc.linkAlias#");		
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	

<!----------------------------------- IOC DEPENDENCIES ------------------------------>

	<!--- Get/Set lookup Service --->
	<cffunction name="getLookupService" access="public" output="false" returntype="codex.model.lookups.LookupService" hint="Get LookupService">
		<cfreturn instance.LookupService/>
	</cffunction>	
	<cffunction name="setLookupService" access="public" output="false" returntype="void" hint="Set LookupService">
		<cfargument name="LookupService" type="codex.model.lookups.LookupService" required="true"/>
		<cfset instance.LookupService = arguments.LookupService/>
	</cffunction>
	
<!----------------------------------- PRIVATE ------------------------------>

	<cffunction name="fncLookupCheck" output="false" access="private" returntype="void" hint="Do a parameter check, else redirect">
		<cfargument name="event" type="any" required="true"/>
		<cfscript>
		if ( event.getValue("lookupclass","") eq "")
			setNextRoute("admin.lookups/display");
		</cfscript>
	</cffunction>


</cfcomponent>