#!/usr/bin/env ruby

require "date"
require "pathname"
require "set"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
POSTS = ROOT.join("_posts")
TOPICS_FILE = ROOT.join("_data/topics.yml")
REQUIRED_FIELDS = %w[
  layout title description date updated last_modified_at lang content_type
  author category topics tags toc
].freeze
CONTENT_TYPES = %w[article declaration editorial essay research].freeze

errors = []
topic_data = YAML.safe_load(TOPICS_FILE.read, aliases: true) || []
topic_ids = topic_data.filter_map { |topic| topic["id"] }.to_set

if topic_ids.size != topic_data.size
  errors << "_data/topics.yml: topic ids must be present and unique"
end

posts = {}

Dir.glob(POSTS.join("*.md")).sort.each do |path|
  source = Pathname.new(path)
  relative = source.relative_path_from(ROOT).to_s
  raw = source.read
  front_matter = raw[/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m, 1]

  unless front_matter
    errors << "#{relative}: missing front matter"
    next
  end

  data = YAML.safe_load(
    front_matter,
    permitted_classes: [Date, Time],
    aliases: true
  ) || {}
  body = raw.sub(/\A---\s*\n.*?\n---\s*(?:\n|\z)/m, "")
  slug = source.basename(".md").to_s.sub(/^\d{4}-\d{2}-\d{2}-/, "")

  errors << "#{relative}: duplicate slug #{slug}" if posts.key?(slug)
  posts[slug] = { path: relative, data: data, body: body }

  REQUIRED_FIELDS.each do |field|
    value = data[field]
    missing = value.nil? || (value.respond_to?(:empty?) && value.empty?)
    errors << "#{relative}: missing #{field}" if missing
  end

  errors << "#{relative}: layout must be post" unless data["layout"] == "post"
  unless CONTENT_TYPES.include?(data["content_type"])
    errors << "#{relative}: content_type must be one of #{CONTENT_TYPES.join(', ')}"
  end

  author = data["author"]
  unless author.is_a?(Hash) && author["name"].to_s.strip != "" && %w[Organization Person].include?(author["type"])
    errors << "#{relative}: author must include name and a valid type"
  end

  published = data["date"]
  updated = data["updated"]
  modified = data["last_modified_at"]
  if published.respond_to?(:to_date) && updated.respond_to?(:to_date) && updated.to_date < published.to_date
    errors << "#{relative}: updated date cannot precede publication date"
  end
  if updated.respond_to?(:to_date) && modified.respond_to?(:to_date) && updated.to_date != modified.to_date
    errors << "#{relative}: updated and last_modified_at must match"
  end

  topics = Array(data["topics"])
  topics.each do |topic|
    errors << "#{relative}: unknown topic #{topic.inspect}" unless topic_ids.include?(topic)
  end

  errors << "#{relative}: related_posts is obsolete; use related slugs" if data.key?("related_posts")

  toc_ids = Array(data["toc"]).filter_map { |item| item.is_a?(Hash) ? item["id"] : nil }
  if toc_ids.uniq.length != toc_ids.length
    errors << "#{relative}: toc ids must be unique"
  end
  toc_ids.each do |id|
    errors << "#{relative}: toc id #{id.inspect} has no matching heading" unless body.match?(/^##+\s+.+\{##{Regexp.escape(id)}\}\s*$/)
  end

  sources = Array(data["sources"])
  sources.each_with_index do |source_data, index|
    next if source_data.is_a?(Hash) && source_data["title"].to_s.strip != "" && source_data["url"].to_s.match?(/\Ahttps?:\/\//)

    errors << "#{relative}: source #{index + 1} must include title and an http(s) URL"
  end
  body.scan(/#source-(\d+)/).flatten.map(&:to_i).uniq.each do |number|
    unless number.between?(1, sources.length)
      errors << "#{relative}: citation source-#{number} has no matching source"
    end
  end

  if body.match?(/<\/?[a-z][^>]*>/i)
    errors << "#{relative}: inline HTML keeps content tied to one presentation"
  end
end

posts.each do |slug, post|
  Array(post[:data]["related"]).each do |related_slug|
    errors << "#{post[:path]}: related post #{related_slug.inspect} does not exist" unless posts.key?(related_slug)
    errors << "#{post[:path]}: a post cannot relate to itself" if related_slug == slug
  end
end

if errors.empty?
  puts "Content schema verification passed"
else
  warn errors.join("\n")
  exit 1
end
