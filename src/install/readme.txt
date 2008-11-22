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
Welcom to Codex
********************************************************************************

CodeX Wiki requires the following:

Transfer 1.0 or greater
ColdBox 2.6.2 or greater
ColdSpring 1.2 or greater

The version for this release of Codex is the following:

Releases

- Version 0.5 Beta 1 on Nov 2008
An incredible amount of changes and updates.

********************************************************************************
Database Installation
********************************************************************************

The supported databases at this moment are:
	- MySQL 5.0 and above
	
To install the database, just use mysql command line tools, HeidiSQL or MySQLAdmin
to restore the database using the script found on the appropriate version.

/codex
	/install
		/migration
			/{Version}
				/codexwiki_MySQLAdminBackup.sql (The entire codex database backup using MySQL Admin)
				/codexwiki_mysqldump.sql (The entire codex database backup using MySQL dump utility)
				/migration.cfm (The coldfusion migration script if upgrading from a another release)
				/Application.cfm (Where the datasource declaration is located)
				/assets (A folder of assets used by the migration scripts)

New Install
If you are doing a new installation, just restore the database from the codexwiki.sql file. Either
the MySQL Admin Backup file or the normal mysql dump file.

Upgrading Your Installation
If you are upgrading, please run the migration.cfm template from your browser.  This will
migrate your current wiki DB to this release.

********************************************************************************
Source Code Installation
********************************************************************************

1. Place the codex installation anywhere in your webserver. Thanks to ColdFusion 8, CodexWiki uses per-application mappings to where 
it is placed in the webserver.

2. If you place codex in another location that is not the webroot then you will have to modify the following setting. 
Open the file config/coldbox.xml.cfm and update the AppMapping setting to match your location.

<-- <I have installed codex under a directory called MyWiki -->
<Setting name="AppMapping" value="/MyWiki" />

3. By default, CodexWiki uses the datasource called codex, which is declared in the transfer datasource.xml file. 
If you would like to change it, then open the file and change the name of the datasource.

4. Make sure that you have Transfer 1.0 or >, ColdBox 2.6.2 or > and ColdSpring 1.2 installed.

5. Fire up your browser and hit the root's index.cfm for the main wiki page.

6. The default login/password for the administrator is the following: 

	username: admin
	password: codex
	
7. (Optional) We have a very simple script to install the verity collection and scheduler. 
You will find this in install/VerityInstaller.cfm. This will only work on Windows/Linux machines as Verity has not been ported to Mac OS X. 
By default, Codex uses a DB search engine.  You can configure the Verity search engine from the system options page.

