<?xml version="1.0" encoding="UTF-8"?>
<transfer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="/home/mark/wwwroot/transfer-root/transfer/resources/xsd/transfer.xsd">
  <objectDefinitions>
  	<package name="wiki">
		<object name="Page" table="wiki_page" decorator="codex.model.wiki.Page">
			<id name="pageID" column="page_id" type="UUID" generate="true"/>
			<property name="name" type="string" column="page_name"/>
		</object>

		<object name="Content" table="wiki_pagecontent" decorator="codex.model.wiki.Content">
			<id name="contentID" column="pagecontent_id" type="UUID" generate="true"/>
			<property name="content" column="pagecontent_content" type="string"/>
			<property name="version" column="pagecontent_version" type="numeric"/>
			<property name="createdDate" column="pagecontent_createdate" type="date"/>
			<property name="isActive" column="pagecontent_isActive" type="boolean"/>
			<manytoone name="Page">
				<link column="FKpage_id" to="wiki.Page"/>
			</manytoone>
		</object>

  	</package>
  </objectDefinitions>
</transfer>

