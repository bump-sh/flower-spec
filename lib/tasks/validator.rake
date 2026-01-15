require "flower"

namespace :flower do
  desc "Validate a given input file (stding) against the flower specification"
  task :validator, [:file] do |t, args|
    filename = args[:file]
    file = if filename
      puts "Reading input file #{filename}"
      File.open(filename, "r")
    else
      puts "Waiting for input... (ctrl+d after you finished the input)" if $stdin.tty?
      $stdin
    end

    input_data = file.read
    validator = Flower::Validator.new

    if validator.valid?(input_data, parse: true)
      puts "Given file is valid against the flower specification"
    else
      raise validator.pretty_errors.join("\n")
    end
  end
end
