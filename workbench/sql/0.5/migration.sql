DROP TABLE `wiki_options`;
CREATE TABLE "wiki_options" (
  "option_id" varchar(36) NOT NULL,
  "option_name" varchar(255) NOT NULL,
  "option_value" text NOT NULL,
  PRIMARY KEY  ("option_id")
);
ALTER TABLE `codex`.`wiki_options` ADD UNIQUE INDEX Index_2(`option_name`);

ALTER TABLE `wiki_customhtml` ADD `customHTML_afterSideBar` TEXT NULL AFTER `customHTML_modify_date`;
ALTER TABLE `wiki_customhtml` ADD `customHTML_beforeSideBar` TEXT NULL AFTER `customHTML_afterSideBar`;

