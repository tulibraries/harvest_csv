require_relative 'lib/harvest_csv'

task default: %[ingest]

desc "Ingest a CSV file"
task :ingest do
  Rake::FileList.new("*.csv") do |fl|
    fl.each { |f| HarvestCSV.harvest(f) }
  end

end

desc "Create a Solr mapping file from a CSV file header"
task :makemap do

end
