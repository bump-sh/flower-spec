# Flower specification

The _Flower_ specification is published by [Bump.sh](https://bump.sh)
and built to simplify defining API workflows.

The specification is currently only used internally @bump.sh, fully
inspired by [Arazzo](https://spec.openapis.org/arazzo/latest.html) but
in a less generic way (no sources definitions needed). Meaning you can
start defining an API workflow from scratch, without any openapi
files.

You can find the current version of the specification JSON Schema at:
- ..No published HTML page for now...
- [`specification/v0/schema.json`](specification/v0/schema.json)

## Notable _benefits_ compared to Arazzo

- Flower takes a “no dependency” approach by not knowing about
  OpenAPI. It needs the API urls and methods declared in a Flower
  definition directly.
- Arazzo's `successCriteria` / `onFailure` / `onSuccess` are
  simplified in a single list of `actions`. Each `action` object lets
  you chose between `next` (go to next step), `retry` (retry current
  step), `goto` (go to a previous or a future step) and `end` actions
  conditionally based on their optional `condition` runtime
  expression. By default Flower specifies a `next` action when no
  actions are declared within a step.

## Notable _limitations_ compared to Arazzo

- Arazzo's **`step.parameters[in=path|cookie]`** do not have a Flower
  equivalent yet.
- Flower does not support referenced workflows within a **`step`** (or
  **`action`**) yet. Meaning you can't use a whole defined workflow
  within a `step` of another workflow.

## Ruby library

The repository also holds a Ruby gem that can be used in your own ruby
apps to validate a given input with the _flower_ specification. It's a
very simple wrapper around the
[`json_schemer`](https://github.com/davishmcclurg/json_schemer) gem
with the _flower_ specification.

### Installation

Add this line to your application's `Gemfile`:
```ruby
gem "flower-spec"
```

And then execute:
```
bundle
```

Or install it yourself:
```
gem install flower-spec
```

### Usage (as a rake task)

If you use Rails, a new rake task should be available thanks to this
gem:
```
# Validate a file given its path
bundle exec rake flower:validator[examples/bump.yml]
```

Or

```
# Validate a file by sending it directly to the standard input of the task
bundle exec rake flower:validator < examples/parking.yml
```


### Usage (in your code)

Then use it in your code:
```ruby
require "flower"

validator = Flower::Validator.new
file_content = File.read("examples/bump.yml")

# Validate a file content in YAML or JSON

validator.valid?(file_content)
# => true

# Validate a ruby object without deserialization

validator.valid?({flower: "1.0"}, parse: false)
# => false

# Read validation errors

validator.pretty_errors
# => ["root is missing required keys: id, flows"]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bump-sh/flower. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bump-sh/flower/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flower project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bump-sh/flower/blob/master/CODE_OF_CONDUCT.md).
