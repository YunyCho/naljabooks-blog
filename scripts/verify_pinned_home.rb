#!/usr/bin/env ruby

require "fileutils"
require "open3"
require "pathname"
require "tmpdir"

ROOT = Pathname.new(__dir__).join("..").expand_path
FIXTURE = ROOT.join("_posts/2099-12-31-pinned-home-fixture-#{Process.pid}.md")
DECLARATION_PATH = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
ANALOGY_TITLE = "지적장애인에게 왜 유추력이 필요할까?"
FIXTURE_TITLE = "새 글 누적 검증"

fixture_content = <<~MARKDOWN
  ---
  layout: post
  title: "#{FIXTURE_TITLE}"
  description: "고정 선언문과 일반 글 목록의 누적 동작을 검증하는 임시 글입니다."
  date: 2099-12-31 00:00:00 +0900
  category: "검증"
  ---

  고정 홈페이지 통합 검증용 임시 글입니다.
MARKDOWN

fixture_created = false

begin
  if FIXTURE.exist?
    warn "fixture collision: #{FIXTURE.relative_path_from(ROOT)} already exists"
    exit 1
  end

  FIXTURE.write(fixture_content)
  fixture_created = true

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
    first_story_list_item = story_list[%r{<article class="story-list-item">.*?</article>}m].to_s
    errors = []

    unless featured_story.include?(DECLARATION_PATH)
      errors << "index.html: declaration did not remain in the featured story"
    end
    unless html.scan(%(href="#{DECLARATION_PATH}")).length == 1
      errors << "index.html: declaration href must appear exactly once"
    end
    unless first_story_list_item.include?(FIXTURE_TITLE)
      errors << "index.html: fixture post is not first in the story list"
    end
    unless story_list.include?(ANALOGY_TITLE)
      errors << "index.html: existing analogy post is missing from the story list"
    end

    unless errors.empty?
      warn errors.join("\n")
      exit 1
    end
  end

  puts "Pinned homepage integration verification passed"
ensure
  FileUtils.rm_f(FIXTURE) if fixture_created
end
