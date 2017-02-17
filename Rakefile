require_relative 'lib/harvest_csv'

task default: %[ingest]

desc "Ingest a CSV file"
task :ingest do
  Rake::FileList.new("*.csv") do |fl|
    fl.each { |f| HarvestCSV.harvest(f) }
  end
end

desc "create a solr mapping file from a csv file header"
task :makemap do
  Rake::FileList.new("*.csv") do |fl|
    HarvestCSV.make_map(fl.first)
  end
end

desc "create Blacklight catalog partials from solr mapping file"
task :blacklight do
  Rake::FileList.new("*_map.yml") do |fl|
    HarvestCSV.blacklight(fl.first)
  end
end
