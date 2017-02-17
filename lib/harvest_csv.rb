require 'rubygems'
require 'csv'
require 'rsolr'
require 'pry'
require 'yaml'
require 'securerandom'
require 'active_support/core_ext/string'

module HarvestCSV
  def self.csv_to_solr(csv_hash, schema_map)
    document = Hash.new
    document["id"] = SecureRandom.uuid
    csv_hash.each { |key, value|
      k = key.parameterize.underscore
      if (schema_map.has_key?(k))
        solr_fields = schema_map[k]
        solr_fields.each {|solr_field|
          document[solr_field] = value
        }
      end
    }
    document
  end

  def self.harvest(csv_source,
                   map_source = 'solr_map.yml',
                   solr_endpoint = 'http://localhost:8983/solr/blacklight-core' )
    schema_map = YAML.load_file(map_source)
    solr = RSolr.connect url: solr_endpoint
    CSV.open(csv_source, headers: true) do |csv|
      csv.each do |row|
        document = csv_to_solr(row.to_h, schema_map)
        solr.add(document)
        solr.commit
      end
    end
  end

  def self.make_map(csv_source,
                    map_file = 'solr_map.yml')
    schema_map = Hash.new
    CSV.open(csv_source, headers: true) do |csv|
      csv.first
      csv.headers.each do |field_name|
        field = a.parameterize.underscore
        schema_map[field] = ["#{field.downcase}_display"]
      end
    end
    YAML.dump(schema_map, File.new(map_file, 'w'))
  end

  def self.get_blacklight_add_fields(schema_map, field_match)
    partial_fields = []
    schema_map.values.flatten.select { |a|
      if a.end_with?(field_match)
        partial_fields << {
          field: a.parameterize,
          label: a.sub(/_#{field_match}$/,'').titleize
        } 
      end
    }
    partial_fields
  end

  def self.blacklight(map_source = 'solr_map.yml')
    schema_map = YAML.load_file(map_source)
    partial_file = File.new("_blacklight_config.rb", 'w')
    line = ""
    get_blacklight_add_fields(schema_map, "facet").each do |f|
      line << sprintf("    config.add_facet_field '%s', label: '%s'\n",
                      f[:field], f[:label])
    end
    get_blacklight_add_fields(schema_map, "display").each do |f|
      line << sprintf("    config.add_show_field '%s', label: '%s'\n",
                      f[:field], f[:label])
    end
    partial_file.write line
  end
end
