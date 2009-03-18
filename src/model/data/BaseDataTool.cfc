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
<cfcomponent name="BaseDataTool" output="false" hint="All exporters and importers will inherit from this base data tool class">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------>

	<cfscript>
		instance = structnew();
	</cfscript>

	<cffunction name="init" access="public" output="false" returntype="Base Data Tool Component" hint="Constructor">
		<cfscript>
		
			/* Return Instance */
			return this;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PUBLIC ------------------------------------------>



<!------------------------------------------- PRIVATE ------------------------------------------>

	<cffunction name="_serialize" access="public" returntype="string" output="false" hint="Serialize complex objects that implement serializable. Returns a binary string.">
		<!--- ************************************************************* --->
		<cfargument name="ComplexObject" type="any" required="true" hint="Any coldfusion primative data type and if cf8 componetns."/>
        <!--- ************************************************************* --->
		<cfscript>
            var ByteArrayOutput = CreateObject("java", "java.io.ByteArrayOutputStream").init();
            var ObjectOutput    = CreateObject("java", "java.io.ObjectOutputStream").init(ByteArrayOutput);
           
            /* Serialize the incoming object. */
            ObjectOutput.writeObject(arguments.ComplexObject);
            ObjectOutput.close();

            return ToBase64(ByteArrayOutput.toByteArray());
        </cfscript>
    </cffunction>
    
    <!--- Serialize an object to a file --->
    <cffunction name="_serializeToFile" access="public" returntype="void" output="false" hint="Serialize complex objects that implement serializable, into a file.">
		<!--- ************************************************************* --->
		<cfargument name="ComplexObject" type="any" required="true" hint="Any coldfusion primative data type and if cf8 componetns."/>
        <cfargument name="fileDestination" required="true" type="string" hint="The absolute path to the destination file to write to">
        <!--- ************************************************************* --->
		<cfscript>
            var FileOutput = CreateObject("java", "java.io.FileOutputStream").init("#arguments.fileDestination#");
            var ObjectOutput    = CreateObject("java", "java.io.ObjectOutputStream").init(FileOutput);
           
            /* Serialize the incoming object. */
            ObjectOutput.writeObject(arguments.ComplexObject);
            ObjectOutput.close();
        </cfscript>
    </cffunction>
    
    <!--- Deserialize a byte array --->
    <cffunction name="_deserialize" access="public" returntype="Any" output="false" hint="Deserialize a byte array">
        <!--- ************************************************************* --->
		<cfargument name="BinaryString" type="string" required="true" hint="The byte array string to deserialize"/>
        <!--- ************************************************************* --->
		<cfscript>
            var ByteArrayInput = CreateObject("java", "java.io.ByteArrayInputStream").init(toBinary(arguments.BinaryString));
    		var ObjectInput    = CreateObject("java", "java.io.ObjectInputStream").init(ByteArrayInput);
	           
           	/* Return inflated Object. */
            return ObjectInput.readObject();
        </cfscript>
    </cffunction>
    
     <!--- Deserialize a byte array --->
    <cffunction name="_deserializeFromFile" access="public" returntype="Any" output="false" hint="Deserialize a byte array from a file">
        <!--- ************************************************************* --->
		<cfargument name="fileSource" required="true" type="string" hint="The absolute path to the source file to deserialize">
        <!--- ************************************************************* --->
		<cfscript>
			var object = "";
            var FileInput = CreateObject("java", "java.io.FileInputStream").init("#arguments.fileSource#");
    		var ObjectInput    = CreateObject("java", "java.io.ObjectInputStream").init(FileInput);
	           
           	/* Return inflated Object. */
           	object = ObjectInput.readObject();
           	ObjectInput.close();
           	
            return object;
        </cfscript>
    </cffunction>

</cfcomponent>