#!/usr/bin/env ruby

require "pathname"

ROOT = Pathname.new(__dir__).join("..").expand_path
SITE = ROOT.join("_site")
BASEURL = "/naljabooks-blog"
EXPECTED = %w[
  index.html
  archive/index.html
  about/index.html
  methodology/index.html
  questions/index.html
  topics/index.html
  404.html
  sitemap.xml
  feed.xml
  robots.txt
  llms.txt
].freeze

POSTS = {
  "archive/learning-rights-and-literacy-support-for-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인의 학습권은 배울 기회를 넘어 이해하고 표현하고 선택할 권리와 연결된다",
    anchors: %w[summary right-to-learn literacy-rights easy-information limits daily-use nalkku-design conclusion],
    source_count: 4
  },
  "archive/analogy-learning-and-transfer-to-daily-life/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "유추 학습은 일상생활 전이를 돕는 중요한 방법이다",
    anchors: %w[summary transfer-goal analogy-bridge easy-text-limits varied-examples expression transfer-design conclusion],
    source_count: 4
  },
  "archive/easy-information-and-reading-comprehension/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "쉬운 정보와 읽기이해는 같지 않다",
    anchors: %w[summary easy-information comprehension-process necessary-not-sufficient next-step distinction conclusion],
    source_count: 4
  },
  "archive/ten-unspoken-senses-of-nalkku-learners/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    requires_sources: false,
    required_text: "나도 배우고 싶지만, 부담스럽지 않게 내 방식으로 시작하고 싶다",
    anchors: %w[can-start age-respect ask-me-first my-choice my-story everyday-life visible-traces gentle-connection begin-again something-for-me conditions-for-learning]
  },
  "archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html" => {
    author: "조윤영",
    author_type: "Person",
    requires_sources: false,
    required_text: "At the edge of intelligence, we will at last discover the heart.",
    anchors: %w[prologue chapter-1 chapter-2 chapter-3 chapter-4 chapter-5 epilogue]
  },
  "archive/why-easy-text-alone-is-not-enough/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "쉬운 글은 꼭 필요하지만 충분하지 않다",
    anchors: %w[summary easy-text comprehension activities adulthood repetition nalja-view conclusion],
    source_count: 4
  },
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

published_drafts = Dir.glob(SITE.join("naver-drafts/**/*"), File::FNM_DOTMATCH).reject do |path|
  %w[. ..].include?(File.basename(path))
end
unless published_drafts.empty?
  errors << "naver-drafts: review files must be excluded from the public site"
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
  errors << 'index.html: site language changed from Korean' unless html.include?('<html lang="ko-KR">')
  unless html.include?('name="google-site-verification" content="abnm5XbuGrXdD1fXgNHPSBJBbVW61VxotldMEjCxJpc"')
    errors << "index.html: missing Google Search Console verification tag"
  end
  declaration_path = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
  featured_story = html[%r{<article class="featured-story">.*?</article>}m].to_s
  story_list = html[%r{<div class="story-list"[^>]*>.*?</div>}m].to_s
  first_regular_story = story_list.match(%r{<article class="story-list-item">.*?</article>}m)&.to_s

  unless first_regular_story&.include?("지적장애인의 학습권은 문해력 지원에서 시작된다")
    errors << "index.html: learning rights article is not the newest regular story"
  end
  unless story_list.include?("유추 학습은 일상생활 전이에 어떻게 연결되는가")
    errors << "index.html: analogy transfer article is missing from the right story list"
  end
  unless story_list.include?("쉬운 정보와 읽기이해는 같은가")
    errors << "index.html: easy-information article is missing from the right story list"
  end
  unless story_list.include?("날꾸 학습자가 원하지만 말하지 못한 열 가지 감각")
    errors << "index.html: unspoken learner senses article is missing from the right story list"
  end
  story_list_items = story_list.scan(%r{<article class="story-list-item">.*?</article>}m)
  unless story_list_items.length == 4
    errors << "index.html: expected exactly 4 latest regular stories, found #{story_list_items.length}"
  end
  unless html.include?(%(/naljabooks-blog/archive/">전체 글 보기))
    errors << "index.html: missing full archive link"
  end

  unless featured_story.include?(declaration_path)
    errors << "index.html: pinned declaration is not in the featured story"
  end
  unless featured_story.include?("고정 선언문")
    errors << "index.html: pinned declaration badge is missing"
  end
  unless html.scan(%(href="#{declaration_path}")).length == 1
    errors << "index.html: pinned declaration must appear exactly once"
  end
  if story_list.include?("쉬운 글만으로 충분하지 않은 이유")
    errors << "index.html: story list must show only latest 4 regular posts"
  end

  {
    "editorial hero" => 'class="home-hero"',
    "connected learning illustration" => "home-learning-scenes.webp",
    "featured latest post" => 'class="featured-story"',
    "topic icon" => 'class="topic-icon"',
    "topic search guide" => 'href="/naljabooks-blog/topics/"',
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

topics = SITE.join("topics/index.html")
if topics.file?
  html = topics.read
  {
    "topics heading" => "지적장애인의 배움과 권리를 찾는 검색어 안내",
    "learning rights query" => "지적장애 학습권",
    "learning rights article link" => "/naljabooks-blog/archive/learning-rights-and-literacy-support-for-intellectual-disabilities/",
    "AI era query" => "AI 시대 지적장애인",
    "literacy query" => "지적장애 문해력",
    "analogy query" => "유추 학습 지적장애",
    "easy information query" => "쉬운 정보 읽기이해",
    "Nalkku explanation" => "날자꾸러미는 이 질문들을 실제 학습 활동으로 연결하는 프로그램",
    "analogy transfer link" => "/naljabooks-blog/archive/analogy-learning-and-transfer-to-daily-life/",
    "easy information link" => "/naljabooks-blog/archive/easy-information-and-reading-comprehension/",
    "AI declaration link" => "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
  }.each do |label, marker|
    errors << "topics/index.html: missing #{label}" unless html.include?(marker)
  end
  if html.include?("발달장애인")
    errors << "topics/index.html: public terminology must center 지적장애인"
  end
end

archive = SITE.join("archive/index.html")
if archive.file?
  html = archive.read
  {
    "archive heading" => "전체 글",
    "pinned declaration" => "AI must benefit people with intellectual disabilities",
    "latest article" => "지적장애인의 학습권은 문해력 지원에서 시작된다",
    "previous article" => "유추 학습은 일상생활 전이에 어떻게 연결되는가",
    "old regular article" => "지적장애인에게 왜 유추력이 필요할까?",
    "home link" => "/naljabooks-blog/"
  }.each do |label, marker|
    errors << "archive/index.html: missing #{label}" unless html.include?(marker)
  end
  post_links = html.scan(%r{<article class="archive-list-item">}).length
  expected_posts = Dir.glob(ROOT.join("_posts/*")).length
  unless post_links == expected_posts
    errors << "archive/index.html: expected #{expected_posts} posts, found #{post_links}"
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
  author_type = expectations.fetch(:author_type, "Organization")
  unless html.include?(%("author":{"@type":"#{author_type}"))
    errors << "#{path}: structured author must be a #{author_type}"
  end
  errors << "#{path}: missing visible author" unless html.include?(expectations[:author])
  errors << "#{path}: missing required article text" unless html.include?(expectations[:required_text])
  if expectations.fetch(:requires_sources, true)
    errors << "#{path}: missing visible sources" unless html.include?('id="sources"')
  elsif html.include?('id="sources"')
    errors << "#{path}: source section must not be rendered"
  end
  if expectations.fetch(:requires_sources, true)
    unless html.include?("확인 가능한 원문을 출처로 연결했습니다")
      errors << "#{path}: sourced method note is missing"
    end
  elsif !html.include?("글쓴이의 관점과 경험을 바탕으로 작성했습니다")
    errors << "#{path}: perspective method note is missing"
  end

  expectations[:anchors].each do |id|
    errors << "#{path}: missing section anchor ##{id}" unless html.include?("id=\"#{id}\"")
    errors << "#{path}: missing TOC link ##{id}" unless html.include?("href=\"##{id}\"")
  end

  if expectations[:source_count]
    source_count = html.scan(%r{id="source-\d+"}).length
    unless source_count == expectations[:source_count]
      errors << "#{path}: expected #{expectations[:source_count]} sources, found #{source_count}"
    end
  end

  errors << "#{path}: raw Kramdown attribute syntax is visible" if html.include?("{:#")
end

easy_text_path = "archive/why-easy-text-alone-is-not-enough/index.html"
easy_text_url = "https://yunycho.github.io/naljabooks-blog/archive/why-easy-text-alone-is-not-enough/"
easy_text_post = SITE.join(easy_text_path)
easy_information_url = "https://yunycho.github.io/naljabooks-blog/archive/easy-information-and-reading-comprehension/"
analogy_transfer_path = "archive/analogy-learning-and-transfer-to-daily-life/index.html"
analogy_transfer_url = "https://yunycho.github.io/naljabooks-blog/archive/analogy-learning-and-transfer-to-daily-life/"
learning_rights_url = "https://yunycho.github.io/naljabooks-blog/archive/learning-rights-and-literacy-support-for-intellectual-disabilities/"

if easy_text_post.file?
  html = easy_text_post.read
  {
    "Open Graph title" => 'property="og:title" content="쉬운 글만으로 충분하지 않은 이유"',
    "Open Graph description" => 'property="og:description"',
    "Open Graph URL" => %(property="og:url" content="#{easy_text_url}"),
    "published time" => 'property="article:published_time" content="2026-06-19T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{easy_text_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-19T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-19T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{easy_text_url}")
  }.each do |label, marker|
    errors << "#{easy_text_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{easy_text_path}: public article prose must use 지적장애인"
  end
end

%w[sitemap.xml feed.xml].each do |path|
  next unless SITE.join(path).file?
  errors << "#{path}: missing easy-text article" unless SITE.join(path).read.include?(easy_text_url)
  errors << "#{path}: missing easy-information article" unless SITE.join(path).read.include?(easy_information_url)
  errors << "#{path}: missing analogy transfer article" unless SITE.join(path).read.include?(analogy_transfer_url)
  errors << "#{path}: missing learning-rights article" unless SITE.join(path).read.include?(learning_rights_url)
end

robots = SITE.join("robots.txt")
if robots.file?
  robots_text = robots.read
  {
    "Bingbot" => "User-agent: Bingbot",
    "OAI-SearchBot" => "User-agent: OAI-SearchBot",
    "GPTBot" => "User-agent: GPTBot",
    "PerplexityBot" => "User-agent: PerplexityBot"
  }.each do |label, marker|
    errors << "robots.txt: missing explicit #{label} allowance" unless robots_text.include?(marker)
  end
end

analogy_transfer_post = SITE.join(analogy_transfer_path)
if analogy_transfer_post.file?
  html = analogy_transfer_post.read
  {
    "Open Graph title" => 'property="og:title" content="유추 학습은 일상생활 전이에 어떻게 연결되는가"',
    "Open Graph URL" => %(property="og:url" content="#{analogy_transfer_url}"),
    "published time" => 'property="article:published_time" content="2026-06-26T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{analogy_transfer_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-26T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-26T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{analogy_transfer_url}")
  }.each do |label, marker|
    errors << "#{analogy_transfer_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{analogy_transfer_path}: public article prose must use 지적장애인"
  end
end

english_essay_path = "archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html"
english_essay_url = "https://yunycho.github.io/naljabooks-blog/archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/"
english_essay = SITE.join(english_essay_path)

if english_essay.file?
  html = english_essay.read
  {
    "English document language" => '<html lang="en">',
    "Open Graph title" => 'property="og:title" content="At the Edge of Intelligence, We Find What It Means to Be Human."',
    "Open Graph description" => 'property="og:description" content="In the Age of AGI, What My Son Will Teach Humanity"',
    "Open Graph URL" => %(property="og:url" content="#{english_essay_url}"),
    "published time" => 'property="article:published_time" content="2026-06-19T08:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{english_essay_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-19T08:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-19T08:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{english_essay_url}"),
    "parallel publication note" => 'Originally written in Korean and translated into English by the author. Also published on <a href="https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find">Substack</a>.'
  }.each do |label, marker|
    errors << "#{english_essay_path}: missing #{label}" unless html.include?(marker)
  end
  errors << "#{english_essay_path}: obsolete account-name byline remains" if html.include?(">NaljaBook<")
  errors << "#{english_essay_path}: obsolete first-publication label remains" if html.include?("First published on Substack")
  errors << "#{english_essay_path}: Substack is mislabeled as an external source" if html.include?("Original Substack essay")

  article_body = html[%r{<div class="article-body">.*?</div>}m].to_s
  paragraph_count = article_body.scan(%r{<p>}).length
  if paragraph_count < 180
    errors << "#{english_essay_path}: expected complete essay body, found #{paragraph_count} paragraphs"
  end
  {
    "prologue opening" => "It was a summer day.",
    "final signature" => "At the beginning of the Nalza Project",
    "intellectual-disability terminology" => "people with intellectual disabilities"
  }.each do |label, marker|
    errors << "#{english_essay_path}: missing #{label}" unless article_body.include?(marker)
  end
  errors << "#{english_essay_path}: developmental-disability terminology remains" if article_body.match?(/developmental disabilit/i)
  errors << "#{english_essay_path}: Substack subscription prompt leaked into article" if article_body.include?("Thanks for reading NaljaBooks's Substack!")
end

%w[sitemap.xml feed.xml].each do |path|
  next unless SITE.join(path).file?
  errors << "#{path}: missing English essay" unless SITE.join(path).read.include?(english_essay_url)
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

EASY_TEXT_SOURCE = "_posts/2026-06-19-why-easy-text-alone-is-not-enough.md"
if ROOT.join(EASY_TEXT_SOURCE).file?
  source_body = ROOT.join(EASY_TEXT_SOURCE).read.sub(%r{\A---.*?---}m, "")
  if source_body.include?("발달장애")
    errors << "#{EASY_TEXT_SOURCE}: public article prose must use 지적장애인"
  end
end

if errors.empty?
  puts "Site verification passed"
else
  warn errors.join("\n")
  exit 1
end
