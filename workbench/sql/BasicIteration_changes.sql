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
ALTER TABLE `codex`.`wiki_customhtml` CHARACTER SET utf8 COLLATE utf8_general_ci;
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

