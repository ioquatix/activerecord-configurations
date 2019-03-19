
require_relative 'lib/active_record/configurations/version'

Gem::Specification.new do |spec|
	spec.name          = "activerecord-configurations"
	spec.version       = ActiveRecord::Configurations::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{Simplified multi-DSN configuration for ActiveRecord 5+}
	spec.homepage      = "https://github.com/ioquatix/activerecord-configurations"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency "activerecord", ">= 5.0"

	spec.add_dependency "build-environment", "~> 1.3"

	spec.add_development_dependency "sqlite3", "~> 1.3.6"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
