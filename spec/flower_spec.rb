require "spec_helper"

RSpec.describe Flower do
  it "has a version number" do
    expect(Flower::VERSION).not_to be nil
  end
end
