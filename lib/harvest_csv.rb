require 'rubygems'
require 'csv'
require 'rsolr'
require 'pry'
require 'yaml'
require 'securerandom'

module HarvestCSV
  def self.csv_to_solr(csv_hash, schema_map)
    document = Hash.new
    document["id"] = SecureRandom.uuid
    csv_hash.each { |key, value|
      if (schema_map.has_key?(key))
        solr_fields = schema_map[key]
        solr_fields.each {|solr_field|
          document[solr_field] = value
        }
      end
    }
    document
  end

  def self.harvest(csv_source,
                   map_source = './solr_map.yml',
                   solr_endpoint = 'http://localhost:8983/solr/blacklight-core' )
    schema_map = YAML.load_file(map_source)
    solr = RSolr.connect url: solr_endpoint
    CSV.open(csv_source, headers: true) do |csv|
      csv.each do |row|
        document = csv_to_solr(row.to_h, schema_map)
        solr.add(document)
      end
    end
    solr.commit
  end
end
