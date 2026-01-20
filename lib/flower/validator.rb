require "yaml"
require "json_schemer"
require "open-uri"

module Flower
  class Validator
    GEM_ROOT = File.expand_path("../../..", __FILE__)
    SPEC_PATH = "specification/v0/schema.json"
    SCHEMA = JSON.parse(File.read("#{GEM_ROOT}/#{SPEC_PATH}")).freeze

    JSON_SCHEMA_SPEC_PATH = "specification/json-schema-7/schema.json"
    JSON_SCHEMA = JSON.parse(File.read("#{GEM_ROOT}/#{JSON_SCHEMA_SPEC_PATH}")).freeze

    def initialize
      @validator = JSONSchemer.schema(
        SCHEMA,
        insert_property_defaults: true,
        ref_resolver: {
          URI("http://json-schema.org/draft-07/schema") => JSON_SCHEMA
        }.to_proc
      )
      @errors = []
    end

    def valid?(input, parse: true)
      input = parse!(input) if parse

      self.errors = @validator.validate(input).to_a

      errors.empty?
    end

    def pretty_errors
      errors.map do |error|
        JSONSchemer::Errors.pretty(error)
      end
    end

    def raw_errors
      errors
    end

    private

    attr_accessor :errors

    def parse!(input)
      JSON.parse(input)
    rescue JSON::ParserError => _
      YAML.load(input)
    end
  end
end
