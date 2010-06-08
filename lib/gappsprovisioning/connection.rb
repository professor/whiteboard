#!/usr/bin/ruby
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
require 'net/https'
require 'cgi'

module GAppsProvisioning #:nodoc:
	class Connection
	attr_reader  :http_connection
	
		# Establishes SSL connection to Google host
		def initialize(host, port, proxy=nil, proxy_port=nil, proxy_user=nil, proxy_passwd=nil)
			conn = Net::HTTP.new(host, port, proxy, proxy_port, proxy_user, proxy_passwd)
			conn.use_ssl = true
			#conn.enable_post_connection_check=  true
			#conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
			conn.verify_mode = OpenSSL::SSL::VERIFY_NONE 
			# uncomment the previous line at your own risk : the certificate won't be verified !
			store = OpenSSL::X509::Store.new
			store.set_default_paths
			conn.cert_store = store
			conn.start
			@http_connection = conn
		end
	
		# Performs the http request and returns the http response
		def perform(method, path, body=nil, header=nil)
			req = Net::HTTPGenericRequest.new(method, !body.nil?, true, path)
			req['Content-Type'] = header['Content-Type'] if header['Content-Type']
			req['Authorization'] = header['Authorization'] if header['Authorization']
			req['Content-length'] = body.length.to_s if body
			resp = @http_connection.request(req, body)
			return resp
		end
	end
end