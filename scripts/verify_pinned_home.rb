#!/usr/bin/env ruby

require "fileutils"
require "open3"
require "pathname"
require "tmpdir"

ROOT = Pathname.new(__dir__).join("..").expand_path
DECLARATION_PATH = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
ANALOGY_TITLE = "지적장애인에게 왜 유추력이 필요할까?"
FIXTURES = [
  {
    path: ROOT.join("_posts/2099-12-31-pinned-home-newer-fixture-#{Process.pid}.md"),
    title: "새 글 누적 검증 최신",
    date: "2099-12-31 00:00:00 +0900"
  },
  {
    path: ROOT.join("_posts/2099-12-30-pinned-home-older-fixture-#{Process.pid}.md"),
    title: "새 글 누적 검증 이전",
    date: "2099-12-30 00:00:00 +0900"
  }
].freeze

fixture_content = lambda do |fixture|
  <<~MARKDOWN
    ---
    layout: post
    title: "#{fixture[:title]}"
    description: "고정 선언문과 일반 글 목록의 누적 동작을 검증하는 임시 글입니다."
    date: #{fixture[:date]}
    category: "검증"
    ---

    고정 홈페이지 통합 검증용 임시 글입니다.
  MARKDOWN
end

created_fixtures = []

begin
  collisions = FIXTURES.filter_map do |fixture|
    fixture[:path].relative_path_from(ROOT) if fixture[:path].exist?
  end
  unless collisions.empty?
    warn "fixture collision: #{collisions.join(", ")} already exists"
    exit 1
  end

  FIXTURES.each do |fixture|
    fixture[:path].write(fixture_content.call(fixture))
    created_fixtures << fixture[:path]
  end

  non_pinned_source_posts = Dir.glob(ROOT.join("_posts/*")).count do |file|
    front_matter = File.read(file)[/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m, 1].to_s
    !front_matter.match?(/^pinned:\s*true\s*$/)
  end

  Dir.mktmpdir("naljabooks-pinned-home-") do |destination|
    stdout, stderr, status = Open3.capture3(
      { "JEKYLL_ENV" => "production" },
      "bundle", "exec", "jekyll", "build", "--trace", "--future", "--destination", destination,
      chdir: ROOT.to_s
    )
    unless status.success?
      warn stdout unless stdout.empty?
      warn stderr unless stderr.empty?
      exit 1
    end

    html = Pathname.new(destination).join("index.html").read
    featured_story = html[%r{<article class="featured-story">.*?</article>}m].to_s
    story_list = html[%r{<div class="story-list"[^>]*>.*?</div>}m].to_s
    story_list_items = story_list.scan(%r{<article class="story-list-item">.*?</article>}m)
    story_list_hrefs = story_list_items.filter_map { |item| item[/<h3><a href="([^"]+)"/, 1] }
    errors = []

    unless featured_story.include?(DECLARATION_PATH)
      errors << "index.html: declaration did not remain in the featured story"
    end
    unless html.scan(%(href="#{DECLARATION_PATH}")).length == 1
      errors << "index.html: declaration href must appear exactly once"
    end
    if story_list.include?(DECLARATION_PATH)
      errors << "index.html: declaration must not appear in the story list"
    end
    unless story_list_items.fetch(0, "").include?(FIXTURES[0][:title])
      errors << "index.html: newer fixture post is not first in the story list"
    end
    unless story_list_items.fetch(1, "").include?(FIXTURES[1][:title])
      errors << "index.html: older fixture post is not second in the story list"
    end
    unless story_list.include?(ANALOGY_TITLE)
      errors << "index.html: existing analogy post is missing from the story list"
    end
    older_fixture_position = story_list.index(FIXTURES[1][:title])
    analogy_position = story_list.index(ANALOGY_TITLE)
    if older_fixture_position && analogy_position && analogy_position <= older_fixture_position
      errors << "index.html: analogy post must follow both fixture posts"
    end
    unless story_list_items.length == non_pinned_source_posts
      errors << "index.html: expected #{non_pinned_source_posts} regular story items, found #{story_list_items.length}"
    end
    unless story_list_hrefs.length == story_list_items.length
      errors << "index.html: every story list item must include a post href"
    end
    unless story_list_hrefs.uniq.length == story_list_hrefs.length
      errors << "index.html: story list post hrefs must be unique"
    end

    unless errors.empty?
      warn errors.join("\n")
      exit 1
    end
  end

  puts "Pinned homepage integration verification passed"
ensure
  created_fixtures.each { |fixture| FileUtils.rm_f(fixture) }
end
