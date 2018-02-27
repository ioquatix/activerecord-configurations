#!/usr/bin/env ruby

# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require 'active_record'
require 'active_record/configurations'

describe ActiveRecord::Configurations do
	let(:model) do
		Class.new(ActiveRecord::Base) do
			self.abstract_class = true
			
			extend ActiveRecord::Configurations
		end
	end
	
	it "should define a default configuration" do
		expect(model.environments).to include(:default)
		expect(model.configurations).to include("default")
	end
	
	it "should define a new configuration using a DSN defined from the environment" do
		ENV['BUSINESS_DSN'] = 'postgres://bob:p4ssw0rd@example.com/lots_of_data'
		
		model.configure(:production) do
			prefix 'business'
		end
		
		expect(model.configurations).to include("production")
		
		configuration = model.configurations["production"]
		expect(configuration['adapter']).to be == 'postgresql'
		expect(configuration['username']).to be == 'bob'
		expect(configuration['password']).to be == 'p4ssw0rd'
		expect(configuration['database']).to be == 'lots_of_data'
	end
	
	it "should use defaults" do
		model.configure(:production) do
			prefix 'recipes'
			adapter 'postgresql'
		end
		
		expect(model.configurations).to include("production")
		
		configuration = model.configurations["production"]
		expect(configuration['adapter']).to be == 'postgresql'
		expect(configuration['username']).to be_nil
		expect(configuration['password']).to be_nil
		expect(configuration['database']).to be == 'recipes_production'
	end
end
