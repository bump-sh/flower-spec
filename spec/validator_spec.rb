# frozen_string_literal: true

RSpec.describe Flower::Validator do
  describe "#valid?" do
    it "validates a valid input file" do
      Dir["examples/*.yml"].each do |filepath|
        definition = File.read(filepath)

        expect(subject.valid?(definition)).to be(true)
      end
    end

    it "validates an invalid input file" do
      Dir["examples/invalid/*.yml"].each do |filepath|
        definition = File.read(filepath)

        expect(subject.valid?(definition)).to be(false)
      end
    end

    it "validates an already parsed definition" do
      parsed_definition = {
        flower: "0.1",
        id: "hello",
        flows: []
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
      definition = File.read("examples/invalid/test.yml")

      subject.valid?(definition)

      expect(subject.pretty_errors).to include("property '/flower' is not one of: [\"0.1\"]")
      expect(subject.pretty_errors).to include("root is missing required keys: id")
    end

    it "returns a list of prettyfied errors when an invalid action has been checked" do
      definition = File.read("examples/invalid/actions.yml")

      subject.valid?(definition)

      ["next", "goto", "end", "retry"].each do |action_type|
        expect(subject.pretty_errors).to include("property '/flows/0/steps/0/actions/0/do' is not: \"#{action_type}\"")
      end
    end
  end
end
