CREATE TABLE wiki_page_category
(
	FKcategory_id VARCHAR(36) NOT NULL,
	FKpagecontent_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKcategory_id, FKpagecontent_id),
	KEY (FKcategory_id),
	KEY (FKpagecontent_id)
) 
;


CREATE TABLE wiki_pagecontent
(
	pagecontent_id VARCHAR(36) NOT NULL,
	FKpage_id VARCHAR(36) NOT NULL,
	pagecontent_content TEXT NULL,
	pagecontent_version BIGINT NULL DEFAULT 1,
	pagecontent_createdate DATETIME NOT NULL,
	pagecontent_isActive BIT NOT NULL DEFAULT 1,
	PRIMARY KEY (pagecontent_id),
	KEY (FKpage_id)
) 
;


CREATE TABLE wiki_page
(
	page_id VARCHAR(36) NOT NULL,
	page_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (page_id)
) 
;


CREATE TABLE wiki_category
(
	category_id VARCHAR(36) NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	category_createdate DATETIME NOT NULL,
	PRIMARY KEY (category_id),
	UNIQUE (category_name)
) 
;






ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_page 
	FOREIGN KEY (FKpage_id) REFERENCES wiki_page (page_id)
;
