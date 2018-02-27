# ActiveRecord::Configurations

This gem replaces the default ActiveRecord configurations system which typically involves a YAML file.

[![Build Status](https://secure.travis-ci.org/ioquatix/activerecord-configurations.svg)](http://travis-ci.org/ioquatix/activerecord-configurations)
[![Code Climate](https://codeclimate.com/github/ioquatix/activerecord-configurations.svg)](https://codeclimate.com/github/ioquatix/activerecord-configurations)
[![Coverage Status](https://coveralls.io/repos/ioquatix/activerecord-configurations/badge.svg)](https://coveralls.io/r/ioquatix/activerecord-configurations)

## Motivation

The standard YAML file technique of specifying database configurations is cumbersome at best, and really only works well for a single database connection: there is no isolation between different sets of connections, and it's not possible to specify multiple `DATABASE_URL` values.

We needed something to streamline and minimize the amount of configuration in this sensitive area of deployment. Making a mistake in a production system is a big problem. This is achieved by testing and convention over configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-configurations'
```

## Usage

Add something like this to `db/environment.rb`

```ruby
require 'active_record/configurations'

class ActiveRecord::Base
	extend ActiveRecord::Configurations
	
	configure(:production) do
		prefix 'library'
		adapter 'postgres'
	end

	configure(:development, parent: :production)
end

# pp ActiveRecord::Base.configurations
```

This will setup the `development` and `production` configurations, which can be overridden by specifying the `LIBRARY_DSN` environment variable.

### Multiple Databases

You can easily have more than one database connection.

```ruby
class UsersModel < ActiveRecord::Base
	self.abstract_class = true
	
	extend ActiveRecord::Configurations
	
	configure(:production) do
		prefix 'users'
		adapter 'mysql2'
	end

	configure(:development, parent: :production)
end

# pp UsersModel.configurations

class User < UsersModel
	# ...
end
```

As this has a different prefix, the connection can be overridden by specifying `USERS_DSN`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## See Also

- [ActiveRecord::Rack](https://github.com/ioquatix/activerecord-rack)
- [ActiveRecord::Migrations](https://github.com/ioquatix/activerecord-migrations)

## License

Released under the MIT license.

Copyright, 2018, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

