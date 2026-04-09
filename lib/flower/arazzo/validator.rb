require "yaml"
require "json_schemer"
require "open-uri"

module Flower
  module Arazzo
    class Validator < ::Flower::Validator
      GEM_ROOT = File.expand_path("../../../..", __FILE__)
      SPEC_PATH = "specification/arazzo/v1/schema-basic.json"
      SCHEMA = JSON.parse(File.read("#{GEM_ROOT}/#{SPEC_PATH}")).freeze

      def initialize(schema = SCHEMA)
        super
      end
    end
  end
end
