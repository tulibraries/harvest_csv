require 'spec_helper'
require_relative '../lib/harvest_csv'

describe "Solr conversion" do
  it "a csv row and coverts it into a solr document" do
    schema_map = {"field1" => ["id", "field1_display"],
                  "field2" => ["field2_facet", "field2_display"]}
    csv_hash = {"field1" => "value1",
                "field2" => "value2"}
    expected_document = {"id" => "value1",
                         "field1_display" => "value1",
                         "field2_facet" => "value2",
                         "field2_display" => "value2"}
    actual_document = HarvestCSV.csv_to_solr(csv_hash, schema_map)
    expect(actual_document).to match expected_document
  end

end

describe "To Solr core" do
  it "ingests a CSV file into Solr-core" do
    solr_uri = 'http://localhost:8983/solr/blacklight-core'
    solr = RSolr.connect url: solr_uri
    csv_string = "key1,key2\nvalue1,value2"
    csv_filename = "#{RSpec.configuration.fixtures_path}/test.csv"
    map_filename = "#{RSpec.configuration.fixtures_path}/test-map.yml"
    HarvestCSV.harvest(csv_filename, map_filename, solr_uri)
  end
end
