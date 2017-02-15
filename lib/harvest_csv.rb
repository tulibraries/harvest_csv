require 'rubygems'
require 'csv'
require 'rsolr'
require 'pry'

def csv_to_solr(csv_hash, schema_map)
  document = Hash.new
  csv_hash.each { |key, value|
    solr_fields = schema_map[key]
    solr_fields.each {|solr_field|
      document[solr_field] = value
    }
  }
  document
end

def harvest_csv(csv_source,
                schema_map,
                solr_endpoint = 'http://localhost:8983/solr/blacklight-core')
  CSV.open(csv_source, headers: true) do |csv|
    solr = RSolr.connect url: solr_endpoint
    csv.each do |row|
      document = csv_to_solr(row.to_h, schema_map)
      solr.add document
      solr.commit
    end
  end
end
