$:.push File.expand_path("../lib", __FILE__)

require "version"

Gem::Specification.new do |s|
  s.name = 'harvest_csv'
  s.version = HarvestCSV::VERSION
  s.executables << 'csv2solr'
  s.authors = ["Steven Ng"]
  s.date = %q{2017-06-15}
  s.description = "HarvestCSV - Ingests CSV files into Solr"
  s.summary = "Import CSV to Solr"
  s.email = "steven.ng@temple.edu"
  s.files = `git ls-files`.split("\n")
  s.bindir = "bin"
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/tulibraries/harvest_csv'

  s.add_runtime_dependency 'rsolr', '~> 2.5'
  s.add_runtime_dependency 'ruby-progressbar', '~> 1.8' 
  s.add_runtime_dependency 'activesupport', '>= 5', '< 8'
end
