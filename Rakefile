require_relative 'lib/harvest_csv'

namespace :blimp do
  desc "Ingest a CSV file"
  task :ingest do
    Rake::FileList.new("*.csv") do |fl|
      fl.each { |f| HarvestCSV.harvest(f) }
    end
  end

  desc "Create a solr mapping file from a csv file header"
  task :makemap, [:id_field] do |t, args|
    map_file = File.open("solr_map.yml", "w")
    id_field = args.has_key?(:id_field) ? args[:id_field] : 'ID'
    Rake::FileList.new("*.csv") do |fl|
      HarvestCSV.make_map(fl.first, map_file, id_field)
    end
  end

  desc "Create Blacklight catalog partials from solr mapping file"
  task :blacklight do
    Rake::FileList.new("*_map.yml") do |fl|
      HarvestCSV.blacklight(fl.first)
    end
  end
end
