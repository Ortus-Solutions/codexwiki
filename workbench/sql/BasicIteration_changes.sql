/* 22.04.08 :: Custom HTML tables */

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