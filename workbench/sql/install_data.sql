-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.45


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,ANSI_QUOTES' */;


--
-- Create schema codex
--

CREATE DATABASE IF NOT EXISTS codex;
USE codex;

--
-- Definition of table "codex"."wiki_category"
--

DROP TABLE IF EXISTS "codex"."wiki_category";
CREATE TABLE  "codex"."wiki_category" (
  "category_id" varchar(36) NOT NULL,
  "category_name" varchar(255) NOT NULL,
  "category_createddate" datetime default NULL,
  PRIMARY KEY  ("category_id"),
  UNIQUE KEY "category_name" ("category_name"),
  KEY "idx_wiki_category_name" ("category_name")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_category"
--

/*!40000 ALTER TABLE "wiki_category" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_category" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_namespace"
--

DROP TABLE IF EXISTS "codex"."wiki_namespace";
CREATE TABLE  "codex"."wiki_namespace" (
  "namespace_id" varchar(36) NOT NULL,
  "namespace_name" varchar(255) NOT NULL,
  "namespace_description" varchar(255) NOT NULL,
  "namespace_isdefault" tinyint(4) NOT NULL default '0',
  PRIMARY KEY  ("namespace_id"),
  UNIQUE KEY "namespace_name" ("namespace_name"),
  KEY "idx_wiki_namespace_name" ("namespace_name")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_namespace"
--

/*!40000 ALTER TABLE "wiki_namespace" DISABLE KEYS */;
INSERT INTO "codex"."wiki_namespace" VALUES  ('06AF3D1C-0B00-EAA3-09A138DFA27F7E28','Special','Special',0),
 ('58F2F981-F62A-3124-E886BBF8CE6C5295','Help','Help',0),
 ('F1C0292E-CB06-FD09-41D904E8550FE734','','Default Namespace',1);
/*!40000 ALTER TABLE "wiki_namespace" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_page"
--

DROP TABLE IF EXISTS "codex"."wiki_page";
CREATE TABLE  "codex"."wiki_page" (
  "page_id" varchar(36) NOT NULL,
  "page_name" varchar(255) NOT NULL,
  "FKnamespace_id" varchar(36) default NULL,
  PRIMARY KEY  ("page_id"),
  UNIQUE KEY "page_name" ("page_name"),
  KEY "FKnamespace_id" ("FKnamespace_id"),
  KEY "FKnamespace_id_2" ("FKnamespace_id"),
  KEY "idx_wiki_page_name" ("page_name"),
  CONSTRAINT "FKnamespace_id" FOREIGN KEY ("FKnamespace_id") REFERENCES "wiki_namespace" ("namespace_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_page"
--

/*!40000 ALTER TABLE "wiki_page" DISABLE KEYS */;
INSERT INTO "codex"."wiki_page" VALUES  ('06AF3D6A-0AB3-43E6-EF2D1118F58A1562','Special:Feeds','06AF3D1C-0B00-EAA3-09A138DFA27F7E28'),
 ('58F2F999-FC99-125A-DB21FCD7085C44A1','Help:Contents','58F2F981-F62A-3124-E886BBF8CE6C5295'),
 ('59014C5F-C1C6-7E91-A38446214A380C7D','Help:Wiki_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295'),
 ('59104F5A-9555-E540-6BCAA65D9AE6F448','Help:List_Markup','58F2F981-F62A-3124-E886BBF8CE6C5295');
/*!40000 ALTER TABLE "wiki_page" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_pagecontent"
--

DROP TABLE IF EXISTS "codex"."wiki_pagecontent";
CREATE TABLE  "codex"."wiki_pagecontent" (
  "pagecontent_id" varchar(36) NOT NULL,
  "FKpage_id" varchar(36) NOT NULL,
  "FKuser_id" varchar(36) NOT NULL,
  "pagecontent_content" text,
  "pagecontent_comment" text,
  "pagecontent_version" bigint(20) NOT NULL default '1',
  "pagecontent_createdate" datetime NOT NULL,
  "pagecontent_isActive" tinyint(4) NOT NULL default '1',
  PRIMARY KEY  ("pagecontent_id"),
  KEY "FKpage_id" ("FKpage_id"),
  KEY "FKuser_id" ("FKuser_id"),
  KEY "idx_wiki_pagecontent_isActive" ("pagecontent_isActive"),
  CONSTRAINT "FK_wiki_pagecontent_wiki_page" FOREIGN KEY ("FKpage_id") REFERENCES "wiki_page" ("page_id"),
  CONSTRAINT "FK_wiki_pagecontent_wiki_users" FOREIGN KEY ("FKuser_id") REFERENCES "wiki_users" ("user_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_pagecontent"
--

/*!40000 ALTER TABLE "wiki_pagecontent" DISABLE KEYS */;
INSERT INTO "codex"."wiki_pagecontent" VALUES  ('06AF3D9F-F000-34AC-65CBF528D2F4F658','06AF3D6A-0AB3-43E6-EF2D1118F58A1562','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Codex RSS Feed Directory ==\r\n<feed url=\"/feed/directory/list.cfm\" />',NULL,1,'2008-02-11 15:09:50',1),
 ('58F8AE6A-A46D-F800-7328BC8A357174C5','58F2F999-FC99-125A-DB21FCD7085C44A1','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Help Contents ==\r\n\r\nWelcome to the Codex Wiki.  Here you will find the documentation to edit and create pages on this wiki.\r\n\r\n=== Editing ===\r\n\r\n* [[Help:Wiki Markup|Wiki Markup]] - The most common wiki markups.\r\n* [[Help:List Markup|Lists Markup]] - Creating and using lists.\r\n* [[Help:Feed Markup|Feed Markup]] - Using feed tags.\r\n\r\n=== More Information ===\r\n\r\nMore information can be found via the Wikipedia site [http://en.wikipedia.org/wiki/Help:Contents Wikipedia Help] as this wiki follows many of its markup guidelines.',NULL,1,'2008-02-27 14:38:55',1),
 ('5906B62D-FBD0-6F75-B6B7BF36DCD904C5','59014C5F-C1C6-7E91-A38446214A380C7D','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','==Wiki markup==\r\n\r\nThe \'\'\'wiki markup\'\'\' is the syntax system you can use to format a Wikipedia page; please see [[Help:Editing]] for details on it, and [[Help:Wikitext examples]] for a longer list of the possibilities of Wikitext.\r\n\r\n===Links and URLs===\r\n{| border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\r\n|- valign=\"top\"\r\n! What it looks like\r\n! What you type\r\n|- id=\"emph\" valign=\"top\"\r\n|\r\nLondon has [[public transport]].\r\n\r\n* A link to another Wiki article.\r\n* Internally, the first letter of the target page is automatically capitalized and spaces are represented as underscores (typing an underscore in the link has the same effect as typing a space, but is not recommended).\r\n* Thus the link above is to the [[URL]] en.wikipedia.org/wiki/Public_transport, which is the Wikipedia article with the name \"Public transport\". See also [[Wikipedia:Canonicalization]].\r\n|\r\n<pre><nowiki>\r\nLondon has [[public transport]].\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nSan Francisco also has [[public transport|\r\npublic transportation]].\r\n\r\n* Same target, different name.\r\n* The target (\"piped\") text must be placed \'\'\'first\'\'\', then the text that will be displayed second.\r\n|\r\n<pre><nowiki>\r\nSan Francisco also has\r\n[[public transport| public transportation]].\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nSan Francisco also has\r\n[[public transport]]ation.\r\n\r\nExamples include [[bus]]es, [[taxicab]]s,\r\nand [[streetcar]]s.\r\n\r\n* Endings are blended into the link.\r\n* Preferred style is to use this instead of a piped link, if possible.\r\n* Blending can be suppressed by using <nowiki><nowiki></nowiki></nowiki> tags, which may be desirable in some instances.  Example: a [[micro]]<nowiki>second</nowiki>.\r\n|\r\n<pre><nowiki>\r\nSan Francisco also has\r\n[[public transport]]ation.\r\n\r\nExamples include [[bus]]es,\r\n [[taxicab]]s, and [[streetcar]]s.\r\n\r\na [[micro]]<nowiki>second</nowiki>\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nSee the [[Wikipedia:Manual of Style]].\r\n\r\n* A link to another [[Help:namespace|namespace]].\r\n|\r\n<pre><nowiki>\r\nSee the \r\n[[Wikipedia:Manual of Style]].\r\n</nowiki></pre>\r\n\r\n|- id=\"link-to-section\" valign=\"top\"\r\n|\r\n[[Wikipedia:Manual of Style#Italics]] is a link to a section within another page.\r\n\r\n[[#Links and URLs]] is a link to another section on the current page.\r\n\r\n[[Wikipedia:Manual of Style#Italics|Italics]] is a piped link to a section within another page.\r\n\r\n* The part after the number sign (#) must match a section heading on the page. Matches must be exact in terms of spelling, case, and punctuation.  Links to non-existent sections are not broken; they are treated as links to the top of the page.\r\n* Include \"| link title\" to create a stylish (piped) link title.\r\n\r\n|\r\n<pre><nowiki>\r\n[[Wikipedia:Manual of Style#Italics]] \r\nis a link to a section within another page.\r\n\r\n[[#Links and URLs]] is a link\r\nto another section on the \r\ncurrent page.\r\n\r\n[[Wikipedia:Manual of Style#Italics|Italics]] \r\nis a piped link to a section within \r\nanother page.</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nAutomatically hide stuff in parentheses:\r\n[[kingdom (biology)|kingdom]].\r\n\r\nAutomatically hide namespace:\r\n[[Wikipedia:Village Pump|Village Pump]]. \r\n\r\nOr both:\r\n[[Wikipedia:Manual of Style (headings)|Manual of Style]]\r\n\r\nBut not:\r\n[[Wikipedia:Manual of Style#Links|]]\r\n* The server fills in the part after the pipe character (|) when you save the page. The next time you open the edit box you will see the expanded piped link. When [[Wikipedia:Show preview|preview]]ing your edits, you will not see the expanded form until you press \'\'\'Save\'\'\' and \'\'\'Edit\'\'\' again. The same applies to links to sections within the same page ([[#link-to-section|see previous entry]]).\r\n* See [[Wikipedia:Pipe trick]] for details.\r\n\r\n|\r\n<pre><nowiki>\r\nAutomatically hide stuff\r\nin parentheses:\r\n[[kingdom (biology)|]].\r\n\r\nAutomatically hide namespace: \r\n[[Wikipedia:Village Pump|]].\r\n\r\nOr both:\r\n[[Wikipedia:\r\nManual of Style (headings)|]]\r\n\r\nBut not:\r\n[[Wikipedia:\r\nManual of Style#Links|]]\r\n</nowiki></pre>\r\n\r\n\r\n|- valign=\"top\"\r\n|\r\n<!-- A village pump proposal was made so that users would be allowed to create the article shown here. Pages here would be articles requested for a long time. If you find someone has created the article, please look in requested articles and put one in its place -->\r\n[[National sarcasm society]] is a page\r\nthat does not exist yet.\r\n\r\n* You can create it by clicking on the link.\r\n* To create a new page: \r\n*# Create a link to it on some other (related) page.\r\n*# Save that page.\r\n*# Click on the link you just made. The new page will open for editing.\r\n* For more information, see [[Wikipedia:How to start a page|How to start a page]] and check out Wikipedia\'s [[Wikipedia:Naming conventions|naming conventions]].\r\n* Please do not create a new article without linking to it from at least one other article.\r\n|\r\n<pre><nowiki>\r\n[[National sarcasm society]]\r\nis a page \r\nthat does not exist yet.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\r\n[[Wikipedia:How to edit a page]] is a link to this page.\r\n\r\n* [[Help:Self link|Self link]]s appear as bold text when the article is viewed.\r\n* Do not use this technique to make the article name bold in the first paragraph; see the [[Wikipedia:Manual of Style#Article titles|Manual of Style]].\r\n|\r\n<pre><nowiki>\r\n[[Wikipedia:How to edit a page]]\r\nis a link to this page.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nThe character \'\'\'tilde\'\'\' (~) is used when adding a comment to a Talk page. \r\nYou should sign your comment by appending four tildes (<nowiki>~~~~</nowiki>)\r\nto the comment so as to add your user name plus date/time:\r\n: [[User:Patricia|Patricia Zhang]] 13:40, Jan 14, 2007 (UTC)\r\nAdding three tildes (<nowiki>~~~</nowiki>) will add just your user name:\r\n: [[User:Patricia|Patricia Zhang]]\r\nand adding five tildes (<nowiki>~~~~~</nowiki>) gives the date/time alone:\r\n: 13:40, Jan 14, 2007 (UTC)\r\n\r\n* The first two both provide a link to your [[Wikipedia:user page|user page]].\r\n|\r\n<pre><nowiki>\r\nThe character \'\'\'tilde\'\'\' (~) is used \r\nwhen adding a comment to a Talk page. \r\nYou should sign your comment by \r\nappending four tildes (~~~~)\r\nto the comment so as to add your \r\nuser name plus date/time:\r\n: ~~~~\r\nAdding three tildes (~~~) will add \r\njust your user name:\r\n: ~~~\r\nand adding five tildes (~~~~~) gives \r\nthe date/time alone:\r\n: ~~~~~\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n* [[Wikipedia:Redirect|Redirect]] one article title to another by placing a directive like the one shown to the right on the \'\'first\'\' line of the article (such as at a page titled \"[[USA]]\").\r\n* It is possible to redirect to a section. For example, a redirect to [[United States#History|United States History]] will redirect to the [[United States]] page, to the History section if it exists.\r\n|\r\n<pre><nowiki>\r\n#REDIRECT [[United States]]\r\n\r\n#REDIRECT [[United States#History|United \r\nStates History]] will redirect to the \r\n[[United States]] page, to the History \r\nsection if it exists \r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\r\n* Link to a page on the same subject in another language by placing a link of the form: <nowiki>[[language code:Title]]</nowiki> in the wiki text of the article.\r\nFor example in the article on [[Plankton]], which is available on a lot of other wikis, the interlanguage links would look like so:\r\n:<tt><nowiki>[[de:Plankton]] [[es:Plancton]] [[ru:????????]] [[simple:Plankton]]</nowiki></tt>\r\n* While it does not matter where you put these links while editing, it is recommended that these links be placed at the very end of the edit box. \r\n* These will not be visible in the main text of the article on which they are placed but appear as links in the extreme left margin column of Wikipedia page as part of a separate box under the \'toolbox\' titled \'in other languages\'. You can check out the links to the corresponding page in wikipedias of other languages for this Wikipedia MOS help page itself.\r\n* Please see [[Wikipedia:Interlanguage links]] and the [[Wikipedia:Complete list of language wikis available|list of languages and codes]].\r\n|\r\n<pre><nowiki>\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'What links here\'\'\' and \'\'\'Related changes\'\'\'\r\npages can be linked as:\r\n[[Special:Whatlinkshere/Wikipedia:How to edit a page]]\r\nand\r\n[[Special:Recentchangeslinked/Wikipedia:How to edit a page]]\r\n\r\n|\r\n<pre><nowiki>\r\n\'\'\'What links here\'\'\' and\r\n\'\'\'Related changes\'\'\'\r\npages can be linked as:\r\n[[Special:Whatlinkshere/\r\nWikipedia:How to edit a page]]\r\nand\r\n[[Special:Recentchangeslinked/\r\nWikipedia:How to edit a page]]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nA user\'s \'\'\'Contributions\'\'\' page can be linked as:\r\n[[Special:Contributions/UserName]]\r\nor\r\n[[Special:Contributions/192.0.2.0]]\r\n|\r\n<pre><nowiki>\r\nA user\'s \'\'\'Contributions\'\'\' page\r\ncan be linked as:\r\n[[Special:Contributions/UserName]]\r\nor\r\n[[Special:Contributions/192.0.2.0]]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n* To put an article in a [[Wikipedia:Category]], place a link like the one to the right anywhere in the article. As with interlanguage links, it does not matter where you put these links while editing as they will always show up in the same place when you save the page, but placement at the end of the edit box is recommended.\r\n|\r\n<pre><nowiki>\r\n[[Category:Character sets]]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n* To \'\'link\'\' to a [[Wikipedia:Category]] page without putting the article into the category, use an initial colon (:) in the link.\r\n|\r\n<pre><nowiki>\r\n[[:Category:Character sets]]\r\n</nowiki></pre>\r\n|- id=\"link-external\" valign=\"top\"\r\n|\r\nThree ways to link to external (non-wiki) sources:\r\n# Bare URL: http://www.wikipedia.com/ (bad style)\r\n# Unnamed link: [http://www.wikipedia.com/] (only used within article body for footnotes)\r\n# Named link: [http://www.wikipedia.com Wikipedia]\r\n\r\n:See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts.\r\n\r\n* Square brackets indicate an external link. Note the use of a \'\'space\'\' (not a pipe) to separate the URL from the link text in the \"named\" version.\r\n* In the [[URL]], all symbols must be among:<br/>\'\'\'A-Z a-z 0-9 . _ \\ / ~ % - + & # ? ! = ( ) @\'\'\'\r\n* If a URL contains a character not in this list, it should be encoded by using a percent sign (%) followed by the [[hexadecimal|hex]] code of the character, which can be found in the table of [[ASCII#ASCII printable characters|ASCII printable characters]]. For example, the caret character (^) would be encoded in a URL as \'\'\'%5E\'\'\'.\r\n* If the \"named\" version contains a closing square bracket \"]\", then you must use the [[HTML]] special character syntax, i.e. \'\'\']\'\'\' otherwise the [[MediaWiki]] software will prematurely interpret this as the end of the external link.\r\n* There is a class that can be used to remove the arrow image from the external link. It is used in [[Template:Ref]] to stop the URL from expanding during printing. It should \'\'\'never\'\'\' be used in the main body of an article. However, there is an exception: wikilinks in Image markup. An example of the markup is as follows:\r\n** Markup: <nowiki><span\r\nclass=\"plainlinksneverexpand\">\r\n[http://www.sysinternals.com/\r\nntw2k/freeware/winobj.shtml WinObj]</span></nowiki>\r\n** Display: <span class=\"plainlinksneverexpand\"> [http://www.sysinternals.com/ntw2k/freeware/winobj.shtml WinObj]</span>\r\n* See [[Wikipedia:External links]] for style issues.\r\n|\r\n<pre><nowiki>\r\nThree ways to link to\r\nexternal (non-wiki) sources:\r\n# Bare URL:\r\nhttp://en.wikipedia.org/\r\n(bad style)\r\n# Unnamed link:\r\n[http://en.wikipedia.org/]\r\n(only used within article\r\nbody for footnotes)\r\n# Named link:\r\n[http://en.wikipedia.org Wikipedia]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nLinking to other wikis:\r\n# [[Interwiki]] link: [[Wiktionary:Hello]]\r\n# Interwiki link without prefix: [[Wiktionary:Hello|Hello]]\r\n# Named interwiki link: [[Wiktionary:Hello|Wiktionary definition of \'Hello\']]\r\n\r\n* All of these forms lead to the URL http://en.wiktionary.org/wiki/Hello\r\n* Note that interwiki links use the \'\'internal\'\' link style.\r\n* See [[MetaWikiPedia:Interwiki_map]] for the list of shortcuts; if the site you want to link to is not on the list, use an external link ([[#link-external|see above]]).\r\n* See also [[Wikipedia:Wikimedia sister projects]].\r\n\r\nLinking to another language\'s wiktionary:\r\n# [[Wiktionary:fr:bonjour]]\r\n# [[Wiktionary:fr:bonjour|bonjour]]\r\n# [[Wiktionary:fr:bonjour|fr:bonjour]]\r\n\r\n* All of these forms lead to the URL http://fr.wiktionary.org/wiki/bonjour\r\n|\r\n<pre><nowiki>\r\nLinking to other wikis:\r\n# [[Interwiki]] link:\r\n[[Wiktionary:Hello]]\r\n# Interwiki link without prefix:\r\n[[Wiktionary:Hello|]]\r\n# Named interwiki link:\r\n[[Wiktionary:Hello|\r\nWiktionary definition \r\nof \'Hello\']]\r\n\r\nLinking to another\r\nlanguage\'s wiktionary:\r\n# [[Wiktionary:fr:bonjour]]\r\n# [[Wiktionary:fr:bonjour|bonjour]]\r\n# [[Wiktionary:fr:bonjour|]]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nISBN 012345678X\r\n\r\nISBN 0-12-345678-X\r\n\r\n* Link to books using their [[Wikipedia:ISBN|ISBN]]. This is preferred to linking to a specific online bookstore, because it gives the reader a choice of vendors. However, if one bookstore or online service provides additional free information, such as table of contents or excerpts from the text, then a link to that source will aid the user and is recommended.\r\n* ISBN links do not need any extra markup, provided you use one of the indicated formats.\r\n|\r\n<pre><nowiki>\r\nISBN 012345678X\r\n\r\nISBN 0-12-345678-X\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nText mentioning RFC 4321 anywhere\r\n\r\n* Link to [[Internet Engineering Task Force]] [[Request for Comments|RFC]]s.\r\n|\r\n<pre><nowiki>\r\nText mentioning RFC 4321 \r\nanywhere\r\n</nowiki></pre>\r\n\r\n|- valign=top\r\n|\r\nDate formats:\r\n# [[July 20]], [[1969]]\r\n# [[20 July]] [[1969]]\r\n# [[1969]]-[[07-20]]\r\n# [[1969-07-20]]\r\n\r\n* Link dates in one of the above formats, so that everyone can set their own display order. If [[Special:Userlogin|logged in]], you can use [[Special:Preferences]] to change your own date display setting.\r\n* All of the above dates will appear as \"[[20 July|20 July]] [[1969|1969]]\" if you set your date display preference to \"15 January 2001\", but as \"[[20 July|July 20]], [[1969|1969]]\" if you set it to \"January 15, 2001\", or as \"[[1969|1969]]-[[July 20|07-20]]\" if you set it to \"2001-01-15\".\r\n|\r\n<pre><nowiki>\r\nDate formats:\r\n# [[July 20]], [[1969]]\r\n# [[20 July]] [[1969]]\r\n# [[1969]]-[[07-20]]\r\n# [[1969-07-20]]\r\n\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nSpecial [[WP:AO|as-of]] links like [[As of 2006|this year]]\r\nneeding future maintenance\r\n|\r\n<pre><nowiki>\r\nSpecial [[WP:AO|as-of]] links \r\nlike [[As of 2006|this year]]\r\nneeding future maintenance\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n[[media:Classical guitar scale.ogg|Sound]]\r\n\r\n*To include links to non image uploads such as sounds, use a \"media\" link. For images, [[#Images|see next section]].\r\n\r\nSome uploaded sounds are listed at [[Wikipedia:Sound]].\r\n|\r\n<pre><nowiki>\r\n[[media:Classical guitar scale.ogg|Sound]]\r\n</nowiki></pre>\r\n\r\n|- valign=\"top\"\r\n|\r\nLink directly to \'\'\'edit\'\'\' for an existing page, or apply other link attributes. \r\n* use <nowiki>{{fullurl:}}</nowiki>  \r\n* or use [[template:edit|<nowiki>{{template:edit}}</nowiki>]] which conceals the edit label for page printing \r\n|\r\n<pre><nowiki>{{fullurl:page name|action=edit}}</nowiki></pre>\r\n|}\r\n\r\n===Images===\r\nOnly images that have been uploaded to Wikipedia can be used. To upload images, use the [[Special:Upload|upload page]]. You can find the uploaded image on the [[Special:Imagelist|image list]].\r\n\r\n{| border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\r\n|-\r\n! What it looks like\r\n! What you type\r\n|- valign=\"top\"\r\n|A picture: \r\n[[Image:wiki.png]]\r\n|<pre>A picture: \r\n<nowiki>[[Image:wiki.png]]</nowiki></pre>\r\n\r\n|- valign=\"top\"\r\n|With alternative text:\r\n[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]\r\n|<pre>With alternative text:\r\n<nowiki>[[Image:wiki.png|Wikipedia, The Free Encyclopedia.]]</nowiki></pre>\r\n* Alternative text, used when the image is unavailable or when the image is loaded in a text-only browser, or when spoken aloud, is \'\'\'strongly\'\'\' encouraged. See [[Wikipedia:Alternate text for images|Alternate text for images]] for help on choosing it.\r\n\r\n|- valign=\"top\"\r\n|Floating to the right side of the page using the \'\'frame\'\' attribute and a caption:\r\n[[Image:wiki.png|frame|Wikipedia Encyclopedia]]<br clear=all>\r\n|<pre>Floating to the right side of the page \r\nusing the \'\'frame\'\' attribute and a caption:\r\n<nowiki>[[Image:wiki.png|frame|Wikipedia Encyclopedia]]</nowiki></pre>\r\n* The frame tag automatically floats the image right.\r\n* The caption is also used as alternate text.\r\n\r\n|- valign=\"top\"\r\n|Floating to the right side of the page using the \'\'thumb\'\' attribute and a caption:\r\n[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]<br clear=all>\r\n|<pre>Floating to the right side of the page \r\nusing the \'\'thumb\'\' attribute and a caption:\r\n<nowiki>[[Image:wiki.png|thumb|Wikipedia Encyclopedia]]</nowiki></pre>\r\n* The thumb tag automatically floats the image right.\r\n* The caption is also used as alternate text.\r\n* An enlarge icon is placed in the lower right corner.\r\n\r\n|- valign=\"top\"\r\n|Floating to the right side of the page \'\'without\'\' a caption:\r\n[[Image:wiki.png|right|Wikipedia Encyclopedia]]\r\n|<pre>Floating to the right side of the page\r\n\'\'without\'\' a caption:\r\n<nowiki>[[Image:wiki.png|right|Wikipedia Encyclopedia]]</nowiki></pre>\r\n* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.\r\n\r\n|- valign=\"top\"\r\n|A picture resized to 30 pixels...\r\n[[Image:wiki.png|30 px]]\r\n|<pre>A picture resized to 30 pixels...\r\n<nowiki>[[Image:wiki.png|30 px]]</nowiki></pre>\r\n* The help topic on [[Wikipedia:Extended image syntax|extended image syntax]] explains more options.\r\n\r\n|- valign=\"top\"\r\n|Linking directly to the description page of an image:\r\n[[:Image:wiki.png]]\r\n|<pre>Linking directly to the description page\r\nof an image:\r\n<nowiki>[[:Image:wiki.png]]</nowiki></pre>\r\n* Clicking on an image displayed on a page\r\n(such as any of the ones above)\r\nalso leads to the description page\r\n\r\n|- valign=\"top\"\r\n|Linking directly to an image without displaying it:\r\n[[:Image:wiki.png|Image of the jigsaw globe logo]]\r\n|<pre>Linking directly to an image\r\nwithout displaying it:\r\n<nowiki>[[:media:wiki.png|Image of the jigsaw globe logo]]</nowiki></pre>\r\n* To include links to images shown as links instead of drawn on the page, use a \"media\" link.\r\n\r\n|- valign=\"top\" \r\n|Using the [[div tag]] to separate images from text (note that this may allow images to cover text):\r\n|<pre><nowiki>Example:\r\n<div style=\"display:inline;\r\nwidth:220px; float:right;\">\r\nPlace images here </div></nowiki></pre>\r\n\r\n|- valign=\"top\" \r\n|Using wiki markup to make a table in which to place a vertical column of images (this helps edit links match headers, especially in Firefox browsers): \r\n|<pre><nowiki>Example: {| align=right\r\n|-\r\n| \r\nPlace images here\r\n|}\r\n</nowiki></pre>\r\n\r\n|}\r\n\r\nSee the Wikipedia\'s [[Wikipedia:Image use policy|image use policy]] as a guideline used on Wikipedia.\r\n\r\nFor further help on images, including some more versatile abilities, see the topic on [[Wikipedia:Extended image syntax|Extended image syntax]].\r\n\r\n===Headings===\r\n\r\nFor a top-level heading, put it on a separate line surrounded by \'==\'. For example:\r\n\r\n   ==Introduction==\r\n\r\nSubheadings use \'===\', \'====\', and so on.\r\n\r\n===Character formatting===\r\n{| border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\r\n|- valign=\"top\"\r\n! What it looks like\r\n! What you type\r\n|- id=\"emph\" valign=\"top\"\r\n|\r\n\'\'Italicized text\'\'<br />\'\'\'Bold text\'\'\'<br />\'\'\'\'\'Italicized & Bold text\'\'\'\'\'\r\n|\r\n<pre><nowiki>\r\n\'\'Italicized text\'\'\r\n\'\'\'Bold text\'\'\'\r\n\'\'\'\'\'Italicized & Bold text\'\'\'\'\'\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nA typewriter font for <tt>monospace text</tt>\r\nor for computer code: <code>int main()</code>\r\n\r\n* For semantic reasons, using <code><code></code> where applicable is preferable to using <code><tt></code>.\r\n|\r\n<pre><nowiki>\r\nA typewriter font for <tt>monospace text</tt>\r\nor for computer code: <code>int main()</code>\r\n</nowiki></pre>\r\n|- valign=top\r\n|\r\nCreate codeblocks<code><pre>\r\n#include <iostream.h>\r\nint main ()\r\n{\r\ncout << \"Hello World!\";\r\nreturn 0;\r\n}\r\n</pre></code> that are printed as entered\r\n|\r\n<pre>Use <code><pre> Block of Code </pre></code> \r\naround the block of code.\r\n\r\n* The <pre> tags within the code block \r\nwill create formatting issues. To solve, \r\ndisplay the tags literally with \r\n<pre>  and  </pre></pre>\r\n|- valign=\"top\"\r\n|\r\nYou can use <small>small text</small> for captions.\r\n|\r\n<pre><nowiki>\r\nYou can use <small>small text</small> for captions.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nBetter stay away from <big>big text</big>, unless\r\n<small> it\'s <big>within</big> small</small> text. \r\n|\r\n<pre><nowiki>\r\nBetter stay away from <big>big text</big>, unless\r\n<small> it\'s <big>within</big> small</small> text.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\nYou can <s>strike out deleted material</s>\r\nand <u>underline new material</u>.\r\n\r\nYou can also mark <del>deleted material</del> and\r\n<ins>inserted material</ins> using logical markup.\r\nFor backwards compatibility better combine this\r\npotentially ignored new <del>logical</del> with \r\nthe old <s><del>physical</del></s> markup.\r\n\r\n* When editing regular Wikipedia articles, just make your changes and do not mark them up in any special way.\r\n* When editing your own previous remarks in talk pages, it is sometimes appropriate to mark up deleted or inserted material.\r\n|\r\n<pre><nowiki>\r\nYou can <s>strike out deleted material</s>\r\nand <u>underline new material</u>.\r\n\r\nYou can also mark <del>deleted material</del> and\r\n<ins>inserted material</ins> using logical markup.\r\nFor backwards compatibility better combine this\r\npotentially ignored new <del>logical</del> with\r\nthe old <s><del>physical</del></s> markup.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Suppressing interpretation of markup:\'\'\'\r\n<br/>\r\n<nowiki>Link ? (\'\'to\'\') the [[Wikipedia FAQ]]</nowiki>\r\n* Used to show literal data that would otherwise have special meaning.\r\n* Escape all wiki markup, including that which looks like HTML tags.\r\n* Does not escape HTML character references.\r\n* To escape HTML character references such as <tt>?</tt> use <tt>&rarr;</tt>\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n<nowiki>Link ? (\'\'to\'\') \r\nthe [[Wikipedia FAQ]]</nowiki>\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Commenting page source:\'\'\'\r\n<br/>\r\n\'\'not shown when viewing page\'\'\r\n* Used to leave comments in a page for future editors.\r\n* Note that most comments should go on the appropriate [[Wikipedia:Talk page|Talk page]].\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n<!-- comment here -->\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'<span id=\"diacritics\">Diacritical marks:</span>\'\'\'\r\n<br/>\r\nÀ Á Â Ã Ä Å <br/>\r\nÆ Ç È É Ê Ë <br/>\r\nÌ Í\r\nÎ Ï Ñ Ò <br/>\r\nÓ Ô Õ\r\nÖ Ø Ù <br/>\r\nÚ Û Ü ß\r\nà á <br/>\r\nâ ã ä å æ\r\nç <br/>\r\nè é ê ë ì í<br/>\r\nî ï ñ ò ó ô <br/>\r\nœ õ\r\nö ø ù ú <br/>\r\nû ü ÿ\r\n\r\n* See [[meta:Help:Special characters|special characters]].\r\n|\r\n<br/>\r\n<pre><nowiki>\r\nÀ Á Â Ã Ä Å \r\nÆ Ç È É Ê Ë \r\nÌ Í Î Ï Ñ Ò \r\nÓ Ô Õ Ö Ø Ù \r\nÚ Û Ü ß à á \r\nâ ã ä å æ ç \r\nè é ê ë ì í\r\nî ï ñ ò ó ô \r\nœ õ ö ø ù ú \r\nû ü ÿ\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Punctuation:\'\'\'\r\n<br/>\r\n¿ ¡ § ¶<br/>\r\n† ‡ • – —<br/>\r\n‹ › « »<br/>\r\n‘ ’ “ ”\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n¿ ¡ § ¶\r\n† ‡ • – —\r\n‹ › « »\r\n‘ ’ “ ”\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Commercial symbols:\'\'\'\r\n<br/>\r\n™ © ® ¢ € ¥<br/>\r\n£ ¤\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n™ © ® ¢ € ¥ \r\n£ ¤\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Subscripts:\'\'\'\r\n<br/>\r\nx<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or\r\n<br/>\r\nx? x? x? x? x?\r\n<br/>\r\nx? x? x? x? x?\r\n\r\n\'\'\'Superscripts:\'\'\'\r\n<br/>\r\nx<sup>1</sup> x² x³ or\r\n<br/>\r\nx? x¹ x² x³ x?\r\n<br/>\r\nx? x? x? x? x?\r\n\r\n*The latter methods of sub/superscripting cannot be used in the most general context, as they rely on Unicode support which may not be present on all users\' machines. For the 1-2-3 superscripts, it is nevertheless preferred when possible (as with units of measurement) because most browsers have an easier time formatting lines with it.\r\n\r\n?<sub>0</sub> =\r\n8.85 × 10<sup>?12</sup>\r\nC² / J m.\r\n\r\n1 [[hectare]] = [[1 E4 m²]]\r\n|\r\n<br/>\r\n<pre><nowiki>\r\nx<sub>1</sub> x<sub>2</sub> x<sub>3</sub> or\r\n<br/>\r\nx? x? x? x? x?\r\n<br/>\r\nx? x? x? x? x?\r\n</nowiki></pre>\r\n\r\n<pre><nowiki>\r\nx<sup>1</sup> x<sup>2</sup> x<sup>3</sup> or\r\n<br/>\r\nx? x¹ x² x³ x?\r\n<br/>\r\nx? x? x? x? x?\r\n\r\n?<sub>0</sub> =\r\n8.85 × 10<sup>?12</sup>\r\nC² / J m.\r\n\r\n1 [[hectare]] = [[1 E4 m²]]\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Greek characters:\'\'\'\r\n<br/>\r\n? ? ? ? ? ? <br/>\r\n? ? ? ? ? ? ? <br/>\r\n? ? ? ? ? ?<br/>\r\n? ? ? ? ? ?<br/>\r\n? ? ? ? ? ? <br/>\r\n? ? ? ?\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n? ? ? ? ? ? \r\n? ? ? ? ? ? ? \r\n? ? ? ? ? ?\r\n? ? ? ? ? ?\r\n? ? ? ? ? ? \r\n? ? ? ?\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Mathematical characters:\'\'\'\r\n<br/>\r\n? ? ? ? ? ± ?<br/>\r\n? ? ? ? ? ?<br/>\r\n× · ÷ ? ? ?<br/>\r\n? ‰ ° ? ? ø<br/>\r\n? ? ? ? ? ? ? ?<br/>\r\n¬ ? ? ? ? <br/>\r\n? ? ? ? ?<br/>\r\n? ? ? ? ?<br/>\r\n* See also [[Wikipedia:WikiProject Mathematics|WikiProject Mathematics]] and [[TeX]].\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n? ? ? ? ? ± ?\r\n? ? ? ? ? ?\r\n× · ÷ ? ? ?\r\n? ‰ ° ? ? ø\r\n? ? ? ? ? ? ? ?\r\n¬ ? ? ? ? \r\n? ? ? ? ?\r\n? ? ? ? ?\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n<math>\\,\\! \\sin x + \\ln y</math><br>\r\nsin\'\'x\'\' + ln\'\'y\'\'\r\n<!-- no space between roman \"sin\" and italic \"x\" -->\r\n\r\n<math>\\mathbf{x} = 0</math><br>\r\n\'\'\'x\'\'\' = 0\r\n\r\nOrdinary text should use [[#emph|wiki markup for emphasis]], and should not use <code><i></code> or <code><b></code>.  However, mathematical formulae often use italics, and sometimes use bold, for reasons unrelated to emphasis.  Complex formulae should use [[Help:Formula|<code><math></code> markup]], and simple formulae may use <code><math></code>; or <code><i></code> and <code><b></code>; or <code><nowiki>\'\'</nowiki></code> and <code><nowiki>\'\'\'</nowiki></code>.  According to [[Wikipedia:WikiProject Mathematics#Italicization and bolding|WikiProject Mathematics]], wiki markup is preferred over HTML markup like <code><i></code> and <code><b></code>.\r\n|\r\n<pre><nowiki>\r\n<math>\\,\\! \\sin x + \\ln y</math>\r\nsin\'\'x\'\' + ln\'\'y\'\'\r\n\r\n<math>\\mathbf{x} = 0</math>\r\n\'\'\'x\'\'\' = 0\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Spacing in simple math formulae:\'\'\'\r\n<br/>\r\nObviously, \'\'x\'\'² ? 0 is true when \'\'x\'\' is a real number.\r\n*To space things out without allowing line breaks to interrupt the formula, use non-breaking spaces: <tt> </tt>.\r\n|\r\n<br/>\r\n<pre><nowiki>\r\nObviously, \'\'x\'\'² ? 0 is true \r\nwhen \'\'x\'\' is a real number.\r\n</nowiki></pre>\r\n|- valign=\"top\"\r\n|\r\n\'\'\'Complicated formulae:\'\'\'\r\n<br/>\r\n: <math>\\sum_{n=0}^\\infty \\frac{x^n}{n!}</math>\r\n* See [[Help:Formula]] for how to use <tt><math></tt>.\r\n* A formula displayed on a line by itself should probably be indented by using the colon (:) character.\r\n|\r\n<br/>\r\n<pre><nowiki>\r\n: <math>\\sum_{n=0}^\\infty \\frac{x^n}{n!}</math>\r\n</nowiki></pre>\r\n|}\r\n\'\'(see also: [[Chess symbols in Unicode]])\'\'\r\n\r\n===No or limited formatting—showing exactly what is being typed===\r\n\r\nA few different kinds of formatting will tell the Wiki to display things as you typed them—what you see, is what you get!\r\n\r\n{| border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\r\n|-\r\n!What it looks like\r\n!What you type\r\n|-\r\n|\'\'\'<nowiki> tag:\'\'\'<br/>\r\n<nowiki>\r\nThe nowiki tag ignores [[Wiki]] \'\'markup\'\'.\r\nIt reformats text by removing newlines    and multiple spaces.\r\nIt still interprets special characters: ?\r\n</nowiki>\r\n|<pre><nowiki>\r\n<nowiki>\r\nThe nowiki tag ignores [[Wiki]] \'\'markup\'\'.\r\nIt reformats text by removing newlines \r\nand multiple spaces.\r\nIt still interprets special\r\ncharacters: ?\r\n</nowiki>\r\n</nowiki></pre>\r\n|-\r\n|\'\'\'<pre> tag:\'\'\'</br>\r\n<pre>\r\nThe pre tag ignores [[Wiki]] \'\'markup\'\'.\r\nIt also doesn\'t     reformat text.\r\nIt still interprets special characters: ?\r\n</pre>\r\n|<pre><pre><nowiki>\r\nThe pre tag ignores [[Wiki]] \'\'markup\'\'.\r\nIt also doesn\'t     reformat text.\r\nIt still interprets special characters:\r\n ?\r\n</nowiki></pre></pre>\r\n|-\r\n|\'\'\'Leading space:\'\'\'<br/>\r\nLeading spaces are another way \r\nto preserve formatting. \'\'However, it will make the whole page fail to render properly in some browsers, such as IE7, thus making the page unreadable.\'\'\r\n\r\n\r\n Putting a space at the beginning of each line\r\n stops the text   from being reformatted. \r\n It still interprets [[Wiki]] \'\'markup\'\' and\r\n special characters: ?\r\n|<pre><nowiki>\r\nLeading spaces are another way \r\nto preserve formatting.\r\n Putting a space at the beginning of each line\r\n stops the text   from being reformatted. \r\n It still interprets [[Wiki]] \'\'markup\'\' and\r\n special characters: ?\r\n</nowiki></pre>\r\n|}\r\n\r\n===Invisible text (comments)===\r\n{{main|Wikipedia:Manual of Style#Invisible comments}}\r\nIt\'s uncommon, but on occasion acceptable, to add a hidden comment within the text of an article.  <!-- This is an example of text that won\'t normally be visible except in \"edit\" mode. --> The format is this:\r\n <nowiki><!-- This is an example of text that won\'t normally be visible except in \"edit\" mode. --></nowiki>\r\n\r\n=== Table of contents===\r\n<!-- ==== Placement of the Table of Contents (TOC) ==== -->\r\nAt the current status of the wiki markup language, having at least four headers on a page triggers the table of contents (TOC) to appear in front of the first header (or after introductory sections).  Putting <nowiki>__TOC__</nowiki> anywhere forces the TOC to appear at that point (instead of just before the first header).  Putting <nowiki>__NOTOC__</nowiki> anywhere forces the TOC to disappear.  See also [[Wikipedia:Section#Compact_TOC|compact TOC]] for alphabet and year headings.\r\n<!--\r\nTHE TEXT BELOW IS COMMENTED OUT SINCE THE DESCRIBED TECHNIQUE \r\nDOESN\'T WORK AFTER UPGRADING TO MEDIAWIKI 1.5\r\n\r\n====Keeping headings out of the Table of Contents====\r\nIf you want some subheadings to not appear in the Table of Contents, then make the following replacements.\r\n\r\nReplace  <nowiki> == Header 2 == with <h2> Header 2 </h2> </nowiki>\r\n\r\nReplace  <nowiki> === Header 3 === with <h3> Header 3 </h3> </nowiki>\r\n\r\nAnd so forth.\r\n\r\nFor example, notice that the following header has the same font as the other subheaders to this \"Tables\" section, but the following header does not appear in the Table of Contents for this page.\r\n\r\n<h4> This header has the h4 font, but is NOT in the Table of Contents (actually, it is)</h4>\r\n\r\nThis effect is obtained by the following line of code.\r\n\r\n<code><nowiki><h4> This header has the h4 font, but is not in the Table of Contents </h4></nowiki></code>\r\n\r\nNote that when editing by section, this approach places the text between the tags in the subsequent section, not the previous section. To edit this text, click the edit link next to \"Tables\", not the one above.\r\n-->\r\n\r\n===Tables===\r\nThere are two ways to build tables: \r\n*in special Wiki-markup (see [[Help:Table]])\r\n*with the usual HTML elements: <table>, <tr>, <td> or <th>.\r\n\r\nFor the latter, and a discussion on when tables are appropriate, see [[Wikipedia:When to use tables]].\r\n\r\n===Variables===\r\n\'\'(See also [[Help:Variable]])\'\'\r\n{| style=\"text-align:center\"\r\n|-\r\n! Code\r\n! Effect\r\n|-\r\n| <nowiki>{{CURRENTWEEK}}</nowiki> || {{CURRENTWEEK}}\r\n|-\r\n| <nowiki>{{CURRENTDOW}}</nowiki> || {{CURRENTDOW}}\r\n|-\r\n| <nowiki>{{CURRENTMONTH}}</nowiki> || {{CURRENTMONTH}}\r\n|-\r\n| <nowiki>{{CURRENTMONTHNAME}}</nowiki>\r\n| {{CURRENTMONTHNAME}}\r\n|-\r\n| <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>\r\n| {{CURRENTMONTHNAMEGEN}}\r\n|-\r\n| <nowiki>{{CURRENTDAY}}</nowiki> || {{CURRENTDAY}}\r\n|-\r\n| <nowiki>{{CURRENTDAYNAME}}</nowiki> || {{CURRENTDAYNAME}}\r\n|-\r\n| <nowiki>{{CURRENTYEAR}}</nowiki> || {{CURRENTYEAR}}\r\n|-\r\n| <nowiki>{{CURRENTTIME}}</nowiki> || {{CURRENTTIME}}\r\n|-\r\n| <nowiki>{{NUMBEROFARTICLES}}</nowiki>\r\n| {{NUMBEROFARTICLES}}\r\n|-\r\n| <nowiki>{{NUMBEROFUSERS}}</nowiki>\r\n| {{NUMBEROFUSERS}}\r\n|-\r\n| <nowiki>{{PAGENAME}}</nowiki> || {{PAGENAME}}\r\n|-\r\n| <nowiki>{{NAMESPACE}}</nowiki> || {{NAMESPACE}}\r\n|-\r\n| <nowiki>{{REVISIONID}}</nowiki> || {{REVISIONID}}\r\n|-\r\n| <nowiki>{{localurl:pagename}}</nowiki>\r\n| {{localurl:pagename}}\r\n|-\r\n| <nowiki>{{localurl:</nowiki>\'\'Wikipedia:Sandbox\'\'<nowiki>|action=edit}}</nowiki>\r\n| {{localurl:Wikipedia:Sandbox|action=edit}}\r\n|-\r\n| <nowiki>{{fullurl:pagename}}</nowiki>\r\n| {{fullurl:pagename}} \r\n|- \r\n| <nowiki>{{fullurl:pagename|</nowiki>\'\'query_string\'\'<nowiki>}}</nowiki>\r\n| {{fullurl:pagename|query_string}} \r\n|- \r\n| <nowiki>{{SERVER}}</nowiki> || {{SERVER}}\r\n|-\r\n| <nowiki>{{ns:1}}</nowiki> || {{ns:1}}\r\n|-\r\n| <nowiki>{{ns:2}}</nowiki> || {{ns:2}}\r\n|-\r\n| <nowiki>{{ns:3}}</nowiki> || {{ns:3}}\r\n|-\r\n| <nowiki>{{ns:4}}</nowiki> || {{ns:4}}\r\n|-\r\n| <nowiki>{{ns:5}}</nowiki> || {{ns:5}}\r\n|-\r\n| <nowiki>{{ns:6}}</nowiki> || {{ns:6}}\r\n|-\r\n| <nowiki>{{ns:7}}</nowiki> || {{ns:7}}\r\n|-\r\n| <nowiki>{{ns:8}}</nowiki> || {{ns:8}}\r\n|-\r\n| <nowiki>{{ns:9}}</nowiki> || {{ns:9}}\r\n|-\r\n| <nowiki>{{ns:10}}</nowiki> || {{ns:10}}\r\n|-\r\n| <nowiki>{{ns:11}}</nowiki> || {{ns:11}}\r\n|-\r\n| <nowiki>{{ns:12}}</nowiki> || {{ns:12}}\r\n|-\r\n| <nowiki>{{ns:13}}</nowiki> || {{ns:13}}\r\n|-\r\n| <nowiki>{{ns:14}}</nowiki> || {{ns:14}}\r\n|-\r\n| <nowiki>{{ns:15}}</nowiki> || {{ns:15}}\r\n|-\r\n| <nowiki>{{SITENAME}}</nowiki> || {{SITENAME}}\r\n|}\r\n\r\n\'\'\'NUMBEROFARTICLES\'\'\' is the number of pages in the main namespace which contain a link and are not a redirect, in other words number of articles, stubs containing a link, and disambiguation pages.\r\n\r\n\'\'\'CURRENTMONTHNAMEGEN\'\'\' is the genitive (possessive) grammatical form of the month name, as used in some languages; \'\'\'CURRENTMONTHNAME\'\'\' is the nominative (subject) form, as usually seen in English.\r\n\r\nIn languages where it makes a difference, you can use constructs like <nowiki>{{grammar:case|word}}</nowiki> to convert a word from the nominative case to some other case.  For example, <nowiki>{{grammar:genitive|{{CURRENTMONTHNAME}}}}</nowiki> means the same as <nowiki>{{CURRENTMONTHNAMEGEN}}</nowiki>. <!-- Is there a reference for this, other than the source code (for example, phase3/languages/Lnaguage*.php) ? -->\r\n\r\n\r\nThis page is covered by [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]',NULL,1,'2008-02-27 14:54:14',1),
 ('59121859-EB3F-023C-703B2FFFF21FBAE3','59104F5A-9555-E540-6BCAA65D9AE6F448','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== List basics ==\r\n\r\nCodexWiki offers three types of lists. \'\'\'Ordered lists\'\'\', \'\'\'unordered lists\'\'\', and \'\'\'definition lists\'\'\'. In the following sections, ordered lists are used for examples. Unordered lists would give corresponding results.\r\n\r\n{|border=1 width=\"79%\"\r\n!wikitext!!rendering\r\n|-\r\n|\r\n * Lists are easy to do:\r\n ** start every line\r\n * with a star\r\n ** more stars mean\r\n *** deeper levels\r\n||\r\n* Lists are easy to do:\r\n** start every line\r\n* with a star\r\n** more stars mean \r\n*** deeper levels\r\n|-\r\n|\r\n *A newline\r\n *in a list  \r\n marks the end of the list.\r\n Of course\r\n *you can\r\n *start again.\r\n|\r\n*A newline\r\n*in a list  \r\nmarks the end of the list.\r\nOf course\r\n*you can\r\n*start again.\r\n|-\r\n|\r\n # Numbered lists are good\r\n ## very organized\r\n ## easy to follow\r\n|\r\n# Numbered lists are good\r\n## very organized\r\n## easy to follow\r\n|-\r\n|\r\n * You can also\r\n **break lines\r\n **like this\r\n|\r\n* You can also\r\n**break lines\r\n**like this\r\n|-\r\n|\r\n ; Definition lists\r\n ; item : definition\r\n ; semicolon plus term\r\n : colon plus definition\r\n|\r\n; Definition lists\r\n; item : definition\r\n; semicolon plus term\r\n: colon plus definition\r\n|-\r\n|\r\n * Or create mixed lists\r\n *# and nest them\r\n *#* like this\r\n *#*; definitions\r\n *#*: work:\r\n *#*; apple\r\n *#*; banana\r\n *#*: fruits\r\n|\r\n* Or create mixed lists\r\n*# and nest them\r\n*#* like this\r\n*#*; definitions\r\n*#*: work: \r\n*#*; apple\r\n*#*; banana\r\n*#*: fruits\r\n|}\r\n\r\n== Paragraphs in lists ==\r\n\r\nFor simplicity, list items in wiki markup cannot be longer than a paragraph. A following blank line will end the list and reset the counter on ordered lists. Separating unordered list items usually has no noticable effects.\r\n\r\nParagraphs can be forced in lists by using HTML tags. Two line break symbols, <code><nowiki><br><br></nowiki></code>, will create the desired effect. So will enclosing all but the first paragraph with <code><nowiki><p>...</p></nowiki></code>\r\n\r\nFor a list with items of more than one paragraph long, adding a blank line between items may be necessary to avoid confusion.\r\n\r\n==Continuing a list item after a sub-item==\r\n\r\nIn HTML, a list item may contain several sublists, not necessarily adjacent; thus there may be parts of the list item not only before the first sublist, but also between sublists, and after the last one; however, in wiki-syntax, sublists follow the same rules as sections of a page: the only possible part of the list item not in sublists is before the first sublist.\r\n\r\nIn the case of an unnumbered first-level list in wikitext code this limitation can be overcome by splitting the list into multiple lists; indented text between the partial lists may visually serve as part of a list item after a sublist; however, this may give, depending on CSS, a blank line before and after each list, in which case, for uniformity, every first-level list item could be made a separate list.\r\n\r\nNumbered lists illustrate that what should look like one list may, for the software, consist of multiple lists; unnumbered lists give a corresponding result, except that the problem of restarting with 1 is not applicable.\r\n\r\n{| style=\"border:1px;border-spacing:1px;background-color:black;\" cellpadding=\"5\"\r\n|- style=\"background-color:white;\"\r\n|\r\n <nowiki>\r\n<ol>\r\n  <li>list item A1\r\n    <ol>\r\n      <li>list item B1</li>\r\n      <li>list item B2</li>\r\n    </ol>continuing list item A1\r\n  </li>\r\n  <li>list item A2</li>\r\n</ol></nowiki>\r\n| <ol>\r\n  <li>list item A1\r\n    <ol>\r\n      <li>list item B1</li>\r\n      <li>list item B2</li>\r\n    </ol>continuing list item A1\r\n  </li>\r\n  <li>list item A2</li>\r\n</ol>\r\n|- style=\"background-color:#E0E0E0;font-weight:bold;text-align:center;\"\r\n| colspan=\"2\" | vs.\r\n|- style=\"background-color:white;\"\r\n|\r\n #list item A1\r\n ##list item B1\r\n ##list item B2\r\n #:continuing list item A1\r\n #list item A2\r\n|\r\n#list item A1\r\n##list item B1\r\n##list item B2\r\n#:continuing list item A1\r\n#list item A2\r\n|}\r\n\r\nOne level deeper, with a sublist item continuing after a sub-sublist, one gets even more blank lines; however, the continuation of the first-level list is not affected:\r\n<pre>\r\n#list item A1\r\n##list item B1\r\n###list item C1\r\n##:continuing list item B1\r\n##list item B2\r\n#list item A2\r\n</pre>\r\ngives\r\n#list item A1\r\n##list item B1\r\n###list item C1\r\n##:continuing list item B1\r\n##list item B2\r\n#list item A2\r\n\r\nSee also [[Help:Section#Subdivisions in general|subdivisions]].\r\n\r\n== Changing the list type ==\r\n\r\nThe list type (which type of marker appears before the list item) can be changed in CSS by setting the [http://www.w3.org/TR/REC-CSS2/generate.html#lists list-style-type] property:\r\n\r\n{|border=1 width=\"79%\"\r\n!wikitext!!rendering\r\n|-\r\n|\r\n <nowiki>\r\n<ol style=\"list-style-type:lower-roman\">\r\n  <li>About the author</li>\r\n  <li>Foreword to the first edition</li>\r\n  <li>Foreword to the second edition</li>\r\n</ol></nowiki>\r\n|<ol style=\"list-style-type:lower-roman\">\r\n  <li>About the author</li>\r\n  <li>Foreword to the first edition</li>\r\n  <li>Foreword to the second edition</li>\r\n</ol>\r\n|-\r\n|}\r\n\r\n==Extra indentation of lists==\r\nIn a numbered list in a large font, some browsers do not show more than two digits, unless extra indentation is applied (if there are multiple columns: for each column). This can be done with CSS:\r\n ol { margin-left: 2cm}\r\nor alternatively, like below.\r\n\r\n{|border=1\r\n!wikitext!!rendering \r\n! style=\"width: 40%\" | comments\r\n|-\r\n|\r\n <nowiki>\r\n:#abc\r\n:#def\r\n:#ghi\r\n </nowiki>\r\n|\r\n:#abc\r\n:#def\r\n:#ghi\r\n| A list of one or more lines starting with a colon creates a [http://www.w3.org/TR/html4/struct/lists.html#edef-DL definition list] without definition terms, and with the items as definition descriptions, hence indented. However, if the colons are in front of the codes \"*\" or \"#\" of an unordered or ordered list, the list is treated as one definition description, so the whole list is indented.\r\n|-\r\n|\r\n <nowiki>\r\n<ul>\r\n  <ol>\r\n    <li>abc</li>\r\n    <li>def</li>\r\n    <li>ghi</li>\r\n  </ol>\r\n</ul>\r\n</nowiki>\r\n|\r\n<ul>\r\n  <ol>\r\n    <li>abc</li>\r\n    <li>def</li>\r\n    <li>ghi</li>\r\n  </ol>\r\n</ul>\r\n| MediaWiki translates an unordered list (ul) without any list items (li) into a div with a <code>style=\"margin-left: 2em\"</code>, causing  indentation of the contents. This is \'\'\'the most versatile method\'\'\', as it allows starting with a number other than 1, see below.\r\n\r\n|-\r\n|\r\n <nowiki>\r\n<ul>\r\n#abc\r\n#def\r\n#ghi\r\n</ul>\r\n</nowiki>\r\n|\r\n<ul>\r\n#abc\r\n#def\r\n#ghi\r\n</ul>\r\n|Like above, with the content of the \"unordered list without any list items\", which itself is an ordered list, expressed with # codes. The HTML produced, and hence the rendering, is the same. This is the \'\'\'recommended\'\'\' method when not starting with a number other than 1.\r\n\r\n|}\r\n\r\nTo demonstrate that all three methods show all digits of 3-digit numbers, see [[m:Help:List demo|List demo]].\r\n\r\n==Specifying a starting value==\r\nSpecifying a starting value is only possible with HTML syntax.\r\n(W3C has deprecated the <code>start</code> and <code>value</code> attributes as used below in HTML 4.01 and XHTML 1.0. But as of 2007, no popular web browsers implement CSS counters, which were to replace these attributes. Wikimedia projects use XHTML Transitional, which contains the deprecated attributes.)\r\n\r\n<pre>\r\n<ol start=\"9\">\r\n<li>Amsterdam</li>\r\n<li>Rotterdam</li>\r\n<li>The Hague</li>\r\n</ol>\r\n</pre>\r\ngives\r\n<ol start=\"9\">\r\n<li>Amsterdam</li>\r\n<li>Rotterdam</li>\r\n<li>The Hague</li>\r\n</ol>\r\n\r\nOr:\r\n<pre>\r\n<ol>\r\n<li value=\"9\">Amsterdam</li>\r\n<li value=\"8\">Rotterdam</li>\r\n<li value=\"7\">The Hague</li>\r\n</ol>\r\n</pre>\r\ngives\r\n<ol>\r\n<li value=\"9\">Amsterdam</li>\r\n<li value=\"8\">Rotterdam</li>\r\n<li value=\"7\">The Hague</li>\r\n</ol>\r\n\r\n==Comparison with a table==\r\nApart from providing automatic numbering, the numbered list also aligns the contents of the items, comparable with using table syntax:\r\n<pre>\r\n{|\r\n|-\r\n| align=right |  9.||Amsterdam\r\n|-\r\n| align=right | 10.||Rotterdam\r\n|-\r\n| align=right | 11.||The Hague\r\n|}\r\n</pre>\r\ngives\r\n{|\r\n|-\r\n| align=right |  9.||Amsterdam\r\n|-\r\n| align=right | 10.||Rotterdam\r\n|-\r\n| align=right | 11.||The Hague\r\n|}\r\n\r\nThis non-automatic numbering has the advantage that if a text refers to the numbers, insertion or deletion of an item does not disturb the correspondence.\r\n\r\n==Multi-column bulleted list==\r\n<pre>\r\n{| \r\n| \r\n*1\r\n*2 \r\n| \r\n*3\r\n*4\r\n|}\r\n</pre>\r\ngives:\r\n{| \r\n| \r\n*1\r\n*2 \r\n| \r\n*3\r\n*4\r\n|}\r\n\r\n==Multi-column numbered list==\r\nSpecifying a starting value is useful for a numbered list with multiple columns, to avoid restarting from one in each column. As mentioned above, this is only possible with HTML-syntax (for the first column either wiki-syntax or HTML-syntax can be used).\r\n\r\nIn combination with the extra indentation explained in the previous section:\r\n<pre>\r\n{| valign=\"top\"\r\n|-\r\n|<ul><ol start=\"125\"><li>a<li>bb<li>ccc</ol></ul>\r\n|<ul><ol start=\"128\"><li>ddd<li>ee<li>f</ol></ul>\r\n|}\r\n</pre>\r\n\r\ngives\r\n\r\n{| valign=\"top\"\r\n|-\r\n|<ul><ol start=\"125\"><li>a<li>bb<li>ccc</ol></ul>\r\n|<ul><ol start=\"128\"><li>ddd<li>ee<li>f</ol></ul>\r\n|}\r\n\r\nUsing {{tim|multi-column numbered list}} the computation of the starting values can be automated, and only the first starting value and the number of items in each column except the last has to be specified. Adding an item to, or removing an item from a column requires adjusting only one number, the number of items in that column, instead of changing the starting numbers for all subsequent columns.\r\n\r\n<pre>{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}</pre>\r\n\r\ngives\r\n\r\n{{Multi-column numbered list|125|a<li>bb<li>ccc|3|<li>ddd<li>ee<li>f}}\r\n\r\n<pre>{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>\r\n\r\ngives\r\n\r\n{{Multi-column numbered list|lst=lower-alpha|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}\r\n\r\n<pre>{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}</pre>\r\n\r\ngives\r\n\r\n{{Multi-column numbered list|lst=lower-roman|125|a<li>bb<li>ccc|3|<li>ddd<li>ee|2|<li>f}}\r\n\r\n<pre>{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}</pre>\r\n\r\ngives\r\n\r\n{{Multi-column numbered list|lst=disc||a<li>bb<li>ccc||<li>ddd<li>ee|-|<li>f}}\r\n\r\n==Streamlined style or horizontal style==\r\nIt is also possible to present short lists using very basic formatting, such as:\r\n\r\n <nowiki>\'\'Title of list:\'\'</nowiki> example 1, example 2, example 3\r\n\r\n\'\'Title of list:\'\' example 1, example 2, example 3\r\n\r\nThis style requires less space on the page, and is preferred if there are only a few entries in the list, it can be read easily, and a direct edit point is not required. The list items should start with a lowercase letter unless they are proper nouns.\r\n\r\n==Tables==\r\nA one-column table is very similar to a list, but it allows sorting. If the wikitext itself is already sorted with the same sortkey, this advantage does not apply.\r\nA multiple-column table allows sorting on any column.\r\n\r\nSee also [[en:Wikipedia:When to use tables]].\r\n\r\n==Changing unordered lists to ordered ones==\r\nWith the CSS\r\n ul { list-style: decimal }\r\nunordered lists are changed to ordered ones. This applies (as far as the CSS selector does not restrict this) to all ul-lists in the HTML source code:\r\n*those produced with *\r\n*those with <nowiki><ul></nowiki> in the wikitext\r\n*those produced by the system\r\n\r\nSince each special page, like other pages, has a class based on the pagename, one can separately specify for each type whether the lists should be ordered, see [[Help:User contributions#User styles]] and [[Help:What links here#User styles]].\r\n\r\nHowever, it does not seem possible to make all page history lists ordered (unless one makes \'\'all\'\' lists ordered), because the class name is based on the page for which the history is viewed. \r\n\r\n\r\n\r\n\r\nThis page is covered under [http://en.wikipedia.org/wiki/Wikipedia:Text_of_the_GNU_Free_Documentation_License GNU Free Documentation License]',NULL,1,'2008-02-27 15:06:40',1);
/*!40000 ALTER TABLE "wiki_pagecontent" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_pagecontent_category"
--

DROP TABLE IF EXISTS "codex"."wiki_pagecontent_category";
CREATE TABLE  "codex"."wiki_pagecontent_category" (
  "FKpagecontent_id" varchar(36) NOT NULL,
  "FKcategory_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpagecontent_id","FKcategory_id"),
  KEY "FKcategory_id" ("FKcategory_id"),
  KEY "FKpagecontent_id" ("FKpagecontent_id"),
  KEY "FKcategory_id_2" ("FKcategory_id"),
  KEY "FKpagecontent_id_2" ("FKpagecontent_id"),
  CONSTRAINT "FKpagecontent_id" FOREIGN KEY ("FKpagecontent_id") REFERENCES "wiki_pagecontent" ("pagecontent_id"),
  CONSTRAINT "FKcategory_id" FOREIGN KEY ("FKcategory_id") REFERENCES "wiki_category" ("category_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_pagecontent_category"
--

/*!40000 ALTER TABLE "wiki_pagecontent_category" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_pagecontent_category" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_permissions"
--

DROP TABLE IF EXISTS "codex"."wiki_permissions";
CREATE TABLE  "codex"."wiki_permissions" (
  "permission_id" varchar(36) NOT NULL,
  "permission" varchar(100) NOT NULL,
  PRIMARY KEY  ("permission_id"),
  UNIQUE KEY "permission" ("permission")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_permissions"
--

/*!40000 ALTER TABLE "wiki_permissions" DISABLE KEYS */;
INSERT INTO "codex"."wiki_permissions" VALUES  ('A9D04702-CF1E-5C1B-94C2965619E301C8','WIKI_ADMIN'),
 ('8840B7C9-E693-D54B-6A69F07AA5265839','WIKI_CREATE'),
 ('8840FF13-0A96-AAA9-63322F27E6713489','WIKI_DELETE'),
 ('884120D4-F9D7-22CB-46341F8BCF1B68A5','WIKI_DELETE_VERSION'),
 ('8840D553-F9D9-59F9-90B05EF765403F90','WIKI_EDIT'),
 ('A9D3BA34-CF1E-5C1B-961D24FF9A32538B','WIKI_REGISTRATION'),
 ('88415476-D0F8-32A5-7E7D3340828C0E6B','WIKI_ROLLBACK_VERSION'),
 ('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','WIKI_VIEW'),
 ('88417F6E-CA8B-53C9-59DEF4C4888CDE82','WIKI_VIEW_HISTORY');
/*!40000 ALTER TABLE "wiki_permissions" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_role_permissions"
--

DROP TABLE IF EXISTS "codex"."wiki_role_permissions";
CREATE TABLE  "codex"."wiki_role_permissions" (
  "FKpermission_id" varchar(36) NOT NULL,
  "FKrole_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKpermission_id","FKrole_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKrole_id" ("FKrole_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKrole_id_2" ("FKrole_id"),
  CONSTRAINT "FKrole_id" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id"),
  CONSTRAINT "FK_permissionid" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_role_permissions"
--

/*!40000 ALTER TABLE "wiki_role_permissions" DISABLE KEYS */;
INSERT INTO "codex"."wiki_role_permissions" VALUES  ('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('88409695-AB9F-3AF7-CF1F8CF7FDCBE3D1','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4'),
 ('8840B7C9-E693-D54B-6A69F07AA5265839','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('8840B7C9-E693-D54B-6A69F07AA5265839','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('8840D553-F9D9-59F9-90B05EF765403F90','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('8840D553-F9D9-59F9-90B05EF765403F90','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('8840FF13-0A96-AAA9-63322F27E6713489','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('8840FF13-0A96-AAA9-63322F27E6713489','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('884120D4-F9D7-22CB-46341F8BCF1B68A5','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('884120D4-F9D7-22CB-46341F8BCF1B68A5','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('88415476-D0F8-32A5-7E7D3340828C0E6B','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('88417F6E-CA8B-53C9-59DEF4C4888CDE82','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('88417F6E-CA8B-53C9-59DEF4C4888CDE82','883C6A58-05CA-D886-22F7940C19F792BD'),
 ('88417F6E-CA8B-53C9-59DEF4C4888CDE82','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4'),
 ('A9D04702-CF1E-5C1B-94C2965619E301C8','883C4730-ACC9-1AF4-93737DB4E2E368EF'),
 ('A9D3BA34-CF1E-5C1B-961D24FF9A32538B','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4');
/*!40000 ALTER TABLE "wiki_role_permissions" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_roles"
--

DROP TABLE IF EXISTS "codex"."wiki_roles";
CREATE TABLE  "codex"."wiki_roles" (
  "role_id" varchar(36) NOT NULL,
  "role" varchar(100) NOT NULL,
  PRIMARY KEY  ("role_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_roles"
--

/*!40000 ALTER TABLE "wiki_roles" DISABLE KEYS */;
INSERT INTO "codex"."wiki_roles" VALUES  ('883C4730-ACC9-1AF4-93737DB4E2E368EF','ADMIN'),
 ('883C6A58-05CA-D886-22F7940C19F792BD','USER'),
 ('883C8533-DC73-C1F0-521E41EC19FD6E78','MODERATOR'),
 ('A9D370CD-CF1E-5C1B-9B9B75680AB49DE4','ANONYMOUS');
/*!40000 ALTER TABLE "wiki_roles" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_securityrules"
--

DROP TABLE IF EXISTS "codex"."wiki_securityrules";
CREATE TABLE  "codex"."wiki_securityrules" (
  "securityrule_id" varchar(36) NOT NULL,
  "whitelist" varchar(255) default NULL,
  "securelist" varchar(255) default NULL,
  "permissions" varchar(255) default NULL,
  "redirect" varchar(255) default NULL,
  PRIMARY KEY  ("securityrule_id"),
  UNIQUE KEY "securityrule_id" ("securityrule_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_securityrules"
--

/*!40000 ALTER TABLE "wiki_securityrules" DISABLE KEYS */;
INSERT INTO "codex"."wiki_securityrules" VALUES  ('88572359-B40D-B373-DE9E3DA49F37ABE5','^user','^admin','ADMIN','user.login');
/*!40000 ALTER TABLE "wiki_securityrules" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_users"
--

DROP TABLE IF EXISTS "codex"."wiki_users";
CREATE TABLE  "codex"."wiki_users" (
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
  UNIQUE KEY "user_username" ("user_username"),
  KEY "FKrole_id" ("FKrole_id"),
  CONSTRAINT "FK_wiki_users_wiki_roles" FOREIGN KEY ("FKrole_id") REFERENCES "wiki_roles" ("role_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_users"
--

/*!40000 ALTER TABLE "wiki_users" DISABLE KEYS */;
INSERT INTO "codex"."wiki_users" VALUES  ('A9CF56CA-CF1E-5C1B-91F2AEF8FBD03AA4','ANONYMOUS','ANONYMOUS','ANONYMOUS@CODEXWIKI.CFOM',1,1,'2008-03-14 17:36:39',NULL,1,'ANONYMOUS','0CD487D652F3139D5E01E3263B3B37995602EB8692D11BB37E4DBE33F40581852C63A9964EBC233E10BEB192B2851AA613E640E5137132CA8C061D3327388E5F','A9D370CD-CF1E-5C1B-9B9B75680AB49DE4'),
 ('A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','admin','admin','admin@codexwiki.com',1,1,'2008-03-14 18:31:10','2008-03-14 18:31:10',0,'admin','0CD487D652F3139D5E01E3263B3B37995602EB8692D11BB37E4DBE33F40581852C63A9964EBC233E10BEB192B2851AA613E640E5137132CA8C061D3327388E5F','883C4730-ACC9-1AF4-93737DB4E2E368EF');
/*!40000 ALTER TABLE "wiki_users" ENABLE KEYS */;


--
-- Definition of table "codex"."wiki_users_permissions"
--

DROP TABLE IF EXISTS "codex"."wiki_users_permissions";
CREATE TABLE  "codex"."wiki_users_permissions" (
  "FKuser_id" varchar(36) NOT NULL,
  "FKpermission_id" varchar(36) NOT NULL,
  PRIMARY KEY  ("FKuser_id","FKpermission_id"),
  KEY "FKpermission_id" ("FKpermission_id"),
  KEY "FKuser_id" ("FKuser_id"),
  KEY "FKpermission_id_2" ("FKpermission_id"),
  KEY "FKuser_id_2" ("FKuser_id"),
  CONSTRAINT "FKusers_id" FOREIGN KEY ("FKuser_id") REFERENCES "wiki_users" ("user_id"),
  CONSTRAINT "FKpermission_id" FOREIGN KEY ("FKpermission_id") REFERENCES "wiki_permissions" ("permission_id")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table "codex"."wiki_users_permissions"
--

/*!40000 ALTER TABLE "wiki_users_permissions" DISABLE KEYS */;
/*!40000 ALTER TABLE "wiki_users_permissions" ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
