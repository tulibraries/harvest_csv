require 'rubygems'
require 'csv'
require 'rsolr'
require 'yaml'
require 'securerandom'
require 'active_support/core_ext/string'
require 'ruby-progressbar'

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
                   solr_endpoint = 'http://localhost:8983/solr/blacklight-core',
                   batch_size = 100)
    schema_map = YAML.load_file(map_source)
    batch_thread = []

    # Use compatible encoding
    csv_encoding = `file -b --mime-encoding #{csv_source}`.rstrip

    if (csv_encoding == "us-ascii")
      csv = CSV.read(csv_source, headers: true, encoding: 'ISO8859-1') 
    else
      csv = CSV.read(csv_source, headers: true) 
    end

    progressbar = ProgressBar.create(:title => "Harvest ", :total => csv.count, format: "%t (%c/%C) %a |%B|")
    solr = RSolr.connect url: solr_endpoint
    csv.each_slice(batch_size) do |batch|
      batch_thread << Thread.new {
        document_batch = []
        batch.each do |item|
          document_batch << ( csv_to_solr(item.to_h, schema_map) )
          progressbar.increment
        end
        solr.add document_batch, add_attributes: { commitWithin: 10 }
      }

      solr.commit

      batch_thread.each { |t| t.join }
    end
  end

  def self.make_map(csv_path,
                    map_path,
                    id_field)
    schema_map = Hash.new
    CSV.open(csv_path, headers: true) do |csv|
      csv.first
      csv.headers.each do |field_name|
        field = field_name.parameterize.underscore
        schema_map[field] = []
        schema_map[field] << "id" if id_field == field_name.to_s
        schema_map[field] << "#{field.downcase}_display"
        schema_map[field] << "#{field.downcase}_facet"
      end
    end
    map_file = File.new(map_path, 'w')
    YAML.dump(schema_map, map_file)
    map_file.close
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
