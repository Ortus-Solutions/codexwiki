# HeidiSQL Dump 
#
# --------------------------------------------------------
# Host:                         127.0.0.1
# Database:                     codex
# Server version:               5.0.37-community-nt
# Server OS:                    Win32
# Target compatibility:         ANSI SQL
# HeidiSQL version:             4.0 RC1
# --------------------------------------------------------

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ANSI,NO_BACKSLASH_ESCAPES';*/
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;*/


#
# Database structure for database 'codex'
#

DROP DATABASE IF EXISTS "codex";
CREATE DATABASE "codex" /*!40100 DEFAULT CHARACTER SET latin1 */;

USE "codex";


#
# Table structure for table 'wiki_category'
#

CREATE TABLE "wiki_category" (
  "category_id" varchar(36) NOT NULL,
  "category_name" varchar(255) NOT NULL,
  "category_createddate" datetime default NULL,
  PRIMARY KEY  ("category_id"),
  KEY "idx_wiki_category_name" ("category_name")
);



#
# Dumping data for table 'wiki_category'
#

# No data found.



#
# Table structure for table 'wiki_customhtml'
#

CREATE TABLE "wiki_customhtml" (
  "customHTML_id" varchar(36) NOT NULL,
  "customHTML_beforeHeadEnd" text,
  "customHTML_afterBodyStart" text,
  "customHTML_beforeBodyEnd" text,
  "customHTML_modify_date" datetime NOT NULL,
  "customHTML_afterSideBar" text,
  "customHTML_beforeSideBar" text,
  PRIMARY KEY  ("customHTML_id")
);



#
# Dumping data for table 'wiki_customhtml'
#

LOCK TABLES "wiki_customhtml" WRITE;
/*!40000 ALTER TABLE "wiki_customhtml" DISABLE KEYS;*/
INSERT INTO "wiki_customhtml" ("customHTML_id", "customHTML_beforeHeadEnd", "customHTML_afterBodyStart", "customHTML_beforeBodyEnd", "customHTML_modify_date", "customHTML_afterSideBar", "customHTML_beforeSideBar") VALUES
	('64597197-CF1E-5C1B-91F2B0710FA5B5B3','','','','2008-05-09 13:40:34','','');
/*!40000 ALTER TABLE "wiki_customhtml" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_namespace'
#

CREATE TABLE "wiki_namespace" (
  "namespace_id" varchar(36) NOT NULL,
  "namespace_name" varchar(255) NOT NULL,
  "namespace_description" varchar(255) NOT NULL,
  "namespace_isdefault" tinyint(4) NOT NULL default '0',
  PRIMARY KEY  ("namespace_id"),
  KEY "idx_wiki_namespace_name" ("namespace_name")
);



#
# Dumping data for table 'wiki_namespace'
#

LOCK TABLES "wiki_namespace" WRITE;
/*!40000 ALTER TABLE "wiki_namespace" DISABLE KEYS;*/
INSERT INTO "wiki_namespace" ("namespace_id", "namespace_name", "namespace_description", "namespace_isdefault") VALUES
	('06AF3D1C-0B00-EAA3-09A138DFA27F7E28','Special','Special',0);
INSERT INTO "wiki_namespace" ("namespace_id", "namespace_name", "namespace_description", "namespace_isdefault") VALUES
	('58F2F981-F62A-3124-E886BBF8CE6C5295','Help','Help',0);
INSERT INTO "wiki_namespace" ("namespace_id", "namespace_name", "namespace_description", "namespace_isdefault") VALUES
	('F1C0292E-CB06-FD09-41D904E8550FE734','','Default Namespace',1);
/*!40000 ALTER TABLE "wiki_namespace" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_options'
#

CREATE TABLE "wiki_options" (
  "option_id" varchar(36) NOT NULL,
  "option_name" varchar(255) NOT NULL,
  "option_value" text NOT NULL,
  PRIMARY KEY  ("option_id"),
  UNIQUE KEY "Index_2" ("option_name")
);



#
# Dumping data for table 'wiki_options'
#

LOCK TABLES "wiki_options" WRITE;
/*!40000 ALTER TABLE "wiki_options" DISABLE KEYS;*/
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F03F883-AFFA-A78C-1A2EDA50675A3B46','wiki_defaultpage','Dashboard');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F045002-0E99-A690-7C59F405F98A19BE','wiki_search_engine','codex.model.search.adapters.DBSearch');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F0485D1-F0AB-DF57-DCD68A6AE5F2FF33','wiki_name','A Sweet Wiki');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F050595-E875-9C19-9978C4F271441867','wiki_paging_maxrows','10');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F052A79-DA80-9757-F8B952EFF0BF467E','wiki_paging_bandgap','5');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F05890F-C8D4-A7E1-7C60462D3C7AA437','wiki_defaultpage_label','My Dashboard');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F0622D3-A20F-60CF-5AE67B68F7294189','wiki_comments_mandatory','1');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('9F0716AB-AF0A-8D94-4AEAA59490D24CB2','wiki_outgoing_email','myemail@email.com');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('A2E52F85-EC94-6F0D-63D54DA07F9054E9','wiki_defaultrole_id','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('B1D80246-CF1E-5C1B-91310C4FA0F78984','wiki_metadata','codex wiki');
INSERT INTO "wiki_options" ("option_id", "option_name", "option_value") VALUES
	('B1DD1CDD-CF1E-5C1B-9106B89C23AB9410','wiki_metadata_keywords','codex coldbox transfer wiki');
/*!40000 ALTER TABLE "wiki_options" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_page'
#

CREATE TABLE "wiki_page" (
  "page_id" varchar(36) NOT NULL,
  "page_name" varchar(255) NOT NULL,
  "FKnamespace_id" varchar(36) default NULL,
  PRIMARY KEY  ("page_id"),
  KEY "FKnamespace_id" ("FKnamespace_id"),
  KEY "FKnamespace_id_2" ("FKnamespace_id"),
  KEY "idx_wiki_page_name" ("page_name"),
  CONSTRAINT "FKnamespace_id" FOREIGN KEY ("FKnamespace_id") REFERENCES "wiki_namespace" ("namespace_id")
);



#
# Dumping data for table 'wiki_page'
#

LOCK TABLES "wiki_page" WRITE;
/*!40000 ALTER TABLE "wiki_page" DISABLE KEYS;*/
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('06AF3D6A-0AB3-43E6-EF2D1118F58A1562','Special:Feeds','06AF3D1C-0B00-EAA3-09A138DFA27F7E28');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('58F2F999-FC99-125A-DB21FCD7085C44A1','Help:Contents','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('59014C5F-C1C6-7E91-A38446214A380C7D','Help:Wiki_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('59104F5A-9555-E540-6BCAA65D9AE6F448','Help:List_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('A8736248-DCE2-A123-A6DA083754C59203','Help:Cheatsheet','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('A895949D-B7C5-34B5-0E32B0CE52BC3FA0','Help:Messagebox_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('B5C4FA1D-CF1E-5C1B-950B4A04E276B736','Help:Codex_Wiki_Plugins','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('C90869A2-090D-50DA-0800C94BB5DB7026','Help:Feed_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('E12403BB-F4C1-5F8A-1B20DB3894BAF144','Dashboard','F1C0292E-CB06-FD09-41D904E8550FE734');
INSERT INTO "wiki_page" ("page_id", "page_name", "FKnamespace_id") VALUES
	('E5CC1A90-D36E-9214-33EB0021D817DE59','Special:Categories','06AF3D1C-0B00-EAA3-09A138DFA27F7E28');
/*!40000 ALTER TABLE "wiki_page" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_pagecontent'
#

CREATE TABLE "wiki_pagecontent" (
  "pagecontent_id" varchar(36) NOT NULL,
  "FKpage_id" varchar(36) NOT NULL,
  "FKuser_id" varchar(36) NOT NULL,
  "pagecontent_content" text,
  "pagecontent_comment" text,
  "pagecontent_version" bigint(20) NOT NULL default '1',
  "pagecontent_createdate" datetime NOT NULL,
  "pagecontent_isActive" tinyint(4) NOT NULL default '1',
  "pagecontent_isReadOnly" tinyint(1) NOT NULL default '0',
  PRIMARY KEY  ("pagecontent_id"),
  KEY "FKpage_id" ("FKpage_id"),
  KEY "FKuser_id" ("FKuser_id"),
  KEY "idx_wiki_pagecontent_isActive" ("pagecontent_isActive"),
  CONSTRAINT "FK_wiki_pagecontent_wiki_page" FOREIGN KEY ("FKpage_id") REFERENCES "wiki_page" ("page_id"),
  CONSTRAINT "FK_wiki_pagecontent_wiki_users" FOREIGN KEY ("FKuser_id") REFERENCES "wiki_users" ("user_id")
);



#
# Dumping data for table 'wiki_pagecontent'
#

LOCK TABLES "wiki_pagecontent" WRITE;
/*!40000 ALTER TABLE "wiki_pagecontent" DISABLE KEYS;*/
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('06AF3D9F-F000-34AC-65CBF528D2F4F658','06AF3D6A-0AB3-43E6-EF2D1118F58A1562','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Codex RSS Feed Directory ==
<feed url="/feed/directory/list.cfm" />',NULL,'1','2008-02-11 15:09:50',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('5906B62D-FBD0-6F75-B6B7BF36DCD904C5','59014C5F-C1C6-7E91-A38446214A380C7D','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','==Wiki markup==

The ''''''wiki markup'''''' is the syntax system you can use to format a Wikipedia page; please see [[Help:Editing]] for details on it, and [[Help:Wikitext examples]] for a longer list of the possibilities of Wikitext.

===Links and URLs===
{| border="1" cellpadding="2" cellspacing="0"
|- valign="top"
! What it looks like
! What you type
|- id="emph" valign="top"
|
London has [[public transport]].

* A link to another Wiki article.
* Internally, the first letter of the target page is automatically capitalized and spaces are represented as underscores (typing an underscore in the link has the same effect as typing a space, but is not recommended).
* Thus the link above is to the [[URL]] en.wikipedia.org/wiki/Public_transport, which is the Wikipedia article with the name "Public transport". See also [[Wikipedia:Canonicalization]].
|
<pre><nowiki>
London has [[public transport]].
</nowiki></pre>
|- valign="top"
|
San Francisco also has [[public transport|
public transportation]].

* Same target, different name.
* The target ("piped") text must be placed ''''''first'''''', then the text that will be displayed second.
|
<pre><nowiki>
San Francisco also has
[[public transport| public transportation]].
</nowiki></pre>
|- valign="top"
|
San Francisco also has
[[public transport]]ation.

Examples include [[bus]]es, [[taxicab]]s,
and [[streetcar]]s.

* Endings are blended into the link.
* Preferred style is to use this instead of a piped link, if possible.
* Blending can be suppressed by using <nowiki><nowiki></nowiki></nowiki> tags, which may be desirable in some instances.  Example: a [[micro]]<nowiki>second</nowiki>.
|
<pre><nowiki>
San Francisco also has
[[public transport]]ation.

Examples include [[bus]]es,
 [[taxicab]]s, and [[streetcar]]s.

a [[micro]]<nowiki>second</nowiki>
</nowiki></pre>
|- valign="top"
|
See the [[Wikipedia:Manual of Style]].

* A link to another [[Help:namespace|namespace]].
|
<pre><nowiki>
See the 
[[Wikipedia:Manual of Style]].
</nowiki></pre>

|- id="link-to-section" valign="top"
|
[[Wikipedia:Manual of Style#Italics]] is a link to a section within another page.

[[#Links and URLs]] is a link to another section on the current page.

[[Wikipedia:Manual of Style#Italics|Italics]] is a piped link to a section within another page.

* The part after the number sign (#) must match a section heading on the page. Matches must be exact in terms of spelling, case, and punctuation.  Links to non-existent sections are not broken; they are treated as links to the top of the page.
* Include "| link title" to create a stylish (piped) link title.

|
<pre><nowiki>
[[Wikipedia:Manual of Style#Italics]] 
is a link to a section within another page.

[[#Links and URLs]] is a link
to another section on the 
current page.

[[Wikipedia:Manual of Style#Italics|Italics]] 
is a piped link to a section within 
another page.</nowiki></pre>
|- valign="top"
|
Automatically hide stuff in parentheses:
[[kingdom (biology)|kingdom]].

Automatically hide namespace:
[[Wikipedia:Village Pump|Village Pump]]. 

Or both:
[[Wikipedia:Manual of Style (headings)|Manual of Style]]

But not:
[[Wikipedia:Manual of Style#Links|]]
* The server fills in the part after the pipe character (|) when you save the page. The next time you open the edit box you will see the expanded piped link. When [[Wikipedia:Show preview|preview]]ing your edits, you will not see the expanded form until you press ''''''Save'''''' and ''''''Edit'''''' again. The same applies to links to sections within the same page ([[#link-to-section|see previous entry]]).
* See [[Wikipedia:Pipe trick]] for details.

|
<pre><nowiki>
Automatically hide stuff
in parentheses:
[[kingdom (biology)|]].

Automatically hide namespace: 
[[Wikipedia:Village Pump|]].

Or both:
[[Wikipedia:
Manual of Style (headings)|]]

But not:
[[Wikipedia:
Manual of Style#Links|]]
</nowiki></pre>


|- valign="top"
|
<!-- A village pump proposal was made so that users would be allowed to create the article shown here. Pages here would be articles requested for a long time. If you find someone has created the article, please look in requested articles and put one in its place -->
[[National sarcasm society]] is a page
that does not exist yet.

* You can create it by clicking on the link.
* To create a new page: 
*# Create a link to it on some other (related) page.
*# Save that page.
*# Click on the link you just made. The new page will open for editing.
* For more information, see [[Wikipedia:How to start a page|How to start a page]] and check out Wikipedia''s [[Wikipedia:Naming conventions|naming conventions]].
* Please do not create a new article without linking to it from at least one other article.
|
<pre><nowiki>
[[National sarcasm society]]
is a page 
that does not exist yet.
</nowiki></pre>
|- valign="top"
|

[[Wikipedia:How to edit a page]] is a link to this page.

* [[Help:Self link|Self link]]s appear as bold text when the article is viewed.
* Do not use this technique to make the article name bold in the first paragraph; see the [[Wikipedia:Manual of Style#Article titles|Manual of Style]].
|
<pre><nowiki>
[[Wikipedia:How to edit a page]]
is a link to this page.
</nowiki></pre>
|- valign="top"
|
The character ''''''tilde'''''' (~) is used when adding a comment to a Talk page. 
You should sign your comment by appending four tildes (<nowiki>~~~~</nowiki>)
to the comment so as to add your user name plus date/time:
: [[User:Patricia|Patricia Zhang]] 13:40, Jan 14, 2007 (UTC)
Adding three tildes (<nowiki>~~~</nowiki>) will add just your user name:
: [[User:Patricia|Patricia Zhang]]
and adding five tildes (<nowiki>~~~~~</nowiki>) gives the date/time alone:
: 13:40, Jan 14, 2007 (UTC)

* The first two both provide a link to your [[Wikipedia:user page|user page]].
|
<pre><nowiki>
The character ''''''tilde'''''' (~) is used 
when adding a comment to a Talk page. 
You should sign your comment by 
appending four tildes (~~~~)
to the comment so as to add your 
user name plus date/time:
: ~~~~
Adding three tildes (~~~) will add 
just your user name:
: ~~~
and adding five tildes (~~~~~) gives 
the date/time alone:
: ~~~~~
</nowiki></pre>
|- valign="top"
|
* [[Wikipedia:Redirect|Redirect]] one article title to another by placing a directive like the one shown to the right on the ''''first'''' line of the article (such as at a page titled "[[USA]]").
* It is possible to redirect to a section. For example, a redirect to [[United States#History|United States History]] will redirect to the [[United States]] page, to the History section if it exists.
|
<pre><nowiki>
#REDIRECT [[United States]]

#REDIRECT [[United States#History|United 
States History]] will redirect to the 
[[United States]] page, to the History 
section if it exists 
</nowiki></pre>
|- valign="top"
|

* Link to a page on the same subject in another language by placing a link of the form: <nowiki>[[language code:Title]]</nowiki> in the wiki text of the article.
For example in the article on [[Plankton]], which is available on a lot of other wikis, the interlanguage links would look like so:
:<tt><nowiki>[[de:Plankton]] [[es:Plancton]] [[ru:????????]] [[simple:Plankton]]</nowiki></tt>
* While it does not matter where you put these links while editing, it is recommended that these links be placed at the very end of the edit box. 
* These will not be visible in the main text of the article on which they are placed but appear as links in the extreme left margin column of Wikipedia page as part of a separate box under the ''toolbox'' titled ''in other languages''. You can check out the links to the corresponding page in wikipedias of other languages for this Wikipedia MOS help page itself.
* Please see [[Wikipedia:Interlanguage links]] and the [[Wikipedia:Complete list of language wikis available|list of languages and codes]].
|
<pre><nowiki>
</nowiki></pre>
|- valign="top"
|
''''''What links here'''''' and ''''''Related changes''''''
pages can be linked as:
[[Special:Whatlinkshere/Wikipedia:How to edit a page]]
and
[[Special:Recentchangeslinked/Wikipedia:How to edit a page]]

|
<pre><nowiki>
''''''What links here'''''' and
''''''Related changes''''''
pages can be linked as:
[[Special:Whatlinkshere/
Wikipedia:How to edit a page]]
and
[[Special:Recentchangeslinked/
Wikipedia:How to edit a page]]
</nowiki></pre>
|- valign="top"
|
A user''s ''''''Contributions'''''' page can be linked as:
[[Special:Contributions/UserName]]
or
[[Special:Contributions/192.0.2.0]]
|
<pre><nowiki>
A user''s ''''''Contributions'''''' page
can be linked as:
[[Special:Contributions/UserName]]
or
[[Special:Contributions/192.0.2.0]]
</nowiki></pre>
|- valign="top"
|
* To put an article in a [[Wikipedia:Category]], place a link like the one to the right anywhere in the article. As with interlanguage links, it does not matter where you put these links while editing as they will always show up in the same place when you save the page, but placement at the end of the edit box is recommended.
|
<pre><nowiki>
[[Category:Character sets]]
</nowiki></pre>
|- valign="top"
|
* To ''''link'''' to a [[Wikipedia:Category]] page without putting the article into the category, use an initial colon (:) in the link.
|
<pre><nowiki>
[[:Category:Character sets]]
</nowiki></pre>
|- id="link-external" valign="top"
|
Three ways to link to external (non-wiki) sources:
# Bare URL: http://www.wikipedia.com/ (bad style)
# Unnamed link: [http://www.wikipedia.com/] (only used within article body for footnotes)
# Named link: [http://www.wikipedia.com Wikipedia]

:See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts.

* Square brackets indicate an external link. Note the use of a ''''space'''' (not a pipe) to separate the URL from the link text in the "named" version.
* In the [[URL]], all symbols must be among:<br/>''''''A-Z a-z 0-9 . _ \ / ~ % - + & # ? ! = ( ) @''''''
* If a URL contains a character not in this list, it should be encoded by using a percent sign (%) followed by the [[hexadecimal|hex]] code of the character, which can be found in the table of [[ASCII#ASCII printable characters|ASCII printable characters]]. For example, the caret character (^) would be encoded in a URL as ''''''%5E''''''.
* If the "named" version contains a closing square bracket "]", then you must use the [[HTML]] special character syntax, i.e. '''''']'''''' otherwise the [[MediaWiki]] software will prematurely interpret this as the end of the external link.
* There is a class that can be used to remove the arrow image from the external link. It is used in [[Template:Ref]] to stop the URL from expanding during printing. It should ''''''never'''''' be used in the main body of an article. However, there is an exception: wikilinks in Image markup. An example of the markup is as follows:
** Markup: <nowiki><span
class="plainlinksneverexpand">
[http://www.sysinternals.com/
ntw2k/freeware/winobj.shtml WinObj]</span></nowiki>
** Display: <span class="plainlinksneverexpand"> [http://www.sysinternals.com/ntw2k/freeware/winobj.shtml WinObj]</span>
* See [[Wikipedia:External links]] for style issues.
|
<pre><nowiki>
Three ways to link to
external (non-wiki) sources:
# Bare URL:
http://en.wikipedia.org/
(bad style)
# Unnamed link:
[http://en.wikipedia.org/]
(only used within article
body for footnotes)
# Named link:
[http://en.wikipedia.org Wikipedia]
</nowiki></pre>
|- valign="top"
|
Linking to other wikis:
# [[Interwiki]] link: [[Wiktionary:Hello]]
# Interwiki link without prefix: [[Wiktionary:Hello|Hello]]
# Named interwiki link: [[Wiktionary:Hello|Wiktionary definition of ''Hello'']]

* All of these forms lead to the URL http://en.wiktionary.org/wiki/Hello
* Note that interwiki links use the ''''internal'''' link style.
* See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts; if the site you want to link to is not on the list, use an external link ([[#link-external|see above]]).
* See also [[Wikipedia:Wikimedia sister projects]].

Linking to another language''s wiktionary:
# [[Wiktionary:fr:bonjour]]
# [[Wiktionary:fr:bonjour|bonjour]]
# [[Wiktionary:fr:bonjour|fr:bonjour]]

* All of these forms lead to the URL http://fr.wiktionary.org/wiki/bonjour
|
<pre><nowiki>
Linking to other wikis:
# [[Interwiki]] link:
[[Wiktionary:Hello]]
# Interwiki link without prefix:
[[Wiktionary:Hello|]]
# Named interwiki link:
[[Wiktionary:Hello|
Wiktionary definition 
of ''Hello'']]

Linking to another
language''s wiktionary:
# [[Wiktionary:fr:bonjour]]
# [[Wiktionary:fr:bonjour|bonjour]]
# [[Wiktionary:fr:bonjour|]]
</nowiki></pre>
|- valign="top"
|
ISBN 012345678X

ISBN 0-12-345678-X

* Link to books using their [[Wikipedia:ISBN|ISBN]]. This is preferred to linking to a specific online bookstore, because it gives the reader a choice of vendors. However, if one bookstore or online service provides additional free information, such as table of contents or excerpts from the text, then a link to that source will aid the user and is recommended.
* ISBN links do not need any extra markup, provided you use one of the indicated formats.
|
<pre><nowiki>
ISBN 012345678X

ISBN 0-12-345678-X
</nowiki></pre>
|- valign="top"
|
Text mentioning RFC 4321 anywhere

* Link to [[Internet Engineering Task Force]] [[Request for Comments|RFC]]s.
|
<pre><nowiki>
Text mentioning RFC 4321 
anywhere
</nowiki></pre>

|- valign=top
|
Date formats:
# [[July 20]], [[1969]]
# [[20 July]] [[1969]]
# [[1969]]-[[07-20]]
# [[1969-07-20]]

* Link dates in one of the above formats, so that everyone can set their own display order. If [[Special:Userlogin|logged in]], you can use [[Special:Preferences]] to change your own date display setting.
* All of the above dates will appear as "[[20 July|20 July]] [[1969|1969]]" if you set your date display preference to "15 January 2001", but as "[[20 July|July 20]], [[1969|1969]]" if you set it to "January 15, 2001", or as "[[1969|1969]]-[[July 20|07-20]]" if you set it to "2001-01-15".
|
<pre><nowiki>
Date formats:
# [[July 20]], [[1969]]
# [[20 July]] [[1969]]
# [[1969]]-[[07-20]]
# [[1969-07-20]]

</nowiki></pre>
|- valign="top"
|
Special [[WP:AO|as-of]] links like [[As of 2006|this year]]
needing future maintenance
|
<pre><nowiki>
Special [[WP:AO|as-of]] links 
like [[As of 2006|this year]]
needing future maintenance
</nowiki></pre>
|- valign="top"
|
[[media:Classical guitar scale.ogg|Sound]]

*To include links to non image uploads such as sounds, use a "media" link. For images, [[#Images|see next section]].

Some uploaded sounds are listed at [[Wikipedia:Sound]].
|
<pre><nowiki>
[[media:Classical guitar scale.ogg|Sound]]
</nowiki></pre>

|- valign="top"
|
Link directly to ''''''edit'''''' for an existing page, or apply other link attributes. 
* use <nowiki>{{fullurl:}}</nowiki>  
* or use [[template:edit|<nowiki>{{template:edit}}</nowiki>]] which conceals the edit label for page printing 
|
<pre><nowiki>{{fullurl:page name|action=edit}}</nowiki></pre>
|}

===Images===
Only images that have been uploaded to Wikipedia can be used. To upload images, use the [[Special:Upload|upload page]]. You can find the uploaded image on the [[Special:Imagelist|image list]].

{| border="1" cellpadding="2" cellspacing="0"
|-
! What it looks like
! What you type
|- valign="top"
|A picture: 
[[Image:wiki.png]]
|<pre>A picture: 
<nowiki>[[Image:wiki.png]]</nowiki></pre>

|- valign="top"
|With alternative text:
[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]
|<pre>With alternative text:
<nowiki>[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]</nowiki></pre>
* Alternative text, used when the image is unavailable or when the image is loaded in a text-only browser, or when spoken aloud, is ''''''strongly'''''' encouraged. See [[Wikipedia:Alternate text for images|Alternate text for images]] for help on choosing it.

|- valign="top"
|Floating to the right side of the page using the ''''frame'''' attribute and a caption:
[[Image:wiki.png|frame|Wikipedia Encyclopedia]]<br clear=all>
|<pre>Floating to the right side of the page 
using the ''''frame'''' attribute and a caption:
<nowiki>[[Image:wiki.png|frame|Wikipedia Encyclopedia]]</nowiki></pre>
* The frame tag automatically floats the image right.
* The caption is also used as alternate text.

|- valign="top"
|Floating to the right side of the page using the ''''thumb'''' attribute and a caption:
[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]<br clear=all>
|<pre>Floating to the right side of the page 
using the ''''thumb'''' attribute and a caption:
<nowiki>[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]</nowiki></pre>
* The thumb tag automatically floats the image right.
* The caption is also used as alternate text.
* An enlarge icon is placed in the lower right corner.

|- valign="top"
|Floating to the right side of the page ''''without'''' a caption:
[[Image:wiki.png|right|Wikipedia Encyclopedia]]
|<pre>Floating to the right side of the page
''''without'''' a caption:
<nowiki>[[Image:wiki.png|right|Wikipedia Encyclopedia]]</nowiki></pre>
* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.

|- valign="top"
|A picture resized to 30 pixels...
[[Image:wiki.png|30 px]]
|<pre>A picture resized to 30 pixels...
<nowiki>[[Image:wiki.png|30 px]]</nowiki></pre>
* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.

|- valign="top"
|Linking directly to the description page of an image:
[[:Image:wiki.png]]
|<pre>Linking directly to the description page
of an image:
<nowiki>[[:Image:wiki.png]]</nowiki></pre>
* Clicking on an image displayed on a page
(such as any of the ones above)
also leads to the description page

|- valign="top"
|Linking directly to an image without displaying it:
[[:Image:wiki.png|Image of the jigsaw globe logo]]
|<pre>Linking directly to an image
without displaying it:
<nowiki>[[:media:wiki.png|Image of the jigsaw globe logo]]</nowiki></pre>
* To include links to images shown as links instead of drawn on the page, use a "media" link.

|- valign="top" 
|Using the [[div tag]] to separate images from text (note that this may allow images to cover text):
|<pre><nowiki>Example:
<div style="display:inline;
width:220px; float:right;">
Place images here </div></nowiki></pre>

|- valign="top" 
|Using wiki markup to make a table in which to place a vertical column of images (this helps edit links match headers, especially in Firefox browsers): 
|<pre><nowiki>Example: {| align=right
|-
| 
Place images here
|}
</nowiki></pre>

|}

See the Wikipedia''s [[Wikipedia:Image use policy|image use policy]] as a guideline used on Wikipedia.

For further help on images, including some more versatile abilities, see the topic on [[Wikipedia:Extended image syntax|Extended image syntax]].

===Headings===

For a top-level heading, put it on a separate line surrounded by ''==''. For example:

   ==Introduction==

Subheadings use ''==='', ''===='', and so on.

===Character formatting===
{| border="1" cellpadding="2" cellspacing="0"
|- valign="top"
! What it looks like
! What you type
|- id="emph" valign="top"
|
''''Italicized text''''<br />''''''Bold text''''''<br />''''''''''Italicized & Bold text''''''''''
|
<pre><nowiki>
''''Italicized text''''
''''''Bold text''''''
''''''''''Italicized & Bold text''''''''''
</nowiki></pre>
|- valign="top"
|
A typewriter font for <tt>monospace text</tt>
or for computer code: <code>int main()</code>

* For semantic reasons, using <code><code></code> where applicable is preferable to using <code><tt></code>.
|
<pre><nowiki>
A typewriter font for <tt>monospace text</tt>
or for computer code: <code>int main()</code>
</nowiki></pre>
|- valign=top
|
Create codeblocks<code><pre>
#include <iostream.h>
int main ()
{
cout << "Hello World!";
return 0;
}
</pre></code> that are printed as entered
|
<pre>Use <code><pre> Block of Code </pre></code> 
around the block of code.

* The <pre> tags within the code block 
will create formatting issues. To solve, 
display the tags literally with 
<pre>  and  </pre></pre>
|- valign="top"
|
You can use <small>small text</small> for captions.
|
<pre><nowiki>
You can use <small>small text</small> for captions.
</nowiki></pre>
|- valign="top"
|
Better stay away from <big>big text</big>, unless
<small> it''s <big>within</big> small</small> text. 
|
<pre><nowiki>
Better stay away from <big>big text</big>, unless
<small> it''s <big>within</big> small</small> text.
</nowiki></pre>
|- valign="top"
|
You can <s>strike out deleted material</s>
and <u>underline new material</u>.

You can also mark <del>deleted material</del> and
<ins>inserted material</ins> using logical markup.
For backwards compatibility better combine this
potentially ignored new <del>logical</del> with 
the old <s><del>physical</del></s> markup.

* When editing regular Wikipedia articles, just make your changes and do not mark them up in any special way.
* When editing your own previous remarks in talk pages, it is sometimes appropriate to mark up deleted or inserted material.
|
<pre><nowiki>
You can <s>strike out deleted material</s>
and <u>underline new material</u>.

You can also mark <del>deleted material</del> and
<ins>inserted material</ins> using logical markup.
For backwards compatibility better combine this
potentially ignored new <del>logical</del> with
the old <s><del>physical</del></s> markup.
</nowiki></pre>
|- valign="top"
|
''''''Suppressing interpretation of markup:''''''
<br/>
<nowiki>Link ? (''''to'''') the [[Wikipedia FAQ]]</nowiki>
* Used to show literal data that would otherwise have special meaning.
* Escape all wiki markup, including that which looks like HTML tags.
* Does not escape HTML character references.
* To escape HTML character references such as <tt>?</tt> use <tt>&rarr;</tt>
|
<br/>
<pre><nowiki>
<nowiki>Link ? (''''to'''') 
the [[Wikipedia FAQ]]</nowiki>
</nowiki></pre>
|- valign="top"
|
''''''Commenting page source:''''''
<br/>
''''not shown when viewing page''''
* Used to leave comments in a page for future editors.
* Note that most comments should go on the appropriate [[Wikipedia:Talk page|Talk page]].
|
<br/>
<pre><nowiki>
<!-- comment here -->
</nowiki></pre>
|- valign="top"
|
''''''<span id="diacritics">Diacritical marks:</span>''''''
<br/>
À Á Â Ã Ä Å <br/>
Æ Ç È É Ê Ë <br/>
Ì Í
Î Ï Ñ Ò <br/>
Ó Ô Õ
Ö Ø Ù <br/>
Ú Û Ü ß
à á <br/>
â ã ä å æ
ç <br/>
è é ê ë ì í<br/>
î ï ñ ò ó ô <br/>
œ õ
ö ø ù ú <br/>
û ü ÿ

* See [[meta:Help:Special characters|special characters]].
|
<br/>
<pre><nowiki>
À Á Â Ã Ä Å 
Æ Ç È É Ê Ë 
Ì Í Î Ï Ñ Ò 
Ó Ô Õ Ö Ø Ù 
Ú Û Ü ß à á 
â ã ä å æ ç 
è é ê ë ì í
î ï ñ ò ó ô 
œ õ ö ø ù ú 
û ü ÿ
</nowiki></pre>
|- valign="top"
|
''''''Punctuation:''''''
<br/>
¿ ¡ § ¶<br/>
† ‡ • – —<br/>
‹ › « »<br/>
‘ ’ “ ”
|
<br/>
<pre><nowiki>
¿ ¡ § ¶
† ‡ • – —
‹ › « »
‘ ’ “ ”
</nowiki></pre>
|- valign="top"
|
''''''Commercial symbols:''''''
<br/>
™ © ® ¢ € ¥<br/>
£ ¤
|
<br/>
<pre><nowiki>
™ © ® ¢ € ¥ 
£ ¤
</nowiki></pre>
|- valign="top"
|
''''''Subscripts:''''''
<br/>
x<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or
<br/>
x? x? x? x? x?
<br/>
x? x? x? x? x?

''''''Superscripts:''''''
<br/>
x<sup>1</sup> x² x³ or
<br/>
x? x¹ x² x³ x?
<br/>
x? x? x? x? x?

*The latter methods of sub/superscripting cannot be used in the most general context, as they rely on Unicode support which may not be present on all users'' machines. For the 1-2-3 superscripts, it is nevertheless preferred when possible (as with units of measurement) because most browsers have an easier time formatting lines with it.

?<sub>0</sub> =
8.85 × 10<sup>?12</sup>
C² / J m.

1 [[hectare]] = [[1 E4 m²]]
|
<br/>
<pre><nowiki>
x<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or
<br/>
x? x? x? x? x?
<br/>
x? x? x? x? x?
</nowiki></pre>

<pre><nowiki>
x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> or
<br/>
x? x¹ x² x³ x?
<br/>
x? x? x? x? x?

?<sub>0</sub> =
8.85 × 10<sup>?12</sup>
C² / J m.

1 [[hectare]] = [[1 E4 m²]]
</nowiki></pre>
|- valign="top"
|
''''''Greek characters:''''''
<br/>
? ? ? ? ? ? <br/>
? ? ? ? ? ? ? <br/>
? ? ? ? ? ?<br/>
? ? ? ? ? ?<br/>
? ? ? ? ? ? <br/>
? ? ? ?
|
<br/>
<pre><nowiki>
? ? ? ? ? ? 
? ? ? ? ? ? ? 
? ? ? ? ? ?
? ? ? ? ? ?
? ? ? ? ? ? 
? ? ? ?
</nowiki></pre>
|- valign="top"
|
''''''Mathematical characters:''''''
<br/>
? ? ? ? ? ± ?<br/>
? ? ? ? ? ?<br/>
× · ÷ ? ? ?<br/>
? ‰ ° ? ? ø<br/>
? ? ? ? ? ? ? ?<br/>
¬ ? ? ? ? <br/>
? ? ? ? ?<br/>
? ? ? ? ?<br/>
* See also [[Wikipedia:WikiProject Mathematics|WikiProject Mathematics]] and [[TeX]].
|
<br/>
<pre><nowiki>
? ? ? ? ? ± ?
? ? ? ? ? ?
× · ÷ ? ? ?
? ‰ ° ? ? ø
? ? ? ? ? ? ? ?
¬ ? ? ? ? 
? ? ? ? ?
? ? ? ? ?
</nowiki></pre>
|- valign="top"
|
<math>\,\! \sin x + \ln y</math><br>
sin''''x'''' + ln''''y''''
<!-- no space between roman "sin" and italic "x" -->

<math>\mathbf{x} = 0</math><br>
''''''x'''''' = 0

Ordinary text should use [[#emph|wiki markup for emphasis]], and should not use <code><i></code> or <code><b></code>.  However, mathematical formulae often use italics, and sometimes use bold, for reasons unrelated to emphasis.  Complex formulae should use [[Help:Formula|<code><math></code> markup]], and simple formulae may use <code><math></code>; or <code><i></code> and <code><b></code>; or <code><nowiki>''''</nowiki></code> and <code><nowiki>''''''</nowiki></code>.  According to [[Wikipedia:WikiProject Mathematics#Italicization and bolding|WikiProject Mathematics]], wiki markup is preferred over HTML markup like <code><i></code> and <code><b></code>.
|
<pre><nowiki>
<math>\,\! \sin x + \ln y</math>
sin''''x'''' + ln''''y''''

<math>\mathbf{x} = 0</math>
''''''x'''''' = 0
</nowiki></pre>
|- valign="top"
|
''''''Spacing in simple math formulae:''''''
<br/>
Obviously, ''''x''''² ? 0 is true when ''''x'''' is a real number.
*To space things out without allowing line breaks to interrupt the formula, use non-breaking spaces: <tt> </tt>.
|
<br/>
<pre><nowiki>
Obviously, ''''x''''² ? 0 is true 
when ''''x'''' is a real number.
</nowiki></pre>
|- valign="top"
|
''''''Complicated formulae:''''''
<br/>
: <math>\sum_{n=0}^\infty \frac{x^n}{n!}</math>
* See [[Help:Formula]] for how to use <tt><math></tt>.
* A formula displayed on a line by itself should probably be indented by using the colon (:) character.
|
<br/>
<pre><nowiki>
: <math>\sum_{n=0}^\infty \frac{x^n}{n!}</math>
</nowiki></pre>
|}
''''(see also: [[Chess symbols in Unicode]])''''

===No or limited formatting—showing exactly what is being typed===

A few different kinds of formatting will tell the Wiki to display things as you typed them—what you see, is what you get!

{| border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|''''''<nowiki> tag:''''''<br/>
<nowiki>
The nowiki tag ignores [[Wiki]] ''''markup''''.
It reformats text by removing newlines    and multiple spaces.
It still interprets special characters: ?
</nowiki>
|<pre><nowiki>
<nowiki>
The nowiki tag ignores [[Wiki]] ''''markup''''.
It reformats text by removing newlines 
and multiple spaces.
It still interprets special
characters: ?
</nowiki>
</nowiki></pre>
|-
|''''''<pre> tag:''''''</br>
<pre>
The pre tag ignores [[Wiki]] ''''markup''''.
It also doesn''t     reformat text.
It still interprets special characters: ?
</pre>
|<pre><pre><nowiki>
The pre tag ignores [[Wiki]] ''''markup''''.
It also doesn''t     reformat text.
It still interprets special characters:
 ?
</nowiki></pre></pre>
|-
|''''''Leading space:''''''<br/>
Leading spaces are another way 
to preserve formatting. ''''However, it will make the whole page fail to render properly in some browsers, such as IE7, thus making the page unreadable.''''


 Putting a space at the beginning of each line
 stops the text   from being reformatted. 
 It still interprets [[Wiki]] ''''markup'''' and
 special characters: ?
|<pre><nowiki>
Leading spaces are another way 
to preserve formatting.
 Putting a space at the beginning of each line
 stops the text   from being reformatted. 
 It still interprets [[Wiki]] ''''markup'''' and
 special characters: ?
</nowiki></pre>
|}

===Invisible text (comments)===
{{main|Wikipedia:Manual of Style#Invisible comments}}
It''s uncommon, but on occasion acceptable, to add a hidden comment within the text of an article.  <!-- This is an example of text that won''t normally be visible except in "edit" mode. --> The format is this:
 <nowiki><!-- This is an example of text that won''t normally be visible except in "edit" mode. --></nowiki>

=== Table of contents===
<!-- ==== Placement of the Table of Contents (TOC) ==== -->
At the current status of the wiki markup language, having at least four headers on a page triggers the table of contents (TOC) to appear in front of the first header (or after introductory sections).  Putting <nowiki>__TOC__</nowiki> anywhere forces the TOC to appear at that point (instead of just before the first header).  Putting <nowiki>__NOTOC__</nowiki> anywhere forces the TOC to disappear.  See also [[Wikipedia:Section#Compact_TOC|compact TOC]] for alphabet and year headings.
<!--
THE TEXT BELOW IS COMMENTED OUT SINCE THE DESCRIBED TECHNIQUE 
DOESN''T WORK AFTER UPGRADING TO MEDIAWIKI 1.5

====Keeping headings out of the Table of Contents====
If you want some subheadings to not appear in the Table of Contents, then make the following replacements.

Replace  <nowiki> == Header 2 == with <h2> Header 2 </h2> </nowiki>

Replace  <nowiki> === Header 3 === with <h3> Header 3 </h3> </nowiki>

And so forth.

For example, notice that the following header has the same font as the other subheaders to this "Tables" section, but the following header does not appear in the Table of Contents for this page.

<h4> This header has the h4 font, but is NOT in the Table of Contents (actually, it is)</h4>

This effect is obtained by the following line of code.

<code><nowiki><h4> This header has the h4 font, but is not in the Table of Contents </h4></nowiki></code>

Note that when editing by section, this approach places the text between the tags in the subsequent section, not the previous section. To edit this text, click the edit link next to "Tables", not the one above.
-->

===Tables===
There are two ways to build tables: 
*in special Wiki-markup (see [[Help:Table]])
*with the usual HTML elements: <table>, <tr>, <td> or <th>.

For the latter, and a discussion on when tables are appropriate, see [[Wikipedia:When to use tables]].

===Variables===
''''(See also [[Help:Variable]])''''
{| style="text-align:center"
|-
! Code
! Effect
|-
| <nowiki>{{CURRENTWEEK}}</nowiki> || {{CURRENTWEEK}}
|-
| <nowiki>{{CURRENTDOW}}</nowiki> || {{CURRENTDOW}}
|-
| <nowiki>{{CURRENTMONTH}}</nowiki> || {{CURRENTMONTH}}
|-
| <nowiki>{{CURRENTMONTHNAME}}</nowiki>
| {{CURRENTMONTHNAME}}
|-
| <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>
| {{CURRENTMONTHNAMEGEN}}
|-
| <nowiki>{{CURRENTDAY}}</nowiki> || {{CURRENTDAY}}
|-
| <nowiki>{{CURRENTDAYNAME}}</nowiki> || {{CURRENTDAYNAME}}
|-
| <nowiki>{{CURRENTYEAR}}</nowiki> || {{CURRENTYEAR}}
|-
| <nowiki>{{CURRENTTIME}}</nowiki> || {{CURRENTTIME}}
|-
| <nowiki>{{NUMBEROFARTICLES}}</nowiki>
| {{NUMBEROFARTICLES}}
|-
| <nowiki>{{NUMBEROFUSERS}}</nowiki>
| {{NUMBEROFUSERS}}
|-
| <nowiki>{{PAGENAME}}</nowiki> || {{PAGENAME}}
|-
| <nowiki>{{NAMESPACE}}</nowiki> || {{NAMESPACE}}
|-
| <nowiki>{{REVISIONID}}</nowiki> || {{REVISIONID}}
|-
| <nowiki>{{localurl:pagename}}</nowiki>
| {{localurl:pagename}}
|-
| <nowiki>{{localurl:</nowiki>''''Wikipedia:Sandbox''''<nowiki>|action=edit}}</nowiki>
| {{localurl:Wikipedia:Sandbox|action=edit}}
|-
| <nowiki>{{fullurl:pagename}}</nowiki>
| {{fullurl:pagename}} 
|- 
| <nowiki>{{fullurl:pagename|</nowiki>''''query_string''''<nowiki>}}</nowiki>
| {{fullurl:pagename|query_string}} 
|- 
| <nowiki>{{SERVER}}</nowiki> || {{SERVER}}
|-
| <nowiki>{{ns:1}}</nowiki> || {{ns:1}}
|-
| <nowiki>{{ns:2}}</nowiki> || {{ns:2}}
|-
| <nowiki>{{ns:3}}</nowiki> || {{ns:3}}
|-
| <nowiki>{{ns:4}}</nowiki> || {{ns:4}}
|-
| <nowiki>{{ns:5}}</nowiki> || {{ns:5}}
|-
| <nowiki>{{ns:6}}</nowiki> || {{ns:6}}
|-
| <nowiki>{{ns:7}}</nowiki> || {{ns:7}}
|-
| <nowiki>{{ns:8}}</nowiki> || {{ns:8}}
|-
| <nowiki>{{ns:9}}</nowiki> || {{ns:9}}
|-
| <nowiki>{{ns:10}}</nowiki> || {{ns:10}}
|-
| <nowiki>{{ns:11}}</nowiki> || {{ns:11}}
|-
| <nowiki>{{ns:12}}</nowiki> || {{ns:12}}
|-
| <nowiki>{{ns:13}}</nowiki> || {{ns:13}}
|-
| <nowiki>{{ns:14}}</nowiki> || {{ns:14}}
|-
| <nowiki>{{ns:15}}</nowiki> || {{ns:15}}
|-
| <nowiki>{{SITENAME}}</nowiki> || {{SITENAME}}
|}

''''''NUMBEROFARTICLES'''''' is the number of pages in the main namespace which contain a link and are not a redirect, in other words number of articles, stubs containing a link, and disambiguation pages.

''''''CURRENTMONTHNAMEGEN'''''' is the genitive (possessive) grammatical form of the month name, as used in some languages; ''''''CURRENTMONTHNAME'''''' is the nominative (subject) form, as usually seen in English.

In languages where it makes a difference, you can use constructs like <nowiki>{{grammar:case|word}}</nowiki> to convert a word from the nominative case to some other case.  For example, <nowiki>{{grammar:genitive|{{CURRENTMONTHNAME}}}}</nowiki> means the same as <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>. <!-- Is there a reference for this, other than the source code (for example, phase3/languages/Lnaguage*.php) ? -->


This page is covered by [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]',NULL,'1','2008-02-27 14:54:14',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('59121859-EB3F-023C-703B2FFFF21FBAE3','59104F5A-9555-E540-6BCAA65D9AE6F448','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== List basics ==

CodexWiki offers three types of lists. ''''''Ordered lists'''''', ''''''unordered lists'''''', and ''''''definition lists''''''. In the following sections, ordered lists are used for examples. Unordered lists would give corresponding results.

{|border=1 width="79%"
!wikitext!!rendering
|-
|
 * Lists are easy to do:
 ** start every line
 * with a star
 ** more stars mean
 *** deeper levels
||
* Lists are easy to do:
** start every line
* with a star
** more stars mean 
*** deeper levels
|-
|
 *A newline
 *in a list  
 marks the end of the list.
 Of course
 *you can
 *start again.
|
*A newline
*in a list  
marks the end of the list.
Of course
*you can
*start again.
|-
|
 # Numbered lists are good
 ## very organized
 ## easy to follow
|
# Numbered lists are good
## very organized
## easy to follow
|-
|
 * You can also
 **break lines
 **like this
|
* You can also
**break lines
**like this
|-
|
 ; Definition lists
 ; item : definition
 ; semicolon plus term
 : colon plus definition
|
; Definition lists
; item : definition
; semicolon plus term
: colon plus definition
|-
|
 * Or create mixed lists
 *# and nest them
 *#* like this
 *#*; definitions
 *#*: work:
 *#*; apple
 *#*; banana
 *#*: fruits
|
* Or create mixed lists
*# and nest them
*#* like this
*#*; definitions
*#*: work: 
*#*; apple
*#*; banana
*#*: fruits
|}

== Paragraphs in lists ==

For simplicity, list items in wiki markup cannot be longer than a paragraph. A following blank line will end the list and reset the counter on ordered lists. Separating unordered list items usually has no noticable effects.

Paragraphs can be forced in lists by using HTML tags. Two line break symbols, <code><nowiki><br><br></nowiki></code>, will create the desired effect. So will enclosing all but the first paragraph with <code><nowiki><p>...</p></nowiki></code>

For a list with items of more than one paragraph long, adding a blank line between items may be necessary to avoid confusion.

==Continuing a list item after a sub-item==

In HTML, a list item may contain several sublists, not necessarily adjacent; thus there may be parts of the list item not only before the first sublist, but also between sublists, and after the last one; however, in wiki-syntax, sublists follow the same rules as sections of a page: the only possible part of the list item not in sublists is before the first sublist.

In the case of an unnumbered first-level list in wikitext code this limitation can be overcome by splitting the list into multiple lists; indented text between the partial lists may visually serve as part of a list item after a sublist; however, this may give, depending on CSS, a blank line before and after each list, in which case, for uniformity, every first-level list item could be made a separate list.

Numbered lists illustrate that what should look like one list may, for the software, consist of multiple lists; unnumbered lists give a corresponding result, except that the problem of restarting with 1 is not applicable.

{| style="border:1px;border-spacing:1px;background-color:black;" cellpadding="5"
|- style="background-color:white;"
|
 <nowiki>
<ol>
  <li>list item A1
    <ol>
      <li>list item B1</li>
      <li>list item B2</li>
    </ol>continuing list item A1
  </li>
  <li>list item A2</li>
</ol></nowiki>
| <ol>
  <li>list item A1
    <ol>
      <li>list item B1</li>
      <li>list item B2</li>
    </ol>continuing list item A1
  </li>
  <li>list item A2</li>
</ol>
|- style="background-color:#E0E0E0;font-weight:bold;text-align:center;"
| colspan="2" | vs.
|- style="background-color:white;"
|
 #list item A1
 ##list item B1
 ##list item B2
 #:continuing list item A1
 #list item A2
|
#list item A1
##list item B1
##list item B2
#:continuing list item A1
#list item A2
|}

One level deeper, with a sublist item continuing after a sub-sublist, one gets even more blank lines; however, the continuation of the first-level list is not affected:
<pre>
#list item A1
##list item B1
###list item C1
##:continuing list item B1
##list item B2
#list item A2
</pre>
gives
#list item A1
##list item B1
###list item C1
##:continuing list item B1
##list item B2
#list item A2

See also [[Help:Section#Subdivisions in general|subdivisions]].

== Changing the list type ==

The list type (which type of marker appears before the list item) can be changed in CSS by setting the [http://www.w3.org/TR/REC-CSS2/generate.html#lists list-style-type] property:

{|border=1 width="79%"
!wikitext!!rendering
|-
|
 <nowiki>
<ol style="list-style-type:lower-roman">
  <li>About the author</li>
  <li>Foreword to the first edition</li>
  <li>Foreword to the second edition</li>
</ol></nowiki>
|<ol style="list-style-type:lower-roman">
  <li>About the author</li>
  <li>Foreword to the first edition</li>
  <li>Foreword to the second edition</li>
</ol>
|-
|}

==Extra indentation of lists==
In a numbered list in a large font, some browsers do not show more than two digits, unless extra indentation is applied (if there are multiple columns: for each column). This can be done with CSS:
 ol { margin-left: 2cm}
or alternatively, like below.

{|border=1
!wikitext!!rendering 
! style="width: 40%" | comments
|-
|
 <nowiki>
:#abc
:#def
:#ghi
 </nowiki>
|
:#abc
:#def
:#ghi
| A list of one or more lines starting with a colon creates a [http://www.w3.org/TR/html4/struct/lists.html#edef-DL definition list] without definition terms, and with the items as definition descriptions, hence indented. However, if the colons are in front of the codes "*" or "#" of an unordered or ordered list, the list is treated as one definition description, so the whole list is indented.
|-
|
 <nowiki>
<ul>
  <ol>
    <li>abc</li>
    <li>def</li>
    <li>ghi</li>
  </ol>
</ul>
</nowiki>
|
<ul>
  <ol>
    <li>abc</li>
    <li>def</li>
    <li>ghi</li>
  </ol>
</ul>
| MediaWiki translates an unordered list (ul) without any list items (li) into a div with a <code>style="margin-left: 2em"</code>, causing  indentation of the contents. This is ''''''the most versatile method'''''', as it allows starting with a number other than 1, see below.

|-
|
 <nowiki>
<ul>
#abc
#def
#ghi
</ul>
</nowiki>
|
<ul>
#abc
#def
#ghi
</ul>
|Like above, with the content of the "unordered list without any list items", which itself is an ordered list, expressed with # codes. The HTML produced, and hence the rendering, is the same. This is the ''''''recommended'''''' method when not starting with a number other than 1.

|}

To demonstrate that all three methods show all digits of 3-digit numbers, see [[m:Help:List demo|List demo]].

==Specifying a starting value==
Specifying a starting value is only possible with HTML syntax.
(W3C has deprecated the <code>start</code> and <code>value</code> attributes as used below in HTML 4.01 and XHTML 1.0. But as of 2007, no popular web browsers implement CSS counters, which were to replace these attributes. Wikimedia projects use XHTML Transitional, which contains the deprecated attributes.)

<pre>
<ol start="9">
<li>Amsterdam</li>
<li>Rotterdam</li>
<li>The Hague</li>
</ol>
</pre>
gives
<ol start="9">
<li>Amsterdam</li>
<li>Rotterdam</li>
<li>The Hague</li>
</ol>

Or:
<pre>
<ol>
<li value="9">Amsterdam</li>
<li value="8">Rotterdam</li>
<li value="7">The Hague</li>
</ol>
</pre>
gives
<ol>
<li value="9">Amsterdam</li>
<li value="8">Rotterdam</li>
<li value="7">The Hague</li>
</ol>

==Comparison with a table==
Apart from providing automatic numbering, the numbered list also aligns the contents of the items, comparable with using table syntax:
<pre>
{|
|-
| align=right |  9.||Amsterdam
|-
| align=right | 10.||Rotterdam
|-
| align=right | 11.||The Hague
|}
</pre>
gives
{|
|-
| align=right |  9.||Amsterdam
|-
| align=right | 10.||Rotterdam
|-
| align=right | 11.||The Hague
|}

This non-automatic numbering has the advantage that if a text refers to the numbers, insertion or deletion of an item does not disturb the correspondence.

==Multi-column bulleted list==
<pre>
{| 
| 
*1
*2 
| 
*3
*4
|}
</pre>
gives:
{| 
| 
*1
*2 
| 
*3
*4
|}

==Multi-column numbered list==
Specifying a starting value is useful for a numbered list with multiple columns, to avoid restarting from one in each column. As mentioned above, this is only possible with HTML-syntax (for the first column either wiki-syntax or HTML-syntax can be used).

In combination with the extra indentation explained in the previous section:
<pre>
{| valign="top"
|-
|<ul><ol start="125"><li>a<li>bb<li>ccc</ol></ul>
|<ul><ol start="128"><li>ddd<li>ee<li>f</ol></ul>
|}
</pre>

gives

{| valign="top"
|-
|<ul><ol start="125"><li>a<li>bb<li>ccc</ol></ul>
|<ul><ol start="128"><li>ddd<li>ee<li>f</ol></ul>
|}

Using {{tim|multi-column numbered list}} the computation of the starting values can be automated, and only the first starting value and the number of items in each column except the last has to be specified. Adding an item to, or removing an item from a column requires adjusting only one number, the number of items in that column, instead of changing the starting numbers for all subsequent columns.

<pre>{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}</pre>

gives

{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}

<pre>{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}

<pre>{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}

<pre>{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}</pre>

gives

{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}

==Streamlined style or horizontal style==
It is also possible to present short lists using very basic formatting, such as:

 <nowiki>''''Title of list:''''</nowiki> example 1, example 2, example 3

''''Title of list:'''' example 1, example 2, example 3

This style requires less space on the page, and is preferred if there are only a few entries in the list, it can be read easily, and a direct edit point is not required. The list items should start with a lowercase letter unless they are proper nouns.

==Tables==
A one-column table is very similar to a list, but it allows sorting. If the wikitext itself is already sorted with the same sortkey, this advantage does not apply.
A multiple-column table allows sorting on any column.

See also [[en:Wikipedia:When to use tables]].

==Changing unordered lists to ordered ones==
With the CSS
 ul { list-style: decimal }
unordered lists are changed to ordered ones. This applies (as far as the CSS selector does not restrict this) to all ul-lists in the HTML source code:
*those produced with *
*those with <nowiki><ul></nowiki> in the wikitext
*those produced by the system

Since each special page, like other pages, has a class based on the pagename, one can separately specify for each type whether the lists should be ordered, see [[Help:User contributions#User styles]] and [[Help:What links here#User styles]].

However, it does not seem possible to make all page history lists ordered (unless one makes ''''all'''' lists ordered), because the class name is based on the page for which the history is viewed. 




This page is covered under [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]',NULL,'1','2008-02-27 15:06:40',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('A873628C-0187-145E-574309C8195CA646','A8736248-DCE2-A123-A6DA083754C59203','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','<div align="center">
<!--COMMENT MARKUP. Displays:Edit mode only.-->
{|align="center" style="width:100%; border:2px #a3b1bf solid; background:#f5faff; text-align:left;"
|colspan="3" align="center" style="background:#cee0f2; text-align:center;" |
<h2 style="margin:.5em; margin-top:.1em; margin-bottom:.1em; border-bottom:0; font-weight:bold;">Wikipedia Cheatsheet</h2>
|-<!--COLUMN HEADINGS-->
| width="25%" style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''Description''''''
| style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''You type'''''' 
| width="25%" style="background:#cee0f2; padding:0.3em; text-align:center;"|''''''You get''''''
|-<!--1ST ROW 1ST COLUMN-->
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Italic text]]
|<!--2ND COLUMN-->
<tt><nowiki>''''italic''''</nowiki></tt>
|<!--3RD COLUMN-->
''''italic''''
|-<!--HORIZONTAL LINE-->
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-<!--2ND ROW 1ST COLUMN-->
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Bold text]]
|
<tt><nowiki>''''''bold''''''</nowiki></tt>
|
''''''bold''''''
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Character_formatting|Bold and italic]]
|
<tt><nowiki>''''''''''bold & italic''''''''''</nowiki></tt>
|
''''''''''bold & italic''''''''''
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
||[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Internal link]]<br />
<div style="padding: 0em .5em; font-size:0.9em;">''''(within Wikipedia)''''</div>
|
<tt><nowiki>[[Name of page]]</nowiki></tt><br />
<tt><nowiki>[[Name of page|Text to display]]</nowiki></tt>
|
[[Name of page]]<br />
[[Name of page|Text to display]]
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|External link]]<br />
<div style="padding: 0em .5em; font-size:0.9em;">''''(to other websites)''''</div>
|
<tt><nowiki>[http://www.example.org Text to display]</nowiki></tt><br />
<tt><nowiki>[http://www.example.org]</nowiki></tt><br />
<tt><nowiki>http://www.example.org</nowiki></tt>
|
[http://www.example.org Text to display]<br />
[http://www.example.org]<br />
http://www.example.org
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Redirect to another page]]
|
<tt><nowiki>#REDIRECT [[Target page]]</nowiki></tt>
|
[[Image:Redirect arrow without text.svg|30px]][[Target page]]
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|rowspan="3"|[[Wikipedia:How_to_edit_a_page#Links_and_URLs|Footnotes/References]]
<div style="padding: 0em .5em; font-size:0.9em;">''''Numbering is generated automatically.''''</div>
|<div style="margin-left:2em; font-size:0.9em;">''''To create a footnote or reference, use this format:''''</div>
<tt><nowiki>Article text.<ref name="test">[http://www.example.org Link text], additional text.</ref></nowiki></tt>
|rowspan="2"|Article text.<ref name="test">[http://www.example.org Link text], additional text.</ref>
|-
|<div style="margin-left:2em; font-size:0.9em;">''''To reuse the same note, reuse the name with a trailing slash:''''</div>
<tt><nowiki>Article text.<ref name="test" /></nowiki></tt>
|-
|<div style="margin-left:2em; font-size:0.9em;">''''To display notes, add ''''''either'''''' of these lines to the References section''''</div>
<tt><nowiki><references/></nowiki></tt><br/>
<tt>{{tl|Reflist}}</tt>
|<br/><references /><br/>
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:How_to_edit_a_page#Headings|Section headings]]<ref name="firstline">''''Applies only at the very beginning of lines.''''</ref><br />
<div style="padding: 0em .5em; font-size:0.9em;">''''A Table of Contents will automatically be generated when four headings are added to an article.''''</div>
|
<tt><nowiki>== Level 1 ==</nowiki></tt><br />
<tt><nowiki>=== Level 2 ===</nowiki></tt><br />
<tt><nowiki>==== Level 3 ====</nowiki></tt><br />
<tt><nowiki>===== Level 4 =====</nowiki></tt><br />
<tt><nowiki>====== Level 5 ======</nowiki></tt>
|
== Level 1 ==
=== Level 2 ===
==== Level 3 ====
===== Level 4 =====
====== Level 5 ======
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Help:List|Bulleted list]]<ref name="firstline" />
<div style="padding: 0em .5em; font-size:0.9em;">''''Empty lines between list items discouraged, (see numbered lists).''''</div>
|
<tt>* One</tt><br />
<tt>* Two</tt><br />
<tt>** Two point one</tt><br />
<tt>* Three</tt>
|
* One
* Two
** Two point one
* Three
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Help:List|Numbered list]]<ref name="firstline" />
<div style="padding: 0em .5em; font-size:0.9em;">''''Empty lines between list items restarts numbering at 1.''''</div>
|
<tt># One</tt><br />
<tt># Two</tt><br />
<tt>## Two point one</tt><br />
<tt># Three</tt><br />
|
# One
# Two
## Two point one
# Three
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|[[Wikipedia:Extended_image_syntax|Thumbnail image]]
|
<tt><nowiki>[[Image:Wiki.png|thumb|Caption text]]</nowiki></tt>
|
[[Image:Wiki.png|thumb|Caption text]]
|-

|-<!--TALKPAGES-->
| colspan="3" style="background:#E6F2FF; padding: 0.2em; font-family: sans-serif; font-size: 0.9em; text-align:center;" | For [[Wikipedia:Tutorial_%28Talk_pages%29|Talk Pages]]
|-
|Signature
|
<tt><nowiki>~~~~</nowiki></tt>
|
[[Special:Mypage|Your username]] {{CURRENTTIME}}, <br />
{{CURRENTDAY}} {{CURRENTMONTHNAME}} {{CURRENTYEAR}} (UTC) 
|-
|colspan="3" style="border-top:1px solid #cee0f2;"|
|-
|Indenting Text<ref name="firstline" />
|
<tt><nowiki>no indent (normal)</nowiki></tt><br/>
<tt><nowiki>:first indent</nowiki></tt><br/>
<tt><nowiki>::second indent</nowiki></tt><br/>
<tt><nowiki>:::third indent</nowiki></tt>
|
no indent (normal)<br/>
:first indent
::second indent
:::third indent
|-

|colspan="3" style="border-top:1px solid #cee0f2; font-size:0.9em;"|<references/>
|}
</div>','First Import','1','2008-11-16 19:16:53',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('A89594E7-970D-BE3D-C32A3395AD685354','A895949D-B7C5-34B5-0E32B0CE52BC3FA0','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Messagebox Markup ==
The <nowiki><messagebox></nowiki> tag is available to integrate the [http://www.coldboxframework.com ColdBox] Messagebox Plugin into your wiki pages.

The following attributes are available to be used with the <nowiki><messagebox></nowiki> tag
<br /><br />
{|border=1 width="80%" cellpadding="5" cellspacing="0"
!Attribute!!Required!!Values!!Description
|-
||
''''''type''''''
||
No
||
info,warning,error
||
The type of messagebox to generate: info, warning or error.

Example:
<code><pre><messagebox type="error">My Message</messagebox></pre></code>
','First Import','1','2008-11-16 19:54:14',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('B5C20C69-CF1E-5C1B-97430D6BDABBF4B6','E12403BB-F4C1-5F8A-1B20DB3894BAF144','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','{|align="right"
|-
| __TOC__
|}

= Welcome To Codex =
This is your Wiki landing page.  You can customize this page at anytime by clicking on the ''''''Edit'''''' button below.

== Navigation ==
To your left you can see the wiki sidebar.  From here you can comeback to this page, go to our help section, view the wiki''s rss feeds, get a wiki category listing and even see the entire wiki page directory.  Come on, try it out!!

== Search ==
The top header bar includes our incredible search engine, search for anything in a wiki page or title.  Try it out!

== Top Navigation ==
If you have the correct permissions or are a registered user, you can view your user profile and manage this wiki.  Just click on the ''''''Admin'''''' tab to start managing Codex.

{{{Messagebox message="Hello Everybody" type="info"}}}

== Wiki Plugins ==
You can use wiki plugins very easily by just using their names inside ''''''{{{ }}}}'''''' and adding arguments as name-value pairs.  This will in turn call the plugin''s ''''''renderIt()'''''' method with the arguments provided.  If you want to check it out, just view the source for this page.

{{{WikiPlugins}}}','Updates','1','2008-11-19 09:17:48',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('B5C2D76A-CF1E-5C1B-958C7823539C1C0D','58F2F999-FC99-125A-DB21FCD7085C44A1','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Help Contents ==

Welcome to the Codex Wiki.  Here you will find the documentation to edit and create pages on this wiki.

=== Editing ===

* [[Help:Wiki Markup|Wiki Markup]] - The most common wiki markups.
* [[Help:List Markup|Lists Markup]] - Creating and using lists.
* [[Help:Cheatsheet|Wiki Markup Cheatsheet]] - Wiki Markup Cheatsheet
* [[Help:Feed Markup|Feed Markup]] - Using feed tags.
* [[Help:Messagebox Markup|Messagebox Markup]] - Using messagebox tags.
* [[Help:Codex Wiki Plugins|Codex Wiki Plugins]] - How to create your own wiki plugins and extend the wiki parser.

=== More Information ===

More information can be found via the Wikipedia site [http://en.wikipedia.org/wiki/Help:Contents Wikipedia Help] as this wiki follows many of its markup guidelines.','parser','1','2008-11-19 09:18:44',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('B5C4FA6B-CF1E-5C1B-9830AE891E48FCD2','B5C4FA1D-CF1E-5C1B-950B4A04E276B736','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','{|align="right"
|-
| __TOC__
|}

= Codex Wiki Plugins =

== Introduction ==
Codex comes bundled with a set of custom wiki plugins that can be used in any wiki page by following the following syntax:

<source lang="xml">
{{{PluginName arg1="" arg2="" ...}}}
</source>

Basically, you create a tag with the name of the plugin to use and then just create arguments of name-value pairs of whatever arguments the plugin''s ''''''renderit()'''''' method takes in.

== A Wiki Plugin ==
Creating wiki plugins are very easy. Just drop them in the ''''''/App/plugins/wiki'''''' folder and you are ready to start using them in your wiki pages.

A wiki plugin is exactly just like any other ColdBox plugin. [http://ortus.svnrepository.com/coldbox/trac.cgi/wiki/cbPluginsGuide ColdBox Plugin Guide].

=== Rules ===

# Plugin component must extend ''''coldbox.system.plugin'''' and implement the coldbox plugin init() method.
# Plugin can just implement the ColdBox init() method with no inheritance, but will not be able to tap into the framework''s supertype''s methods.  It will have to do everything via the injected controller.
# Plugin must implement a method called ''''''renderit()''''''.
## This method can have 1 or more arguments.

== Example ==

So if we have a plugin called ''''''DateTime'''''', it''s source code can look like this:

<source lang="coldfusion">
<cfcomponent name="DateTime" 
			 hint="A datetime wiki plugin" 
			 extends="coldbox.system.plugin" 
			 output="false" 
			 cache="true">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="DateTime" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		setpluginName("DateTime");
  		setpluginVersion("1.0");
  		setpluginDescription("A date time wiki plugin");
  		//My own Constructor code here
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	

    <!--- today --->
	<cffunction name="renderit" output="false" access="public" returntype="string" hint="print today">
		<cfargument name="format" type="string" required="true" default="full" hint="Full,Short, Medium"/>
		<cfreturn dateformat(now(),arguments.format)>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->	
	
</cfcomponent>
</source>

And we can use it in our wiki pages like so:

<source lang="xml">
//Initial space is left so wiki doesn''t match and you can see the source
{{{ Messagebox message="Hello World!"}}}
</source>

That''s it. Welcome to the world of Codex Wiki Plugins.  Now go out and start coding your very own plugins. Below you can see a plugin at work:

{{{WikiPlugins}}}','First Import','1','2008-11-19 09:21:03',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('C90869BF-F321-E64A-26D668F8EE8988B5','C90869A2-090D-50DA-0800C94BB5DB7026','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Feed Markup ==
The <nowiki><feed></nowiki> tag is available to integrate RSS and ATOM feeds to provide dynamic information into your wiki pages.

The following attributes are available to be used with the <nowiki><feed></nowiki> tag
{|border=1 width="80%" cellpadding="5" cellspacing="0"
!Attribute!!Required!!Values!!Description
|-
||
''''''url''''''
||
Yes
||
A URL
||
Either a absolute, or root relative link to the RSS or ATOM feed.
A root relative link points directly back to the codeX wiki RSS feeds.

Example of an absolute link:
<code><pre><feed url="http://www.compoundtheory.com/?action=feed.rss" /></pre></code>

Example of a relative link:
<code><pre><feed url="/feed/directory/list.cfm" /></pre></code>
|-
||
''''''display''''''
||
No
||
bullet, numbered
||
RSS Feed data can either be displayed as regular bullet points, or by numbered bullet points.

Example of display by bullet points:
<code><pre><feed url="/feed/directory/list.cfm" display="bullet" /></pre></code>

Example of display by numbered bullet points:
<code><pre><feed url="/feed/directory/list.cfm" display="numbered" /></pre></code>

By default it is displayed by ''bullet''
|-
||
''''''cache''''''
||
No
||
number of minutes
||
The number of minutes in which the results of this RSS feed are cached.

Example of a RSS feed cached for 5 minutes
<code><pre><feed url="/feed/directory/list.cfm" cahe="5" /></pre></code>

By default, the default cache time out of the installed ColdBox.
|-
|}','Initial creation','1','2008-03-20 08:53:34',1,0);
INSERT INTO "wiki_pagecontent" ("pagecontent_id", "FKpage_id", "FKuser_id", "pagecontent_content", "pagecontent_comment", "pagecontent_version", "pagecontent_createdate", "pagecontent_isActive", "pagecontent_isReadOnly") VALUES
	('E5CC1AC5-C484-565C-19E5F34B3712AD02','E5CC1A90-D36E-9214-33EB0021D817DE59','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Category Listing ==

<feed url="/feed/category/list.cfm" display="numbered" />','Initial Creation','1','2008-05-14 14:59:28',1,0);
/*!40000 ALTER TABLE "wiki_pagecontent" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_pagecontent_category'
#

CREATE TABLE "wiki_pagecontent_category" (
  "FKpagecontent_id" varchar(36) NOT NULL,
  "FKcategory_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpagecontent_id","FKcategory_id"),
  KEY "FKcategory_id" ("FKcategory_id"),
  KEY "FKpagecontent_id" ("FKpagecontent_id"),
  KEY "FKcategory_id_2" ("FKcategory_id"),
  KEY "FKpagecontent_id_2" ("FKpagecontent_id"),
  CONSTRAINT "FKcategory_id" FOREIGN KEY ("FKcategory_id") REFERENCES "wiki_category" ("category_id"),
  CONSTRAINT "FKpagecontent_id" FOREIGN KEY ("FKpagecontent_id") REFERENCES "wiki_pagecontent" ("pagecontent_id")
);



#
# Dumping data for table 'wiki_pagecontent_category'
#

# No data found.



#
# Table structure for table 'wiki_permissions'
#

CREATE TABLE "wiki_permissions" (
  "permission_id" varchar(36) NOT NULL,
  "permission" varchar(100) NOT NULL,
  "description" varchar(255) NOT NULL,
  PRIMARY KEY  ("permission_id"),
  UNIQUE KEY "permission" ("permission")
);



#
# Dumping data for table 'wiki_permissions'
#

LOCK TABLES "wiki_permissions" WRITE;
/*!40000 ALTER TABLE "wiki_permissions" DISABLE KEYS;*/
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','WIKI_VIEW','Ability to view any wiki page');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('8840B7C9-E693-D54B-6A69F07AA5265839','WIKI_CREATE','Ability to create wiki pages');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('8840D553-F9D9-59F9-90B05EF765403F90','WIKI_EDIT','Ability to edit wiki pages');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('8840FF13-0A96-AAA9-63322F27E6713489','WIKI_DELETE_PAGE','Ability to remove pages');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('884120D4-F9D7-22CB-46341F8BCF1B68A5','WIKI_DELETE_VERSION','Ability to remove page versions');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('88415476-D0F8-32A5-7E7D3340828C0E6B','WIKI_ROLLBACK_VERSION','Ability to rollback to previous versions');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('88417F6E-CA8B-53C9-59DEF4C4888CDE82','WIKI_VIEW_HISTORY','Ability to view a page''s history');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('A9D04702-CF1E-5C1B-94C2965619E301C8','WIKI_ADMIN','Access to all the administrator panels');
INSERT INTO "wiki_permissions" ("permission_id", "permission", "description") VALUES
	('A9D3BA34-CF1E-5C1B-961D24FF9A32538B','WIKI_REGISTRATION','Ability for anonymous users to register');
/*!40000 ALTER TABLE "wiki_permissions" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_role_permissions'
#

CREATE TABLE "wiki_role_permissions" (
  "FKpermission_id" varchar(36) NOT NULL,
  "FKrole_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpermission_id","FKrole_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKrole_id" ("FKrole_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKrole_id_2" ("FKrole_id"),
  CONSTRAINT "FKrole_id" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id"),
  CONSTRAINT "FK_permissionid" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id")
);



#
# Dumping data for table 'wiki_role_permissions'
#

LOCK TABLES "wiki_role_permissions" WRITE;
/*!40000 ALTER TABLE "wiki_role_permissions" DISABLE KEYS;*/
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840B7C9-E693-D54B-6A69F07AA5265839','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840B7C9-E693-D54B-6A69F07AA5265839','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840D553-F9D9-59F9-90B05EF765403F90','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840D553-F9D9-59F9-90B05EF765403F90','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840FF13-0A96-AAA9-63322F27E6713489','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('8840FF13-0A96-AAA9-63322F27E6713489','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('884120D4-F9D7-22CB-46341F8BCF1B68A5','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('884120D4-F9D7-22CB-46341F8BCF1B68A5','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88415476-D0F8-32A5-7E7D3340828C0E6B','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88417F6E-CA8B-53C9-59DEF4C4888CDE82','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88417F6E-CA8B-53C9-59DEF4C4888CDE82','883C6A58-05CA-D886-22F7940C19F792BD');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('88417F6E-CA8B-53C9-59DEF4C4888CDE82','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('A9D04702-CF1E-5C1B-94C2965619E301C8','883C4730-ACC9-1AF4-93737DB4E2E368EF');
INSERT INTO "wiki_role_permissions" ("FKpermission_id", "FKrole_id") VALUES
	('A9D3BA34-CF1E-5C1B-961D24FF9A32538B','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4');
/*!40000 ALTER TABLE "wiki_role_permissions" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_roles'
#

CREATE TABLE "wiki_roles" (
  "role_id" varchar(36) NOT NULL,
  "role" varchar(100) NOT NULL,
  "description" varchar(255) NOT NULL,
  PRIMARY KEY  ("role_id")
);



#
# Dumping data for table 'wiki_roles'
#

LOCK TABLES "wiki_roles" WRITE;
/*!40000 ALTER TABLE "wiki_roles" DISABLE KEYS;*/
INSERT INTO "wiki_roles" ("role_id", "role", "description") VALUES
	('883C4730-ACC9-1AF4-93737DB4E2E368EF','ADMIN','The wiki administrator');
INSERT INTO "wiki_roles" ("role_id", "role", "description") VALUES
	('883C6A58-05CA-D886-22F7940C19F792BD','USER','A basic wiki user');
INSERT INTO "wiki_roles" ("role_id", "role", "description") VALUES
	('883C8533-DC73-C1F0-521E41EC19FD6E78','MODERATOR','A wiki moderator or editor');
INSERT INTO "wiki_roles" ("role_id", "role", "description") VALUES
	('A9D370CD-CF1E-5C1B-9B9B75680AB49DE4','ANONYMOUS','Anonymous access role');
/*!40000 ALTER TABLE "wiki_roles" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_securityrules'
#

CREATE TABLE "wiki_securityrules" (
  "securityrule_id" varchar(36) NOT NULL,
  "whitelist" varchar(255) default NULL,
  "securelist" varchar(255) default NULL,
  "permissions" varchar(255) default NULL,
  "authorize_check" tinyint(4) NOT NULL default '0',
  "redirect" varchar(255) default NULL,
  PRIMARY KEY  ("securityrule_id"),
  UNIQUE KEY "securityrule_id" ("securityrule_id")
);



#
# Dumping data for table 'wiki_securityrules'
#

LOCK TABLES "wiki_securityrules" WRITE;
/*!40000 ALTER TABLE "wiki_securityrules" DISABLE KEYS;*/
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('88572359-B40D-B373-DE9E3DA49F37ABE5',NULL,'^admin','WIKI_ADMIN',1,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C3CA560A-CF1E-5C1B-954981333B6ECA46',NULL,'^profile',NULL,1,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C42598A5-CF1E-5C1B-98C39B0B163E7A98',NULL,'^page\.show$,^page\.search,^page\.render','WIKI_VIEW',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C426C55E-CF1E-5C1B-9B4DE753A5DEA781',NULL,'^page\.showHistory','WIKI_VIEW_HISTORY',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C42C5C1D-CF1E-5C1B-9776D52AF996EA7E',NULL,'^page\.deleteContent','WIKI_DELETE_VERSION',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C42D5746-CF1E-5C1B-9D676C9985BA89CC',NULL,'^page\.delete$','WIKI_DELETE_PAGE',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C42DE4B2-CF1E-5C1B-9780791CABD241E8',NULL,'^page\.replace','WIKI_ROLLBACK_VERSION',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('C4317156-CF1E-5C1B-917C1C422FF1B6D7',NULL,'^page\.(create|doCreate)$','WIKI_CREATE',0,'user/login.cfm');
INSERT INTO "wiki_securityrules" ("securityrule_id", "whitelist", "securelist", "permissions", "authorize_check", "redirect") VALUES
	('CE69AF93-CF1E-5C1B-9E984A4FE2CECE6F',NULL,'^page\.(edit|doEdit)$','WIKI_EDIT',0,'user/login.cfm');
/*!40000 ALTER TABLE "wiki_securityrules" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_users'
#

CREATE TABLE "wiki_users" (
  "user_id" varchar(36) NOT NULL,
  "user_fname" varchar(100) NOT NULL,
  "user_lname" varchar(100) NOT NULL,
  "user_email" varchar(255) NOT NULL,
  "user_isActive" tinyint(4) NOT NULL default '1',
  "user_isConfirmed" tinyint(4) NOT NULL default '0',
  "user_create_date" timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  "user_modify_date" datetime default NULL,
  "user_isDefault" tinyint(4) NOT NULL default '0',
  "user_username" varchar(50) NOT NULL,
  "user_password" varchar(255) NOT NULL,
  "FKrole_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("user_id"),
  UNIQUE KEY "newindex" ("user_username"),
  KEY "FKrole_id" ("FKrole_id"),
  KEY "idx_credentials" ("user_isActive","user_isConfirmed","user_username","user_password"),
  KEY "idx_byEmail" ("user_isActive","user_isConfirmed","user_email"),
  KEY "idx_default" ("user_isDefault"),
  CONSTRAINT "FK_wiki_users_wiki_roles" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id")
);



#
# Dumping data for table 'wiki_users'
#

LOCK TABLES "wiki_users" WRITE;
/*!40000 ALTER TABLE "wiki_users" DISABLE KEYS;*/
INSERT INTO "wiki_users" ("user_id", "user_fname", "user_lname", "user_email", "user_isActive", "user_isConfirmed", "user_create_date", "user_modify_date", "user_isDefault", "user_username", "user_password", "FKrole_id") VALUES
	('A9CF56CA-CF1E-5C1B-91F2AEF8FBD03AA4','ANONYMOUS','ANONYMOUS','ANONYMOUS@CODEXWIKI.COM',1,1,'2008-03-18 15:12:22','0100-01-01 00:00:00',1,'ANONYMOUS','A2AD7D448321F4D974D468E0B251030E5BED9F128BC760FA3DBA299756E9B31A4D6F8504EA4F10DC2665834E5FFA93CB978FD2FD075C53322C58CD6FE7A7A878','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4');
INSERT INTO "wiki_users" ("user_id", "user_fname", "user_lname", "user_email", "user_isActive", "user_isConfirmed", "user_create_date", "user_modify_date", "user_isDefault", "user_username", "user_password", "FKrole_id") VALUES
	('A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','admin','admin','admin@codexwiki.com',1,1,'2008-06-18 08:25:35','2008-05-22 23:57:52',0,'admin','0CD487D652F3139D5E01E3263B3B37995602EB8692D11BB37E4DBE33F40581852C63A9964EBC233E10BEB192B2851AA613E640E5137132CA8C061D3327388E5F','883C4730-ACC9-1AF4-93737DB4E2E368EF');
/*!40000 ALTER TABLE "wiki_users" ENABLE KEYS;*/
UNLOCK TABLES;


#
# Table structure for table 'wiki_users_permissions'
#

CREATE TABLE "wiki_users_permissions" (
  "FKuser_id" varchar(36) NOT NULL,
  "FKpermission_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKuser_id","FKpermission_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKuser_id" ("FKuser_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKuser_id_2" ("FKuser_id"),
  CONSTRAINT "FKpermission_id" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id"),
  CONSTRAINT "FKusers_id" FOREIGN KEY ("FKuser_id") REFERENCES "wiki_users" ("user_id")
);



#
# Dumping data for table 'wiki_users_permissions'
#

# No data found.

/*!40101 SET SQL_MODE=@OLD_SQL_MODE;*/
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;*/
