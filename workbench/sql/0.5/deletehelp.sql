#
# Delete all help
#/

delete
from wiki_pagecontent
where wiki_pagecontent.FKpage_id IN
(
	select a.page_id
	from wiki_page a, wiki_namespace b
	where a.FKnamespace_id = b.namespace_id AND
	b.namespace_name = 'Help'
);

delete
from wiki_page
where wiki_page.FKnamespace_id IN 
(
	select wiki_namespace.namespace_id
	from wiki_namespace
	where
	wiki_namespace.namespace_name = 'Help'
);

