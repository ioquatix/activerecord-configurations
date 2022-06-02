# frozen_string_literal: true

require_relative "lib/active_record/configurations/version"

Gem::Specification.new do |spec|
	spec.name = "activerecord-configurations"
	spec.version = ActiveRecord::Configurations::VERSION
	
	spec.summary = "Simplified multi-DSN configuration for ActiveRecord 5+"
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/activerecord-configurations"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{gems,lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.add_dependency "activerecord", ">= 5.0"
	spec.add_dependency "build-environment", "~> 1.3"
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
	spec.add_development_dependency "sqlite3"
end
