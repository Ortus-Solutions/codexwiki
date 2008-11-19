<?xml version="1.0" encoding="UTF-8"?>
<transfer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="transfer.xsd">
  <objectCache>
  	<defaultcache>
		<!-- put this in, so it's not so greedy memory wise -->
  		<maxminutespersisted value="30"/>
  	</defaultcache>
  </objectCache>
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
			<property name="comment" column="pagecontent_comment" type="string"/>
			<property name="version" column="pagecontent_version" type="numeric"/>
			<property name="createdDate" column="pagecontent_createdate" type="date"/>
			<property name="isActive" column="pagecontent_isActive" type="boolean"/>
			<property name="isReadOnly" type="boolean" column="pagecontent_isReadOnly"/>
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
			<manytoone name="User" lazy="true">
				<link column="FKuser_id" to="security.User"/>
			</manytoone>
		</object>

		<object name="Category" table="wiki_category" decorator="codex.model.wiki.Category">
			<id name="category_id" type="UUID" generate="true"/>
			<property name="name" type="string" column="category_name"/>
			<property name="createdDate" type="date" column="category_createddate"/>
		</object>

		<object name="CustomHTML" table="wiki_customhtml" decorator="codex.model.wiki.CustomHTML">
			<id name="customHTML_id" type="UUID" generate="true" />
			<property name="beforeHeadEnd" type="string" column="customHTML_beforeHeadEnd" />
			<property name="afterBodyStart" type="string" column="customHTML_afterBodyStart" />
			<property name="beforeBodyEnd" type="string" column="customHTML_beforeBodyEnd" />
			<property name="afterSideBar" type="string" column="customHTML_afterSideBar" />
			<property name="beforeSideBar" type="string" column="customHTML_beforeSideBar" />
			<property name="modifyDate" type="date" column="customHTML_modify_date"/>
		</object>

		<object name="Option" table="wiki_options" decorator="codex.model.wiki.Option">
			<id name="option_id" type="UUID" generate="true" />
			<property name="name"  type="string" column="option_name" />
			<property name="value"  type="string" column="option_value" />
		</object>
		
  	</package>

	<!--Security Package -->
	<package name="security">

		<object name="Permission" table="wiki_permissions" decorator="codex.model.security.Permission">
			<id name="permissionID" column="permission_id" type="UUID" generate="true"/>
			<property name="permission" type="string" column="permission"/>
			<property name="description" type="string" column="description"/>
		</object>

		<object name="Role" table="wiki_roles" decorator="codex.model.security.Role">
			<id name="roleID" column="role_id" type="UUID" generate="true"/>
			<property name="role" type="string" column="role"/>
			<property name="description" type="string" column="description"/>
			<manytomany name="Permission" table="wiki_role_permissions" lazy="true">
				<link column="FKrole_id" 		to="security.Role"/>
				<link column="FKpermission_id" 	to="security.Permission"/>
				<collection type="array" />
			</manytomany>
		</object>

		<object name="User" table="wiki_users" decorator="codex.model.security.User">
			<id name="userID" column="user_id" type="UUID" generate="true"/>
			<property name="fname" type="string" column="user_fname"/>
			<property name="lname" type="string" column="user_lname"/>
			<property name="email" type="string" column="user_email"/>
			<property name="username" type="string" column="user_username"/>
			<property name="password" type="string" column="user_password"/>
			<property name="isActive" type="boolean" column="user_isActive"/>
			<property name="isConfirmed" type="boolean" column="user_isConfirmed"/>
			<property name="createDate" type="date" column="user_create_date" ignore-insert="true" ignore-update="true" refresh-insert="true"/>
			<property name="modifyDate" type="date" column="user_modify_date" ignore-insert="true" refresh-update="true"/>
			<property name="isDefault" type="boolean" column="user_isDefault" ignore-insert="true" refresh-insert="true"/>
			<manytoone name="Role">
				<link column="FKrole_id" to="security.Role"/>
			</manytoone>
			<manytomany name="Permission" table="wiki_users_permissions" lazy="true">
				<link column="FKuser_id" 		to="security.User"/>
				<link column="FKpermission_id" 	to="security.Permission"/>
				<collection type="array" />
			</manytomany>
		</object>

		<object name="SecurityRules" table="wiki_securityrules" decorator="codex.model.security.SecurityRule">
			<id name="securityruleID" type="UUID" column="securityrule_id" generate="true"/>
			<property name="whitelist" type="string" column="whitelist" nullable="true"/>
			<property name="securelist" type="string" column="securelist" />
			<property name="permissions" type="string" column="permissions" nullable="true"/>
			<property name="authorize_check" type="boolean" column="authorize_check"/>
			<property name="redirect" type="string" column="redirect"/>
		</object>

	</package>

  </objectDefinitions>
</transfer>