#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"

urls_file = ARGV.fetch(0) { abort "usage: ruby scripts/submit_indexnow.rb URLS_FILE" }
urls = File.readlines(urls_file, chomp: true).map(&:strip).reject(&:empty?).uniq

if urls.empty?
  puts "No changed public URLs to submit."
  exit 0
end

site_url = ENV.fetch("INDEXNOW_SITE_URL").sub(%r{/+\z}, "")
key = ENV.fetch("INDEXNOW_KEY")
unless key.match?(/\A[0-9a-f-]{8,128}\z/i)
  abort "INDEXNOW_KEY has an invalid format."
end

invalid_urls = urls.reject { |url| url == "#{site_url}/" || url.start_with?("#{site_url}/") }
unless invalid_urls.empty?
  abort "Refusing to submit URLs outside #{site_url}: #{invalid_urls.join(', ')}"
end

endpoint = URI("https://api.indexnow.org/indexnow")
payload = {
  host: URI(site_url).host,
  key:,
  keyLocation: "#{site_url}/#{key}.txt",
  urlList: urls
}

request = Net::HTTP::Post.new(endpoint)
request["Content-Type"] = "application/json; charset=utf-8"
request.body = JSON.generate(payload)
response = Net::HTTP.start(endpoint.host, endpoint.port, use_ssl: true) do |http|
  http.request(request)
end

unless %w[200 202].include?(response.code)
  warn "IndexNow submission failed with HTTP #{response.code}: #{response.body}"
  exit 1
end

puts "IndexNow accepted #{urls.length} changed URL(s) with HTTP #{response.code}."
