CREATE TABLE wiki_pagecontent_category
(
	FKpagecontent_id VARCHAR(36) NOT NULL,
	FKcategory_id VARCHAR(36) NOT NULL,
	PRIMARY KEY (FKpagecontent_id, FKcategory_id),
	KEY (FKcategory_id),
	KEY (FKpagecontent_id),
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
	page_name VARCHAR(1000) NOT NULL,
	PRIMARY KEY (page_id),
	UNIQUE (page_name)
) 
;


CREATE TABLE wiki_category
(
	category_id VARCHAR(36) NOT NULL,
	category_name VARCHAR(1000) NOT NULL,
	category_createddate DATETIME NULL,
	PRIMARY KEY (category_id),
	UNIQUE (category_name)
) 
;






ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKcategory_id 
	FOREIGN KEY (FKcategory_id) REFERENCES wiki_category (category_id)
;

ALTER TABLE wiki_pagecontent_category ADD CONSTRAINT FKpagecontent_id 
	FOREIGN KEY (FKpagecontent_id) REFERENCES wiki_pagecontent (pagecontent_id)
;

ALTER TABLE wiki_pagecontent ADD CONSTRAINT FK_wiki_pagecontent_wiki_page 
	FOREIGN KEY (FKpage_id) REFERENCES wiki_page (page_id)
;
