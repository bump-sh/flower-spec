require "yaml"
require "json_schemer"
require "open-uri"

module Flower
  class Validator
    SCHEMA = JSON.parse(File.read("specification/v0/schema.json")).freeze

    def initialize
      @validator = JSONSchemer.schema(
        SCHEMA,
        insert_property_defaults: true,
        ref_resolver: proc { |uri| JSON.parse(URI.parse(uri).read) }
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
