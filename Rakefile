# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

# “build” extensions when developping locally
Dir.chdir("ext/http") do
  system("rake")
end

# Load locally defined tasks
Dir["lib/tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

task default: %i[spec standard]
