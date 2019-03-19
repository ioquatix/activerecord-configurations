# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'configurations/version'

require 'build/environment'
require 'active_record'

module ActiveRecord
	class Base
		# This is a quick hack to work around https://github.com/rails/rails/pull/32135
		def self.establish_connection(config = nil)
			raise "Anonymous class is not allowed." unless name
	
			config ||= DEFAULT_ENV.call.to_sym
			spec_name = self == Base ? "primary" : name
			self.connection_specification_name = spec_name
			
			# Because of YAML, the config name must be a String.
			# Because I think this is slightly stupid, I turn everything back into symbols.
			spec = self.configurations.fetch(config.to_s, config).symbolize_keys
			
			spec[:name] = spec_name
			
			connection_handler.establish_connection(spec)
		end
	end
	
	module Configurations
		def self.extended(child)
			child.instance_variable_set(:@environments, {})
			child.instance_variable_set(:@configurations, {})
			
			# This is needed to explicitly override the behaviour provided by ActiveRecord::Core.
			def child.configurations
				instance_variable_get(:@configurations)
			end
			
			def child.configurations= value
				instance_variable_set(:@configurations, value)
			end
			
			# Remove the shitty "default"
			child.configurations.delete("default_env")
			
			# Add one that makes sense:
			child.configure(:default) do
				# The provided uri overrides other options.
				dsn ->{ENV[prefix.upcase + "_DSN"]}
				database ->{prefix + "_#{name}"}
				
				host 'localhost'
				prefix 'database'
			end
		end

		attr :environments
		attr :configurations
		
		def resolve_database_dsn(string, environment)
			uri = URI.parse(string)
			
			case uri.scheme
			when 'postgres'
				environment[:adapter] = 'postgresql'
			when 'mysql'
				environment[:adapter] = 'mysql2'
			else
				environment[:adapter] = uri.scheme
			end
			
			if username = uri.user
				environment[:username] = username
			end
			
			if password = uri.password
				environment[:password] = password
			end
			
			if host = uri.host
				environment[:host] = host
			end
			
			if port = uri.port
				environment[:port] = port
			end
			
			if path = uri.path
				# The path should always be relative:
				environment[:database] = path.sub(/^\//, '')
			end
		end
		
		def lookup_environment(name)
			return nil unless name
			
			if environment = self.environments[name]
				environment
			# elsif self.superclass
			# 	self.superclass.lookup_environment(name)
			end
		end
		
		def configuration? name
			self.configurations.include? name.to_s
		end
		
		def requires_connection? name
			if self.connected?
				return false
			end
			
			return self.configuration?(name)
		end
		
		def setup_connection(name = DATABASE_ENV)
			if requires_connection?(name)
				self.establish_connection(name)
			end
		end
		
		def configure(name, parent: :default, **options, &block)
			parent = self.lookup_environment(parent)
			
			environment = Build::Environment.new(parent, {name: name.to_s}, name: name, **options, &block)
			
			self.environments[name] = environment
			
			configuration = environment.to_h
			
			if dsn = configuration[:dsn]
				resolve_database_dsn(dsn, configuration)
			end
			
			self.configurations[name.to_s] = configuration.stringify_keys
		end
	end
end
