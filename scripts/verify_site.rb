#!/usr/bin/env ruby

require "pathname"

ROOT = Pathname.new(__dir__).join("..").expand_path
SITE = ROOT.join("_site")
BASEURL = "/naljabooks-blog"
EXPECTED = %w[
  index.html
  about/index.html
  methodology/index.html
  questions/index.html
  404.html
  sitemap.xml
  feed.xml
  robots.txt
  llms.txt
].freeze

errors = []

EXPECTED.each do |path|
  errors << "missing #{path}" unless SITE.join(path).file?
end

Dir.glob(SITE.join("**/*.html")).sort.each do |file|
  html = File.read(file)
  relative = Pathname.new(file).relative_path_from(SITE)

  errors << "#{relative}: missing title" unless html.match?(%r{<title>[^<]+</title>})
  errors << "#{relative}: missing description" unless html.include?('name="description"')
  errors << "#{relative}: missing canonical" unless html.include?('rel="canonical"')

  unsafe_path = html.scan(%r{(?:href|src)="(/[^"]*)"}).flatten.find do |path|
    path != "/" && !path.start_with?("#{BASEURL}/")
  end
  errors << "#{relative}: root-relative path bypasses baseurl: #{unsafe_path}" if unsafe_path
end

post = SITE.join("archive/why-analogy-matters/index.html")
if post.file?
  html = post.read
  blog_posting_count = html.scan('"@type":"BlogPosting"').length
  errors << "post: expected one BlogPosting JSON-LD, found #{blog_posting_count}" unless blog_posting_count == 1
  unless html.include?('"author":{"@type":"Organization"')
    errors << "post: structured author must be an Organization"
  end
  errors << "post: missing visible sources" unless html.include?('id="sources"')
  %w[analogy daily-life learning principles nalja-view summary].each do |id|
    errors << "post: missing section anchor ##{id}" unless html.include?("id=\"#{id}\"")
  end
  errors << "post: raw Kramdown attribute syntax is visible" if html.include?("{:#")
else
  errors << "missing archive/why-analogy-matters/index.html"
end

source_files = Dir.glob(
  ROOT.join("{*.md,*.html,_posts/*,_includes/*,_layouts/*,robots.txt,llms.txt}")
)
source_files.each do |file|
  content = File.read(file)
  next unless content.match?(/\b(?:TBD|TODO)\b|example\.com|임시 URL/i)

  relative = Pathname.new(file).relative_path_from(ROOT)
  errors << "#{relative}: placeholder text"
end

if errors.empty?
  puts "Site verification passed"
else
  warn errors.join("\n")
  exit 1
end
