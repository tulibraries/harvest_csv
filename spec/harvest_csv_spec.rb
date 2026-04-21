require 'spec_helper'
require 'socket'
require 'tempfile'
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
    begin
      socket = TCPSocket.new('127.0.0.1', 8983)
      socket.close
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::EPERM
      skip "Solr is not available on localhost:8983"
    end

    csv_filename = "#{RSpec.configuration.fixtures_path}/test.csv"
    map_filename = "#{RSpec.configuration.fixtures_path}/test-map.yml"
    HarvestCSV.harvest(csv_filename, map_filename, solr_uri)
  end
end

describe ".make_map" do
  it "writes a schema map when given an open file handle" do
    Tempfile.create(['harvest_csv_map', '.yml']) do |map_file|
      csv_filename = "#{RSpec.configuration.fixtures_path}/test.csv"

      HarvestCSV.make_map(csv_filename, map_file, 'field1')
      map_file.rewind

      expect(YAML.safe_load(map_file.read, permitted_classes: [], permitted_symbols: [], aliases: false)).to eq(
        "field1" => ["id", "field1_display", "field1_facet"],
        "field2" => ["field2_display", "field2_facet"]
      )
    end
  end
end
