/* 22.04.08 :: Custom HTML tables */

/* Luis Majano: Added Custom HTML and Options */
CREATE TABLE wiki_customHTML
(
    customHTML_id VARCHAR(36) NOT NULL,
    customHTML_beforeHeadEnd TEXT,
    customHTML_afterBodyStart TEXT,
    customHTML_beforeBodyEnd TEXT,
    customHTML_modify_date DATETIME NOT NULL,
    PRIMARY KEY (customHTML_id)
) ENGINE=InnoDB
;
CREATE TABLE wiki_options
(
	options_id VARCHAR(36) NOT NULL,
	option_name VARCHAR(255),
	option_value TEXT,
	PRIMARY KEY (options_id)
) DEFAULT CHARACTER SET utf8 ENGINE=InnoDB
;

/* Luis Majano: Added utf8 encoding */
ALTER TABLE `codex`.`wiki_category` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_customHTML` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_namespace` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_page` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_pagecontent` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_pagecontent_category` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_permissions` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_role_permissions` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_roles` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_securityrules` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_users` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `codex`.`wiki_users_permissions` CHARACTER SET utf8 COLLATE utf8_general_ci;

/* Luis Majano Indexes */
ALTER TABLE `codex`.`wiki_users` ADD INDEX idx_credentials(`user_isActive`, `user_isConfirmed`, `user_username`, `user_password`);
ALTER TABLE `codex`.`wiki_users` ADD INDEX idx_byEmail(`user_isActive`, `user_isConfirmed`, `user_email`);
ALTER TABLE `codex`.`wiki_users` ADD INDEX idx_default(`user_isDefault`);
ALTER TABLE `codex`.`wiki_category` ADD INDEX idx_wiki_category_name(`category_name`);
ALTER TABLE `codex`.`wiki_namespace` ADD INDEX idx_wiki_namespace_name(`namespace_name`);
ALTER TABLE `codex`.`wiki_page` ADD INDEX idx_wiki_page_name(`page_name`);
ALTER TABLE `codex`.`wiki_pagecontent` ADD INDEX idx_wiki_pagecontent_isActive(`pagecontent_isActive`);

/* Luis Majano Descriptions */
ALTER TABLE `codex`.`wiki_roles` ADD COLUMN `description` VARCHAR(255) NOT NULL AFTER `role`;
ALTER TABLE `codex`.`wiki_permissions` ADD COLUMN `description` VARCHAR(255) NOT NULL AFTER `permission`;

/* Mark Mandel: added Special:Category Page */

INSERT INTO `codex`.`wiki_page` (`page_id`,`page_name`,`FKnamespace_id`) VALUES 
 ('E5CC1A90-D36E-9214-33EB0021D817DE59','Special:Categories','06AF3D1C-0B00-EAA3-09A138DFA27F7E28');

INSERT INTO `codex`.`wiki_pagecontent` (`pagecontent_id`,`FKpage_id`,`FKuser_id`,`pagecontent_content`,`pagecontent_comment`,`pagecontent_version`,`pagecontent_createdate`,`pagecontent_isActive`) VALUES 
 ('E5CC1AC5-C484-565C-19E5F34B3712AD02','E5CC1A90-D36E-9214-33EB0021D817DE59','A9D7F9E5-CF1E-5C1B-935B04502EB6B9A1','== Category Listing ==\r\n\r\n<feed url=\"/feed/category/list.cfm\" display=\"numbered\" />','Initial Creation',1,'2008-05-14 14:59:28',1);
