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

POSTS = {
  "archive/why-analogy-matters/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인에게 왜 유추력이 필요할까?",
    anchors: %w[analogy daily-life learning principles nalja-view summary]
  },
  "archive/ai-must-benefit-people-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 대표 조윤영",
    required_text: "AI는 지적장애인의 이해와 선택, 참여를 넓혀야 한다",
    anchors: %w[mothers-question declaration practical-benefits decision-boundary principles risks nalja-promise]
  }
}.freeze

errors = []

pinned_posts = Dir.glob(ROOT.join("_posts/*")).select do |file|
  front_matter = File.read(file)[/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m, 1].to_s
  front_matter.match?(/^pinned:\s*true\s*$/)
end
unless pinned_posts.length == 1
  errors << "posts: expected exactly one pinned declaration, found #{pinned_posts.length}"
end
expected_pinned_post = ROOT.join("_posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md")
if pinned_posts.length == 1 && Pathname.new(pinned_posts.first) != expected_pinned_post
  errors << "posts: pinned declaration must be #{expected_pinned_post.relative_path_from(ROOT)}"
end

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

home = SITE.join("index.html")
if home.file?
  html = home.read
  declaration_path = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
  featured_story = html[%r{<article class="featured-story">.*?</article>}m].to_s
  story_list = html[%r{<div class="story-list"[^>]*>.*?</div>}m].to_s

  unless featured_story.include?(declaration_path)
    errors << "index.html: pinned declaration is not in the featured story"
  end
  unless featured_story.include?("고정 선언문")
    errors << "index.html: pinned declaration badge is missing"
  end
  unless html.scan(%(href="#{declaration_path}")).length == 1
    errors << "index.html: pinned declaration must appear exactly once"
  end
  unless story_list.include?("지적장애인에게 왜 유추력이 필요할까?")
    errors << "index.html: regular post is missing from the right story list"
  end

  {
    "editorial hero" => 'class="home-hero"',
    "connected learning illustration" => "home-learning-scenes.webp",
    "featured latest post" => 'class="featured-story"',
    "topic icon" => 'class="topic-icon"',
    "editorial principle" => 'class="home-principle"',
    "latest posts CTA" => 'href="#recent-posts"'
  }.each do |label, marker|
    errors << "index.html: missing #{label}" unless html.include?(marker)
  end
  if html.match?(%r{<input[^>]+type=["']email["']})
    errors << "index.html: newsletter input is out of scope"
  end
  errors << "index.html: missing Nalkku logo" unless html.include?("nalkku-logo.svg")
  expected_home_title = "AI 시대, 지적장애인의 배움과 일상"
  errors << "index.html: missing refreshed page title" unless html.include?("<title>#{expected_home_title} | 날자 아카이브</title>")
  errors << "index.html: missing refreshed Open Graph title" unless html.include?(%(property="og:title" content="#{expected_home_title}"))
  errors << "index.html: missing refreshed Twitter title" unless html.include?(%(property="twitter:title" content="#{expected_home_title}"))
  errors << "index.html: header tagline must be removed" if html.match?(%r{<small>[^<]*</small>})
  errors << "index.html: hero headline changed unexpectedly" unless html.include?("배운 것이") && html.include?("삶으로 이어지도록")
  errors << "index.html: obsolete public tagline" if html.include?("배움과 선택을 잇는 연구와 실천의 기록")
  errors << "index.html: obsolete hero kicker" if html.include?("배움과 선택을 잇는 기록")
  if html.include?("보호자와 교사, 복지 현장의 실무자가 함께 읽을 수 있는 말로 핵심부터 설명합니다.")
    errors << "index.html: redundant hero sentence"
  end
end

POSTS.each do |path, expectations|
  post = SITE.join(path)
  unless post.file?
    errors << "missing #{path}"
    next
  end

  html = post.read
  blog_posting_count = html.scan('"@type":"BlogPosting"').length
  unless blog_posting_count == 1
    errors << "#{path}: expected one BlogPosting JSON-LD, found #{blog_posting_count}"
  end
  unless html.include?('"author":{"@type":"Organization"')
    errors << "#{path}: structured author must be an Organization"
  end
  errors << "#{path}: missing visible author" unless html.include?(expectations[:author])
  errors << "#{path}: missing required article text" unless html.include?(expectations[:required_text])
  errors << "#{path}: missing visible sources" unless html.include?('id="sources"')

  expectations[:anchors].each do |id|
    errors << "#{path}: missing section anchor ##{id}" unless html.include?("id=\"#{id}\"")
    errors << "#{path}: missing TOC link ##{id}" unless html.include?("href=\"##{id}\"")
  end

  errors << "#{path}: raw Kramdown attribute syntax is visible" if html.include?("{:#")
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

PUBLIC_COPY_FILES = %w[_config.yml index.html about.md llms.txt].freeze
share_image = ROOT.join("assets/images/share-default.svg").read
errors << "share-default.svg: missing refreshed title" unless share_image.include?("AI 시대, 지적장애인의 배움과 일상")
errors << "share-default.svg: obsolete tagline" if share_image.include?("배움과 선택을 잇는 연구와 실천의 기록")

PUBLIC_COPY_FILES.each do |path|
  if ROOT.join(path).read.include?("발달장애인")
    errors << "#{path}: public terminology must use 지적장애인"
  end
end

if errors.empty?
  puts "Site verification passed"
else
  warn errors.join("\n")
  exit 1
end
