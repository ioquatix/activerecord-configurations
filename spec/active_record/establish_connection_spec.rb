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

class Parent < ActiveRecord::Base
	extend ActiveRecord::Configurations
	
	configure(:test) do
		adapter 'sqlite3'
		database 'parent.sqlite3'
	end
end

class Child < ActiveRecord::Base
	extend ActiveRecord::Configurations
	
	configure(:test) do
		adapter 'sqlite3'
		database 'child.sqlite3'
	end
end

describe ActiveRecord::Configurations do
	it "should establish connection" do
		expect(Parent).to_not be_connected
		expect(Child).to_not be_connected
		
		Parent.setup_connection(:test)
		Parent.connection
		
		expect(Parent).to be_connected
		expect(Child).to_not be_connected
		
		Child.setup_connection(:test)
		Child.connection
		expect(Child).to be_connected
		
		expect(Parent.connection_config[:database]).to be == "parent.sqlite3"
		expect(Child.connection_config[:database]).to be == "child.sqlite3"
	end
end
