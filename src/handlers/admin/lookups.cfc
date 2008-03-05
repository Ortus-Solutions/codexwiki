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
	
	<cffunction name="dspCreate" output="false" access="public" returntype="void" hint="Create Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		//collection reference
		var rc = event.getCollection();
		var i = 1;
		var oLookupService = getPlugin("ioc").getBean("lookupService");

			//LookupCheck
			fncLookupCheck(event);

			//Get Lookup's md Dictionary
			rc.mdDictionary = getPlugin("ioc").getBean("lookupService").getDictionary(rc.lookup);

			//Check Relations
			if ( rc.mdDictionary.hasManyToOne ){
				//Get Lookup Listings
				for (i=1;i lte ArrayLen(rc.mdDictionary.ManyToOneArray); i=i+1){
					structInsert(rc,"q#rc.mdDictionary.ManyToOneArray[i].alias#",getLookupService().getListing(rc.mdDictionary.ManyToOneArray[i].className));
				}
			}
			//Set view.
			event.setView("lookups/vwAdd");

		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="dspEdit" output="false" access="public" returntype="void" hint="Edit System Lookups">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var rc = event.getCollection();
		var i = 1;
		var oLookupService = getPlugin("ioc").getBean("lookupService");
		var tmpAlias = "";


			//LookupCheck
			fncLookupCheck(event);

			//Get the passed id's TO Object
			rc.oLookup = getLookupService().getListingObject(rc.lookup,rc.id);

			//Get Lookup's md Dictionary
			rc.mdDictionary = getLookupService().getDictionary(rc.lookup);
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
					//Get m2m array memento
					structInsert(rc,"#tmpAlias#Array", evaluate("rc.oLookup.get#tmpAlias#Memento()"));
				}
			}
			//view to display
			event.setView("lookups/vwEdit");
		}

		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doCreate" output="false" access="public" returntype="void" hint="Create Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var rc = event.getCollection();
		var oLookup = "";
		var oLookupService = getPlugin("ioc").getBean("lookupService");
		var tmpFKTO = "";
		//Get the Transfer Object's Metadata Dictionary
		var mdDictionary = "";
		var i = 1;


			//LookupCheck
			fncLookupCheck(event);

			//Metadata
			mdDictionary = getLookupService().getDictionary(rc.lookup);

			//Get New Lookup Transfer Object to save
			oLookup = getLookupService().getListingObject(rc.lookup);

			//Populate it with RC data
			getPlugin("beanFactory").populateBean(oLookup);

			//Check for FK Relations
			if ( ArrayLen(mdDictionary.ManyToOneArray) ){
				//Loop Through relations
				for ( i=1;i lte ArrayLen(mdDictionary.ManyToOneArray); i=i+1 ){
					tmpFKTO = getLookupService().getListingObject(mdDictionary.ManyToOneArray[i].className,rc["fk_"&mdDictionary.ManyToOneArray[1].alias]);
					//add the tmpTO to oLookup
					evaluate("oLookup.set#mdDictionary.ManyToOneArray[1].alias#(tmpFKTO)");
				}
			}

			//Tell service to save object
			getLookupService().save(oLookup);
			//Relocate to listing
			setnextEvent("lookups.dspLookups","lookup=#rc.lookup#");

		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doUpdate" output="false" access="public" returntype="void" hint="Update Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var rc = event.getCollection();
		var oLookup = "";
		var oLookupService = getPlugin("ioc").getBean("lookupService");
		var tmpFKTO = "";
		//Get the Transfer Object's Metadata Dictionary
		var mdDictionary = "";
		var i = 1;

			//LookupCheck
			fncLookupCheck(event);

			//Metadata
			mdDictionary = getLookupService().getDictionary(rc.lookup);

			//Get Lookup Transfer Object to update
			oLookup = getLookupService().getListingObject(rc.lookup, rc.id);

			//Populate it with RC data
			getPlugin("beanFactory").populateBean(oLookup);

			//Check for FK Relations
			if ( ArrayLen(mdDictionary.ManyToOneArray) ){
				//Loop Through relations
				for ( i=1;i lte ArrayLen(mdDictionary.ManyToOneArray); i=i+1 ){
					tmpFKTO = getLookupService().getListingObject(mdDictionary.ManyToOneArray[i].className,rc["fk_"&mdDictionary.ManyToOneArray[1].alias]);
					//add the tmpTO to oLookup
					evaluate("oLookup.set#mdDictionary.ManyToOneArray[1].alias#(tmpFKTO)");
				}
			}

			//Save Record
			getLookupService().save(oLookup);

			//Relocate to listing
			setnextEvent("lookups.dspLookups","lookup=#rc.lookup#");

		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doUpdateRelation" output="false" access="public" returntype="void" hint="Update a TO's m2m relation">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		//Local Variables
		var rc = event.getCollection();
		var oLookup = "";
		var oLookupService = getPlugin("ioc").getBean("lookupService");
		var mdDictionary = "";
		var oRelation = "";
		var i = 1;
		var deleteRelationList = "";


			//LookupCheck
			fncLookupCheck(event);

			//Get Lookup Transfer Object to update
			oLookup = getLookupService().getListingObject(rc.lookup, rc.id);
			//Metadata
			mdDictionary = getLookupService().getDictionary(rc.lookup);

			//Adding or Deleting
			if ( rc.addrelation ){
				//Get the relation object
				oRelation = getLookupService().getListingObject(rc.linkTO, rc["m2m_#rc.linkAlias#"]);
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
					oRelation = getLookupService().getListingObject(rc.linkTO,listGetAt(deleteRElationList,i));
					//Remove Relation to parent
					evaluate("oLookup.remove#rc.linkAlias#(oRelation)");
				}
			}

			//Save Records
			getLookupService().save(oLookup);

			//Relocate to edit
			setnextEvent("lookups.dspEdit","lookup=#rc.lookup#&id=#rc.id#");
		}

		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="doDelete" output="false" access="public" returntype="void" hint="Delete Lookup">
		<cfargument name="Event" type="coldbox.system.beans.requestContext">
		<cfscript>
		var i = 1;
		var rc = event.getCollection();
		var oLookupService = getPlugin("ioc").getBean("lookupService");


			//Check that listing sent in
			if ( event.getValue("lookupid","") neq "" ){
				//Loop throught listing and delete objects
				for(i=1; i lte listlen(rc.lookupid); i=i+1){
					//Delete Entry
					getLookupService().delete(rc.lookupclass,listgetAt(rc.lookupid,i));
				}
			}
			//Relocate back to listing
			setnextEvent("lookups.dspLookups","lookup=#rc.lookupclass#");
		}

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
		if ( event.getValue("lookup","") eq "")
			setnextEvent("lookups.dspLookups");
		</cfscript>
	</cffunction>


</cfcomponent>