#!/usr/bin/ruby
	# == Google Apps Provisioning API client library
	#
	# This library allows you to manage your domain (accounts, email lists, aliases) within your Ruby code.
	# It's based on the GDATA provisioning API v2.0.
	# Reference : http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html.
	#
	# All the public methods with _ruby_style_ names are aliased with _javaStyle_ names. Ex : create_user and createUser.
	#
	# Notice : because it uses REXML, your script using this library MUST be encoded in unicode (UTF-8).
	#
	# == Examples
	#
	#	#!/usr/bin/ruby
	#	require 'gappsprovisioning/provisioningapi'
	#	include GAppsProvisioning
	#	adminuser = "root@mydomain.com"
	#	password  = "PaSsWo4d!"
	#	myapps = ProvisioningApi.new(adminuser,password)	
	#	(see examples in  ProvisioningApi.new documentation for handling proxies)
	#
	#	new_user = myapps.create_user("jsmith", "john", "smith", "secret", nil, "2048")
	#	puts new_user.family_name
	#	puts new_user.given_name
	#	
	# Want to update a user ?
	#
	#	user = myapps.retrieve_user('jsmith')
	#	user_updated = myapps.update_user(user.username, user.given_name, user.family_name, nil, nil, "true")
	#
	# Want to add an alias or nickname ?
	#
	#  	new_nickname = myapps.create_nickname("jsmith", "john.smith")
	#
	# Want to manage groups ? (i.e. mailing lists)
	#
	#     new_group = myapps.create_group("sales-dep", ['Sales Departement'])
	#     new_member = myapps.add_member_to_group("jsmith", "sales-dep")
	#     new_owner = myapps.add_owner_to_group("jsmith", "sales-dep")
	#     (ATTENTION: an owner is added only if it's already member of the group!)
	#
	# Want to handle errors ?
	#
	#	begin
	#		user = myapps.retrieve_user('noone')
	#		puts "givenName : "+user.given_name, "familyName : "+user.family_name, "username : "+user.username"
	#		puts "admin ? : "+user.admin
	#	rescue GDataError => e
	#		puts "errorcode = " +e.code, "input : "+e.input, "reason : "+e.reason
	#	end
	#
	# Email lists (deprecated) ?
	#
	# 	new_list = myapps.create_email_list("sales-dep")
	# 	new_address = myapps.add_address_to_email_list("sales-dep", "bibi@ruby-forge.org")
	#
        # All methods described in the GAppsProvisioning::ProvisioningApi class documentation.
        #
	# Authors :: Jérôme Bousquié, Roberto Cerigato
	# Ruby version :: from 1.8.6
	# Licence :: Apache Licence, version 2
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0 
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#

require 'cgi'
require 'rexml/document'

require 'gappsprovisioning/connection'
require 'gappsprovisioning/exceptions'

include REXML



module GAppsProvisioning #:nodoc:

	# =Administrative object for accessing your domain
	# Examples
	#
	#	adminuser = "root@mydomain.com"
	#	password  = "PaSsWo4d!"
	#	myapps = ProvisioningApi.new(adminuser,password)	
	#	(see examples in  ProvisioningApi.new documentation for handling proxies)
	#
	#	new_user = myapps.create_user("jsmith", "john", "smith", "secret", nil, "2048")
	#	puts new_user.family_name
	#	puts new_user.given_name
	#	
	# Want to update a user ?
	#
	#	user = myapps.retrieve_user('jsmith')
	#	user_updated = myapps.update_user(user.username, user.given_name, user.family_name, nil, nil, "true")
	#
	# Want to add an alias or nickname ?
	#
	#  	new_nickname = myapps.create_nickname("jsmith", "john.smith")
	#
	# Want to manage groups ? (i.e. mailing lists)
	#
	# 	new_group = myapps.create_group("sales-dep", ['Sales Departement'])
	# 	new_member1 = myapps.add_member_to_group("john.doe@somedomain.com", "sales-dep")
	# 	new_member2 = myapps.add_member_to_group("jsmith", "sales-dep")
	# 	new_owner = myapps.add_owner_to_group("jsmith", "sales-dep")
        #               (ATTENTION: an owner is added only if it's already member of the group!)
        #
	#
	# Want to handle errors ?
	#
	#	begin
	#		user = myapps.retrieve_user('noone')
	#		puts "givenName : "+user.given_name, "familyName : "+user.family_name, "username : "+user.username"
	#		puts "admin ? : "+user.admin
	#	rescue GDataError => e
	#		puts "errorcode = " +e.code, "input : "+e.input, "reason : "+e.reason
	#	end
	#
        #



	class ProvisioningApi
		@@google_host = 'apps-apis.google.com'
		@@google_port = 443
		# authentication token, valid up to 24 hours after the last connection
		attr_reader :token


	        # Creates a new ProvisioningApi object
	        #
	        # 	mail : Google Apps domain administrator e-mail (string)
	        # 	passwd : Google Apps domain administrator password (string)
	        # 	proxy : (optional) host name, or IP, of the proxy (string)
	        # 	proxy_port : (optional) proxy port number (numeric)
	        # 	proxy_user : (optional) login for authenticated proxy only (string)
	        # 	proxy_passwd : (optional) password for authenticated proxy only (string)
	        #
	        # The domain name is extracted from the mail param value.
	        #
	        # Examples :
	        # 	standard : no proxy
	        # 	myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
	        # 	proxy :
	        # 	myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd','domain.proxy.com',8080)
	        # 	authenticated proxy :
	        # 	myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd','domain.proxy.com',8080,'foo','bAr')
		def initialize(mail, passwd, proxy=nil, proxy_port=nil, proxy_user=nil, proxy_passwd=nil)
			domain = mail.split('@')[1]
			@action = setup_actions(domain)
			conn = Connection.new(@@google_host, @@google_port, proxy, proxy_port, proxy_user, proxy_passwd)
			@connection = conn
			@token = login(mail, passwd)
			@headers = {'Content-Type'=>'application/atom+xml', 'Authorization'=> 'GoogleLogin auth='+token}
			return @connection
		end
	
		
	
		# Returns a UserEntry instance from a username
		# 	ex :	
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.retrieve_user('jsmith')
		#			puts "givenName : "+user.given_name
		#			puts "familyName : "+user.family_name
		def retrieve_user(username)
			xml_response = request(:user_retrieve, username, @headers) 
			user_entry = UserEntry.new(xml_response.elements["entry"])
		end
 
		# Returns a UserEntry array populated with all the users in the domain. May take a while depending on the number of users in your domain.
		# 	ex : 	
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			list= myapps.retrieve_all_users
		#			list.each{ |user| puts user.username} 
		#			puts 'nb users : ',list.size
		def retrieve_all_users
			response = request(:user_retrieve_all,nil,@headers)
			user_feed = Feed.new(response.elements["feed"],  UserEntry)
			user_feed = add_next_feeds(user_feed, response, UserEntry)
		end

		# Returns a UserEntry array populated with 100 users, starting from a username
		# 	ex : 	
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			list= myapps.retrieve_page_of_users("jsmtih")
		#  		list.each{ |user| puts user.username}
		def retrieve_page_of_users(start_username)
			param='?startUsername='+start_username
			response = request(:user_retrieve_all,param,@headers)
			user_feed = Feed.new(response.elements["feed"],  UserEntry)
		end
 
		# Creates an account in your domain, returns a UserEntry instance
		# 	params :
		#			username, given_name, family_name and password are required
		#			passwd_hash_function (optional) : nil (default) or "SHA-1"
		#			quota (optional) : nil (default) or integer for limit in MB
		# 	ex : 	
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.create('jsmith', 'John', 'Smith', 'p455wD')
		#
		# By default, a new user must change his password at first login. Please use update_user if you want to change this just after the creation.
		def create_user(username, given_name, family_name, password, passwd_hash_function=nil, quota=nil)
			msg = RequestMessage.new
			msg.about_login(username,password,passwd_hash_function,"false","false", "true")
			msg.about_name(family_name, given_name)
			msg.about_quota(quota.to_s) if quota
			response  = request(:user_create,nil,@headers, msg.to_s)
			user_entry = UserEntry.new(response.elements["entry"])
		end

		# Updates an account in your domain, returns a UserEntry instance
		# 	params :
		#			username is required and can't be updated.
		#			given_name and family_name are required, may be updated.
		#			if set to nil, every other parameter won't update the attribute.
		#				passwd_hash_function :  string "SHA-1", "MD5" or nil (default)
		#				admin :  string "true" or string "false" or nil (no boolean : true or false). 
		#				suspended :  string "true" or string "false" or nil (no boolean : true or false)
		#				change_passwd :  string "true" or string "false" or nil (no boolean : true or false)
		#				quota : limit en MB, ex :  string "2048"
		#		ex :
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.update('jsmith', 'John', 'Smith', nil, nil, "true", nil, "true", nil)
		#			puts user.admin		=> "true"
		def update_user(username, given_name, family_name, password=nil, passwd_hash_function=nil, admin=nil, suspended=nil, changepasswd=nil, quota=nil)
			msg = RequestMessage.new
			msg.about_login(username,password,passwd_hash_function,admin,suspended, changepasswd)
			msg.about_name(family_name, given_name)
			msg.about_quota(quota) if quota
			msg.add_path('https://'+@@google_host+@action[:user_update][:path]+username)
			response  = request(:user_update,username,@headers, msg.to_s)
			user_entry = UserEntry.new(response.elements["entry"])
		end
		
		# Renames a user, returns a UserEntry instance
		#		ex :
		#
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.rename_user('jsmith','jdoe')
		#
		#		It is recommended to log out rhe user from all browser sessions and service before renaming.
		#              Once renamed, the old username becomes a nickname of the new username.
		#		Note from Google: Google Talk will lose all remembered chat invitations after renaming. 
		#		The user must request permission to chat with friends again. 
		# 		Also, when a user is renamed, the old username is retained as a nickname to ensure continuous mail delivery in the case of email forwarding settings. 
		#		To remove the nickname, you should issue an HTTP DELETE to the nicknames feed after renaming.
		def rename_user(username, new_username)
			msg = RequestMessage.new
			msg.about_login(new_username)
			msg.add_path('https://'+@@google_host+@action[:user_rename][:path]+username)
			response  = request(:user_update,username,@headers, msg.to_s)
		end
	
		# Suspends an account in your domain, returns a UserEntry instance
		#		ex :
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.suspend('jsmith')
		#			puts user.suspended		=> "true"
		def suspend_user(username)
			msg = RequestMessage.new
			msg.about_login(username,nil,nil,nil,"true")
			msg.add_path('https://'+@@google_host+@action[:user_update][:path]+username)
			response  = request(:user_update,username,@headers, msg.to_s)
			user_entry = UserEntry.new(response.elements["entry"])
		end

		# Restores a suspended account in your domain, returns a UserEntry instance
		#		ex :
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			user = myapps.restore('jsmith')
		#			puts user.suspended		=> "false"
		def restore_user(username)
			msg = RequestMessage.new
			msg.about_login(username,nil,nil,nil,"false")
			msg.add_path('https://'+@@google_host+@action[:user_update][:path]+username)
			response  = request(:user_update,username,@headers, msg.to_s)
			user_entry = UserEntry.new(response.elements["entry"])
		end

		# Deletes an account in your domain
		#		ex :
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			myapps.delete('jsmith')
		def delete_user(username)
			response  = request(:user_delete,username,@headers)
		end

		# Returns a NicknameEntry instance from a nickname
		# 	ex :	
		#			myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#			nickname = myapps.retrieve_nickname('jsmith')
		#			puts "login : "+nickname.login
		def retrieve_nickname(nickname)
			xml_response = request(:nickname_retrieve, nickname, @headers)
			nickname_entry = NicknameEntry.new(xml_response.elements["entry"])
		end
	
		# Returns a NicknameEntry array from a username
		#	ex : lists jsmith's nicknames
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		# 		mynicks = myapps.retrieve('jsmith')
		#		mynicks.each {|nick| puts nick.nickname }
		def retrieve_nicknames(username)
			xml_response = request(:nickname_retrieve_all_for_user, username, @headers)
			nicknames_feed = Feed.new(xml_response.elements["feed"],  NicknameEntry)
			nicknames_feed = add_next_feeds(nicknames_feed, xml_response, NicknameEntry)
		end
	
		# Returns a NicknameEntry array for the whole domain. May take a while depending on the number of users in your domain.
		#	myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		# 	allnicks = myapps.retrieve_all_nicknames
		# 	allnicks.each {|nick| puts nick.nickname }
		def retrieve_all_nicknames
			xml_response = request(:nickname_retrieve_all_in_domain, nil, @headers)
			nicknames_feed = Feed.new(xml_response.elements["feed"],  NicknameEntry)
			nicknames_feed = add_next_feeds(nicknames_feed, xml_response, NicknameEntry)
		end

		# Creates a nickname for the username in your domain and returns a NicknameEntry instance
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		# 		mynewnick = myapps.create_nickname('jsmith', 'john.smith')
		def create_nickname(username,nickname)
			msg = RequestMessage.new
			msg.about_login(username)
			msg.about_nickname(nickname)
			response  = request(:nickname_create,nil,@headers, msg.to_s)
			nickname_entry = NicknameEntry.new(response.elements["entry"])
		end
		
		# Deletes the nickname  in your domain 
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		# 		myapps.delete_nickname('john.smith')
		def delete_nickname(nickname)
			response  = request(:nickname_delete,nickname,@headers)
		end
	
		# Returns a NicknameEntry array populated with 100 nicknames, starting from a nickname
		# 	ex : 	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		list= myapps.retrieve_page_of_nicknames("joe")
		#  		list.each{ |nick| puts nick.login}
		def retrieve_page_of_nicknames(start_nickname)
			param='?startNickname='+start_nickname
			xml_response = request(:nickname_retrieve_all_in_domain, param, @headers)
			nicknames_feed = Feed.new(xml_response.elements["feed"],  NicknameEntry)
		end
	
		# Deprecated. Please use Group management instead.
		def retrieve_email_lists(email_adress)
			puts("retrieve_email_lists : deprecated. Please use Group management instead.")
		end	  
	
		# Deprecated. Please use Group management instead.
		def retrieve_all_email_lists
			puts("retrieve_all_email_lists : deprecated. Please use Group management instead.")
		end
	
		# Deprecated. Please use Group management instead.
		def retrieve_page_of_email_lists(start_listname)
			puts("retrieve_page_of_email_lists : deprecated. Please use Group management instead.")
		end
		
		# Deprecated. Please use Group management instead.
		def create_email_list(name)
			puts("create_email_list : deprecated. Please use Group management instead.")
		end

		# Deprecated. Please use Group management instead.
		def delete_email_list(name)
			puts("delete_email_list : deprecated. Please use Group management instead.")
		end
	
		# Deprecated. Please use Group management instead.
		def retrieve_all_recipients(email_list)
			puts("retrieve_all_recipients : deprecated. Please use Group management instead.")
		end
	
		# Deprecated. Please use Group management instead.
		def retrieve_page_of_recipients(email_list, start_recipient)
			puts("Deprecated. Please use Group management instead.")
		end
	
		# Deprecated. Please use Group management instead.
		def add_address_to_email_list(email_list,address)
			puts("add_address_to_email_list : deprecated. Please use Group management instead.")
		end
	
		# Deprecated. Please use Group management instead.
		def remove_address_from_email_list(address,email_list)
			puts("remove_address_from_email_list : deprecated. Please use Group management instead.")
		end
               
		# Creates a group in your domain and returns a GroupEntry (ATTENTION: the group name is necessary!).
		# 	ex : 	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		group= myapps.create_group("mygroup", ["My Group name", "My Group description", "<emailPermission>"]) 
		def create_group(group_id, properties)
			msg = RequestMessage.new
			msg.about_group(group_id, properties)
			response  = request(:group_create, nil, @headers, msg.to_s)
			group_entry = GroupEntry.new(response.elements["entry"])
		end

		# Updates a group in your domain and returns a GroupEntry (ATTENTION: the group name is necessary!).
		# 	ex : 	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		group= myapps.update_group("mygroup", ["My Group name", "My Group description", "<emailPermission>"]) 
		def update_group(group_id, properties)
			msg = RequestMessage.new
			msg.about_group(group_id, properties)
			response  = request(:group_update, group_id, @headers, msg.to_s)
			group_entry = GroupEntry.new(response.elements["entry"])
		end

		# Deletes a group in your domain.
		# 	ex : 	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		myapps.delete_group("mygroup")
		def delete_group(group_id)
			response  = request(:group_delete,group_id,@headers)
		end

		# Returns a GroupEntry array for a particular member of the domain (ATTENTION: it doesn't work for members of other domains!).
                # The user parameter can be a complete email address or can be written without "@mydomain.com".
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		mylists = myapps.retrieve_groups('jsmith')   # you can search for 'jsmith@mydomain.com' too
		# 		mylists.each {|list| puts list.group_id }
		def retrieve_groups(user)
			xml_response = request(:groups_retrieve, user, @headers)
			list_feed = Feed.new(xml_response.elements["feed"], GroupEntry) 
			list_feed = add_next_feeds(list_feed, xml_response, GroupEntry)
		end	  

		# Returns a GroupEntry array for the whole domain.
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		all_lists = myapps.retrieve_all_groups
		# 		all_lists.each {|list| puts list.group_id }
		def retrieve_all_groups
			xml_response = request(:all_groups_retrieve, nil, @headers)
			list_feed = Feed.new(xml_response.elements["feed"], GroupEntry) 
			list_feed = add_next_feeds(list_feed, xml_response, GroupEntry)
		end
	
		# Adds an email address (user or group) to a mailing list in your domain and returns a MemberEntry instance.
		# You can add addresses from other domains to your mailing list.  Omit "@mydomain.com" in the group name.
		#	ex :
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		new_member = myapps.add_member_to_group('example@otherdomain.com', 'mygroup')
		def add_member_to_group(email_address, group_id)
			msg = RequestMessage.new
			msg.about_member(email_address)
			response  = request(:membership_add, group_id+'/member', @headers, msg.to_s)
			member_entry = MemberEntry.new(response.elements["entry"])
		end
	
		# Removes an email address (user or group) from a mailing list. Omit "@mydomain.com" in the group name.
		# 	ex :
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		myapps.remove_member_from_group('example@otherdomain.com', 'mygroup')
		def remove_member_from_group(email_address, group_id)
			response  = request(:membership_remove, group_id+'/member/'+email_address,@headers)
		end

		# Returns true if the email address (user or group) is member of the group, false otherwise.
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		boolean = myapps.is_member('example@otherdomain.com', 'mylist')
		def is_member(email_address, group_id)
			xml_response = request(:membership_confirm, group_id+'/member/'+email_address, @headers)
                        # if the email_address is not member of the group, an error is raised, otherwise true is returned 
                        return true

                        rescue GDataError => e
                        return false if e.reason.eql?("EntityDoesNotExist")
		end

		# Returns a MemberEntry array with the members of a group.
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		list = myapps.retrieve_all_members('mygroup')
		# 		lists.each {|list| puts list.member_id }
		def retrieve_all_members(group_id)
			xml_response = request(:all_members_retrieve, group_id+'/member', @headers)
			list_feed = Feed.new(xml_response.elements["feed"], MemberEntry)
			list_feed = add_next_feeds(list_feed, xml_response, MemberEntry)
		end
	
		# Adds a owner (user or group) to a mailing list in your domain and returns a OwnerEntry instance.
		# You can add addresses from other domains to your mailing list.  Omit "@mydomain.com" in the group name.
                # ATTENTION: a owner is added only if it's already member of the group, otherwise no action is done!
		#	ex :
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		new_member = myapps.add_owner_to_group('example@otherdomain.com', 'mygroup')
		def add_owner_to_group(email_address, group_id)
			msg = RequestMessage.new
			msg.about_owner(email_address)
			response  = request(:ownership_add, group_id+'/owner', @headers, msg.to_s)
			owner_entry = OwnerEntry.new(response.elements["entry"])
		end
	
		# Removes an owner from a mailing list. Omit "@mydomain.com" in the group name.
                # ATTENTION: when a owner is removed, it loses the privileges but still remains member of the group!
		# 	ex :
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		myapps.remove_owner_from_group('example@otherdomain.com', 'mygroup')
		def remove_owner_from_group(email_address, group_id)
			response  = request(:ownership_remove, group_id+'/owner/'+email_address,@headers)
		end

		# Returns true if the email address (user or group) is owner of the group, false otherwise.
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		boolean = myapps.is_owner('example@otherdomain.com', 'mylist')
		def is_owner(email_address, group_id)
			xml_response = request(:ownership_confirm, group_id+'/owner/'+email_address, @headers)
                        # if the email_address is not member of the group, an error is raised, otherwise true is returned 
                        return true

                        rescue GDataError => e
                        return false if e.reason.eql?("EntityDoesNotExist")
		end

		# Returns a OwnerEntry array with the owners of a group.
		# 	ex :	
		#		myapps = ProvisioningApi.new('root@mydomain.com','PaSsWoRd')
		#		list = myapps.retrieve_all_owners('mygroup')
		# 		lists.each {|list| puts list.owner_id }
		def retrieve_all_owners(group_id)
			xml_response = request(:all_owners_retrieve, group_id+'/owner', @headers)
			list_feed = Feed.new(xml_response.elements["feed"], OwnerEntry)
			list_feed = add_next_feeds(list_feed, xml_response, OwnerEntry)
		end
	
		# Aliases
		alias createUser create_user
		alias retrieveUser retrieve_user
		alias retrieveAllUsers retrieve_all_users
		alias retrievePageOfUsers retrieve_page_of_users
		alias updateUser update_user
		alias renameUser rename_user
		alias suspendUser suspend_user
		alias restoreUser restore_user
		alias deleteUser delete_user
		alias createNickname create_nickname
		alias retrieveNickname retrieve_nickname
		alias retrieveNicknames retrieve_nicknames
		alias retrieveAllNicknames retrieve_all_nicknames
		alias retrievePageOfNicknames retrieve_page_of_nicknames
		alias deleteNickname delete_nickname
		alias retrieveAllRecipients retrieve_all_recipients
		alias retrievePageOfRecipients retrieve_page_of_recipients
		alias removeRecipientFromEmailList remove_address_from_email_list        
                alias createGroup create_group
                alias updateGroup update_group
                alias deleteGroup delete_group
                alias retrieveGroups retrieve_groups
                alias retrieveAllGroups retrieve_all_groups
                alias addMemberToGroup add_member_to_group
                alias removeMemberFromGroup remove_member_from_group
                alias isMember is_member
                alias retrieveAllMembers retrieve_all_members
                alias addOwnerToGroup add_owner_to_group
                alias removeOwnerFromGroup remove_owner_from_group
                alias isOwner is_owner
                alias retrieveAllOwners retrieve_all_owners


		# private methods
		private #:nodoc:
		
		# Associates methods, http verbs and URL for REST access
		def setup_actions(domain)
			path_user = '/a/feeds/'+domain+'/user/2.0'
			path_nickname = '/a/feeds/'+domain+'/nickname/2.0'
			path_group = '/a/feeds/group/2.0/'+domain # path for Google groups

			action = Hash.new
			action[:domain_login] = {:method => 'POST', :path => '/accounts/ClientLogin' }
			action[:user_create] = { :method => 'POST', :path => path_user }
			action[:user_retrieve] = { :method => 'GET', :path => path_user+'/' }
			action[:user_retrieve_all] = { :method => 'GET', :path => path_user } 
			action[:user_update] = { :method => 'PUT', :path => path_user +'/' }
			action[:user_rename] = { :method => 'PUT', :path => path_user +'/' }
			action[:user_delete] = { :method => 'DELETE', :path => path_user +'/' }
			action[:nickname_create] = { :method => 'POST', :path =>path_nickname }
			action[:nickname_retrieve] = { :method => 'GET', :path =>path_nickname+'/' }
			action[:nickname_retrieve_all_for_user] = { :method => 'GET', :path =>path_nickname+'?username=' }
			action[:nickname_retrieve_all_in_domain] = { :method => 'GET', :path =>path_nickname }
			action[:nickname_delete] = { :method => 'DELETE', :path =>path_nickname+'/' }
			action[:group_create] = { :method => 'POST', :path =>path_group }
			action[:group_update] = { :method => 'PUT', :path =>path_group+'/' }
			action[:group_delete] = { :method => 'DELETE', :path =>path_group+'/' }
			action[:groups_retrieve] = { :method => 'GET', :path =>path_group+'?member=' }
			action[:all_groups_retrieve] = { :method => 'GET', :path =>path_group }
			action[:membership_add] = { :method => 'POST', :path =>path_group+'/' }
			action[:membership_remove] = { :method => 'DELETE', :path =>path_group+'/' }
			action[:membership_confirm] = { :method => 'GET', :path =>path_group+'/' }
			action[:all_members_retrieve] = { :method => 'GET', :path =>path_group+'/' }
			action[:ownership_add] = { :method => 'POST', :path =>path_group+'/' }
			action[:ownership_remove] = { :method => 'DELETE', :path =>path_group+'/' }
			action[:ownership_confirm] = { :method => 'GET', :path =>path_group+'/' }
			action[:all_owners_retrieve] = { :method => 'GET', :path =>path_group+'/' }
	
			# special action "next" for linked feed results. :path will be affected with URL received in a link tag.
			action[:next] = {:method => 'GET', :path =>nil }
			return action  	
		end		
	
		# Sends credentials and returns an authentication token
		def login(mail, passwd)
			request_body = '&Email='+CGI.escape(mail)+'&Passwd='+CGI.escape(passwd)+'&accountType=HOSTED&service=apps'
			res = request(:domain_login, nil, {'Content-Type'=>'application/x-www-form-urlencoded'}, request_body)
			return /^Auth=(.+)$/.match(res.to_s)[1]
			# res.to_s needed, because res.class is REXML::Document
		end
	

	        # Completes the feed by following et requesting the URL links
		def add_next_feeds(current_feed, xml_content, element_class)
			xml_content.elements.each("feed/link") {|link|
			if link.attributes["rel"] == "next"
				@action[:next] = {:method => 'GET', :path=> link.attributes["href"]}
				next_response = request(:next,nil,@headers)
				current_feed.concat(Feed.new(next_response.elements["feed"], element_class))
				current_feed = add_next_feeds(current_feed, next_response, element_class)
			end
			}
			return current_feed
		end

		# Perfoms a REST request based on the action hash (cf setup_actions)
		# ex : request (:user_retrieve, 'jsmith') sends a http GET www.google.com/a/feeds/domain/user/2.0/jsmith	
		# returns  REXML Document
		def request(action, value=nil, header=nil, message=nil)
			#param value : value to be concatenated to action path ex: GET host/path/value
			method = @action[action][:method]
			value = '' if !value
			path = @action[action][:path]+value
			response = @connection.perform(method, path, message, header)
			response_xml = Document.new(response.body)
			test_errors(response_xml)
			return response_xml
		end

		# parses xml response for an API error tag. If an error, constructs and raises a GDataError.
		def test_errors(xml)
			error = xml.elements["AppsForYourDomainErrors/error"]
			if  error
			gdata_error = GDataError.new
			gdata_error.code = error.attributes["errorCode"]
			gdata_error.input = error.attributes["invalidInput"]
			gdata_error.reason = error.attributes["reason"]
			msg = "error code : "+gdata_error.code+", invalid input : "+gdata_error.input+", reason : "+gdata_error.reason
			raise gdata_error, msg
			end
		end
	end


	# UserEntry object.
	#
	# Handles API responses relative to a user
	#
	# Attributes :
	#	username : string
	#	given_name : string
	#	family_name : string
	#	suspended : string "true" or string "false"
	#	ip_whitelisted : string "true" or string "false"
	#	admin : string "true" or string "false"
	#	change_password_at_next_login : string "true" or string "false"
	#	agreed_to_terms : string "true" or string "false"
	#	quota_limit : string (value in MB)
	class UserEntry  
	attr_reader :given_name, :family_name, :username, :suspended, :ip_whitelisted, :admin, :change_password_at_next_login, :agreed_to_terms, :quota_limit
	
		# UserEntry constructor. Needs a REXML::Element <entry> as parameter
		def initialize(entry) #:nodoc:
			@family_name = entry.elements["apps:name"].attributes["familyName"]
			@given_name = entry.elements["apps:name"].attributes["givenName"]
			@username = entry.elements["apps:login"].attributes["userName"]
			@suspended = entry.elements["apps:login"].attributes["suspended"]
			@ip_whitelisted = entry.elements["apps:login"].attributes["ipWhitelisted"]
			@admin = entry.elements["apps:login"].attributes["admin"]
			@change_password_at_next_login = entry.elements["apps:login"].attributes["changePasswordAtNextLogin"]
			@agreed_to_terms = entry.elements["apps:login"].attributes["agreedToTerms"]
			@quota_limit = entry.elements["apps:quota"].attributes["limit"]
		end
	end


	# NicknameEntry object.
	#
	# Handles API responses relative to a nickname
	#
	# Attributes :
	#	login : string
	#	nickname : string
	class NicknameEntry
	attr_reader :login, :nickname
	
		# NicknameEntry constructor. Needs a REXML::Element <entry> as parameter
		def initialize(entry) #:nodoc:
		@login = entry.elements["apps:login"].attributes["userName"]
		@nickname = entry.elements["apps:nickname"].attributes["name"]
		end	
	end


	# UserFeed object : Array populated with Element_class objects (UserEntry, NicknameEntry, EmailListEntry or EmailListRecipientEntry)
	class Feed < Array #:nodoc:
	
		# UserFeed constructor. Populates an array with Element_class objects. Each object is an xml <entry> parsed from the REXML::Element <feed>.
		# Ex : user_feed = Feed.new(xml_feed, UserEntry)
		#	    	nickname_feed = Feed.new(xml_feed, NicknameEntry)
		def initialize(xml_feed, element_class)
			xml_feed.elements.each("entry"){ |entry| self << element_class.new(entry) }
		end
	end



	# GroupEntry object.
	#
	# Handles API responses relative to a group.
	#
	# Attributes :
	#	group_id : string . The group_id is written without "@" and everything following.
	class GroupEntry
	attr_reader :group_id
	
		# GroupEntry constructor. Needs a REXML::Element <entry> as parameter
		def initialize(entry) #:nodoc:
		entry.elements.each("apps:property"){ |e| @group_id = e.attributes["value"] if e.attributes["name"].eql?("groupId") }
		end	
	end


	# MemberEntry object.
	#
	# Handles API responses relative to a meber of a group.
	#
	# Attributes :
	#	member_id : string . The member_id is a complete email address.
	class MemberEntry
	attr_reader :member_id
	
		# MemberEntry constructor. Needs a REXML::Element <entry> as parameter
		def initialize(entry) #:nodoc:
		entry.elements.each("apps:property"){ |e| @member_id = e.attributes["value"] if e.attributes["name"].eql?("memberId") }
		end	
	end


	# OwnerEntry object.
	#
	# Handles API responses relative to a owner of a group.
	#
	# Attributes :
	#	owner_id : string . The owner_id is a complete email address.
	class OwnerEntry
	attr_reader :owner_id
	
		# OwnerEntry constructor. Needs a REXML::Element <entry> as parameter
		def initialize(entry) #:nodoc:
		entry.elements.each("apps:property"){ |e| @owner_id = e.attributes["value"] if e.attributes["name"].eql?("email") }
		end	
	end


	class RequestMessage < Document #:nodoc:
		# Request message constructor.
		# parameter type : "user", "nickname" or "emailList"  
		
		# creates the object and initiates the construction
		def initialize
			super '<?xml version="1.0" encoding="UTF-8"?>' 
			self.add_element "atom:entry", {"xmlns:apps" => "http://schemas.google.com/apps/2006",
								"xmlns:gd" => "http://schemas.google.com/g/2005",
								"xmlns:atom" => "http://www.w3.org/2005/Atom"}
			self.elements["atom:entry"].add_element "atom:category", {"scheme" => "http://schemas.google.com/g/2005#kind"}
		end
 
		# adds <atom:id> element in the message body. Url is inserted as a text.
		def add_path(url)
			self.elements["atom:entry"].add_element "atom:id"
			self.elements["atom:entry/atom:id"].text = url
		end
 
		# adds <apps:emailList> element in the message body.
		def about_email_list(email_list)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#emailList")
			self.elements["atom:entry"].add_element "apps:emailList", {"name" => email_list } 
		end
 
		# adds <apps:property> element in the message body for a group.
		def about_group(group_id, properties)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#emailList")
			self.elements["atom:entry"].add_element "apps:property", {"name" => "groupId", "value" => group_id } 
			self.elements["atom:entry"].add_element "apps:property", {"name" => "groupName", "value" => properties[0] } 
			self.elements["atom:entry"].add_element "apps:property", {"name" => "description", "value" => properties[1] } 
			self.elements["atom:entry"].add_element "apps:property", {"name" => "emailPermission", "value" => properties[2] } 
		end

		# adds <apps:property> element in the message body for a member.
		def about_member(email_address)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#user")
			self.elements["atom:entry"].add_element "apps:property", {"name" => "memberId", "value" => email_address } 
                end
 
		# adds <apps:property> element in the message body for an owner.
		def about_owner(email_address)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#user")
			self.elements["atom:entry"].add_element "apps:property", {"name" => "email", "value" => email_address } 
                end


		# adds <apps:login> element in the message body.
		# warning : if valued admin, suspended, or change_passwd_at_next_login must be the STRINGS "true" or "false", not the boolean true or false
		# when needed to construct the message, should always been used before other "about_" methods so that the category tag can be overwritten
		# only values permitted for hash_function_function_name : "SHA-1", "MD5" or nil
		def about_login(user_name, passwd=nil, hash_function_name=nil, admin=nil, suspended=nil, change_passwd_at_next_login=nil)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#user")
			self.elements["atom:entry"].add_element "apps:login", {"userName" => user_name } 
			self.elements["atom:entry/apps:login"].add_attribute("password", passwd) if not passwd.nil?
			self.elements["atom:entry/apps:login"].add_attribute("hashFunctionName", hash_function_name) if not hash_function_name.nil?
			self.elements["atom:entry/apps:login"].add_attribute("admin", admin) if not admin.nil?
			self.elements["atom:entry/apps:login"].add_attribute("suspended", suspended) if not suspended.nil?
			self.elements["atom:entry/apps:login"].add_attribute("changePasswordAtNextLogin", change_passwd_at_next_login) if not change_passwd_at_next_login.nil?
			return self
		end
	 
		# adds <apps:quota> in the message body.
		# limit in MB: integer
		def about_quota(limit)
			self.elements["atom:entry"].add_element "apps:quota", {"limit" => limit }  
			return self
		end	   
 
		# adds <apps:name> in the message body.
		def about_name(family_name, given_name)
			self.elements["atom:entry"].add_element "apps:name", {"familyName" => family_name, "givenName" => given_name } 
			return self
		end

		# adds <apps:nickname> in the message body.
		def about_nickname(name)
			self.elements["atom:entry/atom:category"].add_attribute("term", "http://schemas.google.com/apps/2006#nickname")
			self.elements["atom:entry"].add_element "apps:nickname", {"name" => name} 
			return self
		end
 
		# adds <gd:who> in the message body.
		def about_who(email)
			self.elements["atom:entry"].add_element "gd:who", {"email" => email } 
			return self
		end
		
	end

end
