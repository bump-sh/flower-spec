require "net/http"
require "json"
require "fileutils"

gem_root = File.expand_path("../../..", __FILE__)
spec_path = "specification/json-schema-7/schema.json"
file_path = "#{gem_root}/#{spec_path}"
dirname = File.dirname(file_path)
unless File.directory?(dirname)
  FileUtils.mkdir_p(dirname)
end

# Download json schema dependency
url = "http://json-schema.org/draft-07/schema#"
response = nil

loop do
  response = Net::HTTP.get_response(URI.parse(url))
  url = response["location"]
  break unless response.is_a?(Net::HTTPRedirection)
end

# Raises if not 2xx
response.value
File.write(file_path, response.body)
