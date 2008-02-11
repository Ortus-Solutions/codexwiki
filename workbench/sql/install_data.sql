
/* 
    Default namespaces:
    ''
    Special
 */

INSERT INTO wiki_namespace
VALUES 
('F1C0292E-CB06-FD09-41D904E8550FE734','','Default Namespace',1)
,
('06AF3D1C-0B00-EAA3-09A138DFA27F7E28','Special','Special',0);

/*
    Default pages:
    Special:Feeds
    
*/
INSERT INTO wiki_page 
VALUES
('06AF3D6A-0AB3-43E6-EF2D1118F58A1562','Special:Feeds','06AF3D1C-0B00-EAA3-09A138DFA27F7E28');

/* 
    default content:
*/
INSERT INTO wiki_pagecontent 
VALUES
('06AF3D9F-F000-34AC-65CBF528D2F4F658','06AF3D6A-0AB3-43E6-EF2D1118F58A1562','== Codex RSS Feed Directory ==\r\n<feed url=\"codex://feed/directory/list.cfm\" />',1,'2008-02-11 15:09:50',1);

