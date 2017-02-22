require_relative "lib/harvest_csv/version"

Gem::Specification.new do |s|
  s.name = "harvest_csv"
  s.version = HarvestCSV::VERSION
  s.authors = ["Steven Ng"]
  s.date = %q{2014-02-22}
  s.description = "HarvestCSV - Ingests CSV files into Solr"
  s.summary = s.description
  s.email = "steven.ng@temple.edu"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rsolr', '~> 1.0'
  s.add_runtime_dependency 'ruby-progressbar'
  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end
