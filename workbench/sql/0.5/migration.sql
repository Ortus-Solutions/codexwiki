DROP TABLE `wiki_options`;
CREATE TABLE `wiki_options` (
  `option_id` varchar(36) NOT NULL,
  `option_name` varchar(255) NOT NULL,
  `option_value` text NOT NULL,
  PRIMARY KEY  (`option_id`)
)DEFAULT CHARACTER SET utf8 ENGINE=InnoDB
;
ALTER TABLE `codex`.`wiki_options` ADD UNIQUE INDEX Index_2(`option_name`);

INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F03F883-AFFA-A78C-1A2EDA50675A3B46','wiki_defaultpage','Dashboard')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F045002-0E99-A690-7C59F405F98A19BE','wiki_search_engine','codex.model.search.adapters.DBSearch')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F0485D1-F0AB-DF57-DCD68A6AE5F2FF33','wiki_name','A Sweet Wiki')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F050595-E875-9C19-9978C4F271441867','wiki_paging_maxrows','10')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F052A79-DA80-9757-F8B952EFF0BF467E','wiki_paging_bandgap','5')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F05890F-C8D4-A7E1-7C60462D3C7AA437','wiki_defaultpage_label','My Dashboard')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F0622D3-A20F-60CF-5AE67B68F7294189','wiki_comments_mandatory','1')
;
INSERT INTO codex.wiki_options ( option_id, option_name, option_value ) VALUES ('9F0716AB-AF0A-8D94-4AEAA59490D24CB2','wiki_outgoing_email','myemail@email.com')
;

ALTER TABLE `wiki_customhtml` ADD `customHTML_afterSideBar` TEXT NULL AFTER `customHTML_modify_date`;
ALTER TABLE `wiki_customhtml` ADD `customHTML_beforeSideBar` TEXT NULL AFTER `customHTML_afterSideBar`;

ALTER TABLE `codex`.`wiki_pagecontent` ADD COLUMN `pagecontent_isReadOnly` BOOLEAN NOT NULL DEFAULT false AFTER `pagecontent_isActive`;
