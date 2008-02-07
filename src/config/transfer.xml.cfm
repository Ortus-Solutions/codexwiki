<?xml version="1.0" encoding="UTF-8"?>
<transfer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="/home/mark/wwwroot/transfer-root/transfer/resources/xsd/transfer.xsd">
  <objectDefinitions>
  	<package name="wiki">
		<object name="Page" table="wiki_page" decorator="codex.model.wiki.Page">
			<id name="pageID" column="page_id" type="UUID" generate="true"/>
			<property name="name" type="string" column="page_name"/>
			<manytoone name="Namespace">
				<link column="FKnamespace_id" to="wiki.Namespace"/>
			</manytoone>
		</object>

		<object name="Namespace" table="wiki_namespace" decorator="codex.model.wiki.Namespace">
			<id name="namespace_id" type="UUID" generate="true"/>
			<property name="name" type="string" column="namespace_name"/>
			<property name="description" type="string" column="namespace_description"/>
			<property name="isDefault" type="boolean" column="namespace_isdefault"/>
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
			<manytomany name="Category" table="wiki_pagecontent_category">
				<link column="FKpagecontent_id" to="wiki.Content"/>
				<link column="FKcategory_id" to="wiki.Category"/>
				<collection type="array">
					<order property="name"/>
				</collection>
			</manytomany>
		</object>

		<object name="Category" table="wiki_category" decorator="codex.model.wiki.Category">
			<id name="category_id" type="UUID" generate="true"/>
			<property name="name" type="string" column="category_name"/>
			<property name="createdDate" type="date" column="category_createddate"/>
		</object>
  	</package>
  </objectDefinitions>
</transfer>

