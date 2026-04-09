require "spec_helper"

RSpec.describe Flower::Arazzo::Validator do
  describe "#valid?" do
    it "validates a valid input file" do
      validated = []

      Dir["examples/arazzo/*.json"].each do |filepath|
        definition = File.read(filepath)
        validated << filepath

        expect(subject.valid?(definition)).to be(true)
      end

      expect(validated).to contain_exactly(/wikimedia.json/)
    end

    it "validates an invalid input file" do
      validated = []

      Dir["examples/arazzo/invalid/*.yml"].each do |filepath|
        definition = File.read(filepath)
        validated << filepath

        expect(subject.valid?(definition)).to be(false)
      end

      expect(validated).to contain_exactly(/missing-workflows.yml/)
    end

    it "validates an already parsed definition" do
      parsed_definition = {
        arazzo: "1.0.1",
        info: {title: "Hello", version: "0"},
        sourceDescriptions: [],
        workflows: []
      }

      subject.valid?(parsed_definition, parse: false)
      expect(subject.pretty_errors).to eq([])
    end
  end

  describe "#pretty_errors" do
    it "returns an empty list when no validation has been done" do
      expect(subject.pretty_errors).to eq([])
    end

    it "returns a list of prettyfied errors when an invalid input has been checked" do
      definition = File.read("examples/arazzo/invalid/missing-workflows.yml")

      subject.valid?(definition)

      expect(subject.pretty_errors).to contain_exactly("root is missing required keys: workflows")
    end
  end
end
