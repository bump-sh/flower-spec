# frozen_string_literal: true

require_relative "lib/flower/version"

Gem::Specification.new do |spec|
  spec.name = "flower-spec"
  spec.version = Flower::VERSION
  spec.authors = ["Paul B."]
  spec.email = ["paulr@bump.sh"]

  spec.summary = "Flower specification to define API workflows"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["source_code_uri"] = "https://github.com/bump-sh/flower"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.extensions << "ext/http/Rakefile"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json_schemer", ">= 2.0.0", "< 3.0.0"
end
