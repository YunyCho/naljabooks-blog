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
  "archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인이 갑자기 활동을 거부하거나 화를 내고 자신을 때리면 장애 특성이나 문제행동으로 기록되기 쉽다",
    anchors: %w[summary behavior-signal pain-expression sensory-conditions diagnostic-overshadowing check-order contextual-record conclusion],
    source_count: 4
  },
  "archive/private-speech-is-not-just-problem-behavior/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인이 혼잣말을 하면 주변에서는 이상행동이나 고쳐야 할 습관으로 보기 쉽다",
    anchors: %w[summary self-talk self-instruction emotion-context not-diagnosis changed-pattern nalkku-support conclusion],
    source_count: 4
  },
  "archive/when-yes-is-not-informed-agreement/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인이 “예”라고 답했다고 해서 언제나 충분히 이해하고 자유롭게 선택한 것은 아니다",
    anchors: %w[summary yes-is-not-consent acquiescence power-difference checking-choice refusal-change self-determination conclusion],
    source_count: 4
  },
  "archive/expression-does-not-define-understanding-for-people-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인이 질문에 짧게 답하거나 바로 말하지 못하면",
    anchors: %w[summary expression-not-all communication-layers question-format wait-options self-determination nalkku-support conclusion],
    source_count: 4
  },
  "archive/reading-rights-and-literacy-support-for-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인 독서권과 문해력 지원은 연결되어 있지만 같은 말은 아니다",
    anchors: %w[summary reading-rights literacy-support easy-books reading-programs adulthood nalkku-view conclusion],
    source_count: 4
  },
  "archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "경도 지적장애 청소년·성인의 문해력 지원은 학업 보충이 아니다",
    anchors: %w[summary hidden-difficulty rights adulthood self-determination daily-literacy explicit-support conclusion],
    source_count: 4
  },
  "archive/ai-era-transition-and-intellectual-disability-open-research/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "AI 전환이 모든 사람에게 같은 속도, 같은 방향으로 오지 않는다",
    anchors: %w[summary problem international-trends sdt cognitive-justice inclusive-roadmap executive-function data-self-advocacy learning-evidence korea-policy findings nalkku-view references],
    source_count: 8
  },
  "archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "AI는 지적장애인의 학습을 대신하는 존재가 아니라",
    anchors: %w[summary personalized-materials repeated-practice expression-support accessibility human-role limitations conclusion],
    source_count: 4
  },
  "archive/why-human-review-is-needed-for-ai-learning-materials/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "AI 교육자료는 빠르게 만들 수 있지만",
    anchors: %w[summary ai-errors easy-looking-text adult-respect life-context risk human-review conclusion],
    source_count: 4
  },
  "archive/why-naljakkurumi-uses-ai-and-paper-learning-materials-together/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "날자꾸러미가 AI와 종이 학습지를 함께 쓰는 이유는",
    anchors: %w[summary ai-design paper-pace human-context expression-record support-loop human-centered conclusion],
    source_count: 4
  },
  "archive/why-quality-of-life-matters-more-than-correct-answer-rate/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "정답률은 중요하지만 충분하지 않다",
    anchors: %w[summary score-limits literacy-change quality-of-life self-determination observation nalkku-outcomes conclusion],
    source_count: 4
  },
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

  unless first_regular_story&.include?("지적장애인의 통증과 감각 문제가 지능 탓으로 오인될 때")
    errors << "index.html: pain-and-sensory article is not the newest regular story"
  end
  unless story_list.include?("지적장애인의 혼잣말을 문제행동으로만 보면 놓치는 것")
    errors << "index.html: private-speech article is missing from the right story list"
  end
  unless story_list.include?("지적장애인의 “예”는 언제 진짜 동의가 아닌가")
    errors << "index.html: informed-agreement article is missing from the right story list"
  end
  unless story_list.include?("말로 표현된 것만으로 지적장애인의 이해를 판단하면 안 되는 이유")
    errors << "index.html: expression-support article is missing from the right story list"
  end
  if story_list.include?("경도 지적장애 청소년·성인의 문해력 지원은 왜 필요한가")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("지적장애인 독서권과 문해력 지원의 차이")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("AI 교육자료를 사람이 검토해야 하는 이유")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("AI 시대 전환과 지적장애인: 위험·기회·설계 원칙")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("AI는 지적장애인의 학습을 어떻게 도울 수 있는가")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("정답률보다 삶의 질 변화를 성과로 보는 이유")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("날자꾸러미가 AI와 종이 학습지를 함께 쓰는 이유")
    errors << "index.html: story list must show only latest 4 regular posts"
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
  if story_list.include?("유추 학습은 일상생활 전이에 어떻게 연결되는가")
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
    "quality-of-life article link" => "/naljabooks-blog/archive/why-quality-of-life-matters-more-than-correct-answer-rate/",
    "AI declaration link" => "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/",
    "AI learning-support article link" => "/naljabooks-blog/archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/",
    "AI-era open research link" => "/naljabooks-blog/archive/ai-era-transition-and-intellectual-disability-open-research/",
    "human-reviewed AI learning materials link" => "/naljabooks-blog/archive/why-human-review-is-needed-for-ai-learning-materials/",
    "AI and paper learning materials link" => "/naljabooks-blog/archive/why-naljakkurumi-uses-ai-and-paper-learning-materials-together/",
    "mild intellectual disability literacy link" => "/naljabooks-blog/archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/",
    "reading-rights literacy link" => "/naljabooks-blog/archive/reading-rights-and-literacy-support-for-intellectual-disabilities/",
    "expression-support literacy link" => "/naljabooks-blog/archive/expression-does-not-define-understanding-for-people-with-intellectual-disabilities/",
    "informed-agreement literacy link" => "/naljabooks-blog/archive/when-yes-is-not-informed-agreement/",
    "pain-and-sensory literacy link" => "/naljabooks-blog/archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/"
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
    "latest article" => "지적장애인의 통증과 감각 문제가 지능 탓으로 오인될 때",
    "previous article" => "지적장애인 독서권과 문해력 지원의 차이",
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
quality_of_life_path = "archive/why-quality-of-life-matters-more-than-correct-answer-rate/index.html"
quality_of_life_url = "https://yunycho.github.io/naljabooks-blog/archive/why-quality-of-life-matters-more-than-correct-answer-rate/"
ai_learning_support_path = "archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/index.html"
ai_learning_support_url = "https://yunycho.github.io/naljabooks-blog/archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/"
ai_era_research_path = "archive/ai-era-transition-and-intellectual-disability-open-research/index.html"
ai_era_research_url = "https://yunycho.github.io/naljabooks-blog/archive/ai-era-transition-and-intellectual-disability-open-research/"
human_review_ai_path = "archive/why-human-review-is-needed-for-ai-learning-materials/index.html"
human_review_ai_url = "https://yunycho.github.io/naljabooks-blog/archive/why-human-review-is-needed-for-ai-learning-materials/"
ai_paper_path = "archive/why-naljakkurumi-uses-ai-and-paper-learning-materials-together/index.html"
ai_paper_url = "https://yunycho.github.io/naljabooks-blog/archive/why-naljakkurumi-uses-ai-and-paper-learning-materials-together/"
literacy_support_path = "archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/index.html"
literacy_support_url = "https://yunycho.github.io/naljabooks-blog/archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/"
reading_rights_path = "archive/reading-rights-and-literacy-support-for-intellectual-disabilities/index.html"
reading_rights_url = "https://yunycho.github.io/naljabooks-blog/archive/reading-rights-and-literacy-support-for-intellectual-disabilities/"
expression_support_path = "archive/expression-does-not-define-understanding-for-people-with-intellectual-disabilities/index.html"
expression_support_url = "https://yunycho.github.io/naljabooks-blog/archive/expression-does-not-define-understanding-for-people-with-intellectual-disabilities/"
informed_agreement_path = "archive/when-yes-is-not-informed-agreement/index.html"
informed_agreement_url = "https://yunycho.github.io/naljabooks-blog/archive/when-yes-is-not-informed-agreement/"
private_speech_path = "archive/private-speech-is-not-just-problem-behavior/index.html"
private_speech_url = "https://yunycho.github.io/naljabooks-blog/archive/private-speech-is-not-just-problem-behavior/"
pain_and_sensory_path = "archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/index.html"
pain_and_sensory_url = "https://yunycho.github.io/naljabooks-blog/archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/"

pain_and_sensory_post = SITE.join(pain_and_sensory_path)
if pain_and_sensory_post.file?
  html = pain_and_sensory_post.read
  {
    "Open Graph title" => 'property="og:title" content="지적장애인의 통증과 감각 문제가 지능 탓으로 오인될 때"',
    "Open Graph description" => 'property="og:description" content="지적장애인의 행동 변화 뒤에는 통증, 청각·시각 문제나 불편한 환경이 있을 수 있습니다. 장애 탓으로 단정하기 전에 직접 묻고 점검할 순서를 설명합니다."',
    "Open Graph URL" => %(property="og:url" content="#{pain_and_sensory_url}"),
    "published time" => 'property="article:published_time" content="2026-07-31T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{pain_and_sensory_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-31T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-31T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{pain_and_sensory_url}")
  }.each do |label, marker|
    errors << "#{pain_and_sensory_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{pain_and_sensory_path}: public article prose must use 지적장애인"
  end
end

private_speech_post = SITE.join(private_speech_path)
if private_speech_post.file?
  html = private_speech_post.read
  {
    "Open Graph URL" => %(property="og:url" content="#{private_speech_url}"),
    "published time" => 'property="article:published_time" content="2026-07-28T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{private_speech_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-28T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-28T00:00:00+09:00"'
  }.each do |label, marker|
    errors << "#{private_speech_path}: missing #{label}" unless html.include?(marker)
  end
end

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

sitemap = SITE.join("sitemap.xml")
if sitemap.file?
  sitemap_text = sitemap.read
  errors << "sitemap.xml: missing easy-text article" unless sitemap_text.include?(easy_text_url)
  errors << "sitemap.xml: missing easy-information article" unless sitemap_text.include?(easy_information_url)
  errors << "sitemap.xml: missing analogy transfer article" unless sitemap_text.include?(analogy_transfer_url)
  errors << "sitemap.xml: missing learning-rights article" unless sitemap_text.include?(learning_rights_url)
  errors << "sitemap.xml: missing quality-of-life article" unless sitemap_text.include?(quality_of_life_url)
  errors << "sitemap.xml: missing AI learning-support article" unless sitemap_text.include?(ai_learning_support_url)
  errors << "sitemap.xml: missing AI-era open research article" unless sitemap_text.include?(ai_era_research_url)
  errors << "sitemap.xml: missing human-reviewed AI learning materials article" unless sitemap_text.include?(human_review_ai_url)
  errors << "sitemap.xml: missing AI and paper learning materials article" unless sitemap_text.include?(ai_paper_url)
  errors << "sitemap.xml: missing mild intellectual disability literacy article" unless sitemap_text.include?(literacy_support_url)
  errors << "sitemap.xml: missing reading-rights article" unless sitemap_text.include?(reading_rights_url)
  errors << "sitemap.xml: missing expression-support article" unless sitemap_text.include?(expression_support_url)
  errors << "sitemap.xml: missing informed-agreement article" unless sitemap_text.include?(informed_agreement_url)
  errors << "sitemap.xml: missing private-speech article" unless sitemap_text.include?(private_speech_url)
  errors << "sitemap.xml: missing pain-and-sensory article" unless sitemap_text.include?(pain_and_sensory_url)
end

feed = SITE.join("feed.xml")
if feed.file?
  feed_text = feed.read
  errors << "feed.xml: missing expression-support article" unless feed_text.include?(expression_support_url)
  errors << "feed.xml: missing informed-agreement article" unless feed_text.include?(informed_agreement_url)
  errors << "feed.xml: missing private-speech article" unless feed_text.include?(private_speech_url)
  errors << "feed.xml: missing pain-and-sensory article" unless feed_text.include?(pain_and_sensory_url)
  errors << "feed.xml: missing reading-rights article" unless feed_text.include?(reading_rights_url)
  errors << "feed.xml: missing mild intellectual disability literacy article" unless feed_text.include?(literacy_support_url)
  errors << "feed.xml: missing AI and paper learning materials article" unless feed_text.include?(ai_paper_url)
  errors << "feed.xml: missing human-reviewed AI learning materials article" unless feed_text.include?(human_review_ai_url)
  errors << "feed.xml: missing AI-era open research article" unless feed_text.include?(ai_era_research_url)
end

informed_agreement_post = SITE.join(informed_agreement_path)
if informed_agreement_post.file?
  html = informed_agreement_post.read
  {
    "Open Graph title" => 'property="og:title" content="지적장애인의 “예”는 언제 진짜 동의가 아닌가"',
    "Open Graph description" => 'property="og:description" content="지적장애인이 질문에 “예”라고 답했더라도 충분히 이해하고 선택한 동의인지 확인해야 합니다. 묵종을 줄이는 질문 방식과 자기결정 지원 원칙을 설명합니다."',
    "Open Graph URL" => %(property="og:url" content="#{informed_agreement_url}"),
    "published time" => 'property="article:published_time" content="2026-07-24T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{informed_agreement_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-24T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-24T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{informed_agreement_url}")
  }.each do |label, marker|
    errors << "#{informed_agreement_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{informed_agreement_path}: public article prose must use 지적장애인"
  end
end

expression_support_post = SITE.join(expression_support_path)
if expression_support_post.file?
  html = expression_support_post.read
  {
    "Open Graph title" => 'property="og:title" content="말로 표현된 것만으로 지적장애인의 이해를 판단하면 안 되는 이유"',
    "Open Graph description" => 'property="og:description" content="지적장애인의 표현 언어와 읽기이해는 같은 수준으로 드러나지 않을 수 있습니다. 말로 나온 답만으로 이해 능력을 단정하지 않고 표현 지원과 기다림이 필요한 이유를 설명합니다."',
    "Open Graph URL" => %(property="og:url" content="#{expression_support_url}"),
    "published time" => 'property="article:published_time" content="2026-07-21T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{expression_support_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-21T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-21T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{expression_support_url}")
  }.each do |label, marker|
    errors << "#{expression_support_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{expression_support_path}: public article prose must use 지적장애인"
  end
end

reading_rights_post = SITE.join(reading_rights_path)
if reading_rights_post.file?
  html = reading_rights_post.read
  {
    "Open Graph title" => 'property="og:title" content="지적장애인 독서권과 문해력 지원의 차이"',
    "Open Graph description" => 'property="og:description" content="지적장애인 독서권은 책과 쉬운 정보에 접근할 권리이고, 문해력 지원은 읽기이해와 자기표현을 거쳐 배운 것이 삶으로 이어지도록 돕는 과정입니다."',
    "Open Graph URL" => %(property="og:url" content="#{reading_rights_url}"),
    "published time" => 'property="article:published_time" content="2026-07-18T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{reading_rights_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-18T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-18T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{reading_rights_url}")
  }.each do |label, marker|
    errors << "#{reading_rights_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{reading_rights_path}: public article prose must use 지적장애인"
  end
end

literacy_support_post = SITE.join(literacy_support_path)
if literacy_support_post.file?
  html = literacy_support_post.read
  {
    "Open Graph title" => 'property="og:title" content="경도 지적장애 청소년·성인의 문해력 지원은 왜 필요한가"',
    "Open Graph URL" => %(property="og:url" content="#{literacy_support_url}"),
    "published time" => 'property="article:published_time" content="2026-07-14T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{literacy_support_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-14T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-14T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{literacy_support_url}")
  }.each do |label, marker|
    errors << "#{literacy_support_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{literacy_support_path}: public article prose must use 지적장애인"
  end
end

ai_paper_post = SITE.join(ai_paper_path)
if ai_paper_post.file?
  html = ai_paper_post.read
  {
    "Open Graph title" => 'property="og:title" content="날자꾸러미가 AI와 종이 학습지를 함께 쓰는 이유"',
    "Open Graph URL" => %(property="og:url" content="#{ai_paper_url}"),
    "published time" => 'property="article:published_time" content="2026-07-10T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{ai_paper_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-10T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-10T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{ai_paper_url}")
  }.each do |label, marker|
    errors << "#{ai_paper_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{ai_paper_path}: public article prose must use 지적장애인"
  end
end

human_review_ai_post = SITE.join(human_review_ai_path)
if human_review_ai_post.file?
  html = human_review_ai_post.read
  {
    "Open Graph title" => 'property="og:title" content="AI 교육자료를 사람이 검토해야 하는 이유"',
    "Open Graph URL" => %(property="og:url" content="#{human_review_ai_url}"),
    "published time" => 'property="article:published_time" content="2026-07-07T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{human_review_ai_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-07T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-07T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{human_review_ai_url}")
  }.each do |label, marker|
    errors << "#{human_review_ai_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{human_review_ai_path}: public article prose must use 지적장애인"
  end
end

ai_era_research_post = SITE.join(ai_era_research_path)
if ai_era_research_post.file?
  html = ai_era_research_post.read
  {
    "Open Graph title" => 'property="og:title" content="AI 시대 전환과 지적장애인: 위험·기회·설계 원칙"',
    "Open Graph URL" => %(property="og:url" content="#{ai_era_research_url}"),
    "published time" => 'property="article:published_time" content="2026-07-03T16:55:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{ai_era_research_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-03T16:55:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-03T16:55:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{ai_era_research_url}")
  }.each do |label, marker|
    errors << "#{ai_era_research_path}: missing #{label}" unless html.include?(marker)
  end
end

ai_learning_support_post = SITE.join(ai_learning_support_path)
if ai_learning_support_post.file?
  html = ai_learning_support_post.read
  {
    "Open Graph title" => 'property="og:title" content="AI는 지적장애인의 학습을 어떻게 도울 수 있는가"',
    "Open Graph URL" => %(property="og:url" content="#{ai_learning_support_url}"),
    "published time" => 'property="article:published_time" content="2026-07-03T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{ai_learning_support_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-07-03T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-03T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{ai_learning_support_url}")
  }.each do |label, marker|
    errors << "#{ai_learning_support_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{ai_learning_support_path}: public article prose must use 지적장애인"
  end
end

quality_of_life_post = SITE.join(quality_of_life_path)
if quality_of_life_post.file?
  html = quality_of_life_post.read
  {
    "Open Graph title" => 'property="og:title" content="정답률보다 삶의 질 변화를 성과로 보는 이유"',
    "Open Graph URL" => %(property="og:url" content="#{quality_of_life_url}"),
    "published time" => 'property="article:published_time" content="2026-06-30T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{quality_of_life_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-30T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-30T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{quality_of_life_url}")
  }.each do |label, marker|
    errors << "#{quality_of_life_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{quality_of_life_path}: public article prose must use 지적장애인"
  end
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

if sitemap.file?
  errors << "sitemap.xml: missing English essay" unless sitemap.read.include?(english_essay_url)
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
