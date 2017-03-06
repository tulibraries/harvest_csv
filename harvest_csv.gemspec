Gem::Specification.new do |s|
  s.name = "harvest_csv"
  s.version = HarvestCSV::VERSION
  s.authors = ["Steven Ng"]
  s.date = %q{2014-02-22}
  s.description = "HarvestCSV - Ingests CSV files into Solr"
  s.summary = "Import CSV to Solr"
  s.email = "steven.ng@temple.edu"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.homepage = 'https://github.com/tulibraries/harvest_csv'

  s.add_runtime_dependency 'rsolr', '~> 1.0'
  s.add_runtime_dependency 'ruby-progressbar', '~> 1.8' 
  s.add_runtime_dependency 'activesupport', '~> 5.0'
end
