#!/usr/bin/env ruby

require "pathname"
require "date"
require "json"
require "yaml"

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
  llms-full.txt
  llms-en.txt
  content/index.json
  content/en/index.json
  feed.json
  en/feed.json
  en/index.html
  en/about/index.html
  en/methodology/index.html
  en/topics/index.html
  d16572b6a4c3cec49332e841d46eb2f2.txt
].freeze

POSTS = {
  "archive/intellectual-disability-learning-motivation-challenge-and-retry/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인 학습 동기를 지키는 방법은 실패를 모두 없애거나 어려운 과제를 그대로 견디게 하는 것 가운데 하나를 고르는 일이 아니다",
    anchors: %w[summary failure-risk challenge evidence-limits design feedback observe checklist conclusion],
    source_count: 4
  },
  "archive/adult-developmental-disability-reading-program-beyond-decoding/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "성인 발달장애인 독서 프로그램은 문장을 소리 내어 읽고 문제에 답하는 활동만을 뜻하지 않는다",
    anchors: %w[summary goals adult-learning wordless-books pictures adult-respect outcomes checklist conclusion],
    source_count: 4
  },
  "archive/intellectual-disability-safety-education-needs-practice/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인 안전 교육은 위험한 상황을 설명하는 데서 끝나면 안 된다",
    anchors: %w[summary knowledge-action practice routine varied-situations support-network limits checklist conclusion],
    source_count: 3
  },
  "archive/why-self-advocate-review-must-start-at-planning/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인 당사자 검수는 완성된 원고의 마지막 오탈자 확인이 아니다",
    anchors: %w[summary final-check limits planning process meetings payment scope checklist conclusion],
    source_count: 3
  },
  "archive/self-determination-education-beyond-offering-choices/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "선택지를 주는 것은 자기결정 교육의 시작이지만 끝은 아니다",
    anchors: %w[summary distinction cycle support practice record checklist conclusion],
    source_count: 4
  },
  "archive/how-and-when-to-fade-prompts-for-intellectual-disability-learning/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "힌트의 목적은 정답을 대신 주는 것이 아니라",
    anchors: %w[summary definition readiness choose-procedure fade-step observe dependency checklist conclusion],
    source_count: 4
  },
  "archive/adult-respectful-learning-materials-for-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "쉬운 학습자료와 유아적인 학습자료는 같은 말이 아니다",
    anchors: %w[summary distinction topics language design choices review checklist conclusion],
    source_count: 3
  },
  "archive/what-adults-with-developmental-disabilities-want-to-learn/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "성인 발달장애인은 무엇을 배우고 싶어 할까",
    anchors: %w[summary survey-scope learner-answers guardian-answers interpretation program-design conclusion],
    source_count: 1
  },
  "archive/safety-literacy-against-counterfeit-friendship/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "친구라고 부르는 사람이 돈, 집, 물건이나 몸의 경계를 반복해서 침해한다면",
    anchors: %w[summary definition evidence relationship-needs warning-signs boundaries response trusted-person safety-literacy conclusion],
    source_count: 4
  },
  "archive/diagnostic-overshadowing-and-intellectual-disability/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "한 사람의 두드러진 진단이 다른 증상과 필요를 가려 버리는 판단의 오류를 말한다",
    anchors: %w[summary definition original-study evidence risk consequences education-boundary nalkku conclusion],
    source_count: 8
  },
  "archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "성인 지적장애인 평생교육 프로그램은 학교에서 배운 내용을 반복하는 데서 끝나지 않아야 한다",
    anchors: %w[summary lifelong-learning nalkku-definition learning-cycle learning-tools levels-and-udl ai-and-paper outcomes honest-boundaries conclusion],
    source_count: 4
  },
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
    required_text: "경도 지적장애 문해력 교육은 청소년·성인의 학업 보충만을 뜻하지 않는다",
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
    required_text: "특수교육 AI는 지적장애인의 학습을 대신하는 존재가 아니라",
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
    required_text: "지적장애인 쉬운 정보와 읽기이해는 같지 않다",
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
    author: "Yunyoung Cho",
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
    required_text: "지적장애인 유추 학습은",
    anchors: %w[analogy daily-life learning principles nalja-view summary]
  },
  "archive/ai-must-benefit-people-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 대표 조윤영",
    required_text: "AI는 지적장애인의 이해와 선택, 참여를 넓혀야 한다",
    anchors: %w[mothers-question declaration practical-benefits decision-boundary principles risks nalja-promise]
  }
}.freeze

SEO_PILLARS = {
  "_posts/2026-09-01-intellectual-disability-learning-motivation-challenge-and-retry.md" => {
    primary_query: "지적장애인 학습 동기",
    bridge_queries: ["발달장애 학습 동기", "발달장애 학습"],
    related_urls: %w[
      /archive/how-and-when-to-fade-prompts-for-intellectual-disability-learning/
      /archive/self-determination-education-beyond-offering-choices/
      /archive/why-quality-of-life-matters-more-than-correct-answer-rate/
    ],
    updated: Date.new(2026, 9, 1)
  },
  "_posts/2026-08-28-adult-developmental-disability-reading-program-beyond-decoding.md" => {
    primary_query: "성인 발달장애인 독서 프로그램",
    bridge_queries: ["발달장애 평생교육 프로그램", "발달장애인 문해력 교육"],
    related_urls: %w[
      /archive/reading-rights-and-literacy-support-for-intellectual-disabilities/
      /archive/adult-respectful-learning-materials-for-intellectual-disabilities/
      /archive/easy-information-and-reading-comprehension/
      /archive/what-adults-with-developmental-disabilities-want-to-learn/
    ],
    updated: Date.new(2026, 8, 28)
  },
  "_posts/2026-08-25-intellectual-disability-safety-education-needs-practice.md" => {
    primary_query: "지적장애인 안전 교육",
    bridge_queries: ["발달장애 안전 교육", "발달장애인 범죄 예방 교육"],
    related_urls: %w[
      /archive/safety-literacy-against-counterfeit-friendship/
      /archive/when-yes-is-not-informed-agreement/
      /archive/analogy-learning-and-transfer-to-daily-life/
    ],
    updated: Date.new(2026, 8, 25)
  },
  "_posts/2026-08-21-why-self-advocate-review-must-start-at-planning.md" => {
    primary_query: "지적장애인 당사자 검수",
    bridge_queries: ["지적장애인 공동설계", "발달장애인 당사자 참여"],
    related_urls: %w[
      /archive/adult-respectful-learning-materials-for-intellectual-disabilities/
      /archive/easy-information-and-reading-comprehension/
      /archive/when-yes-is-not-informed-agreement/
    ],
    updated: Date.new(2026, 8, 21)
  },
  "_posts/2026-08-18-self-determination-education-beyond-offering-choices.md" => {
    primary_query: "발달장애인 자기결정 교육",
    bridge_queries: ["발달장애 선택 교육", "지적장애인 자기결정 지원"],
    related_urls: %w[
      /archive/when-yes-is-not-informed-agreement/
      /archive/what-adults-with-developmental-disabilities-want-to-learn/
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
    ],
    updated: Date.new(2026, 8, 18)
  },
  "_posts/2026-08-14-how-and-when-to-fade-prompts-for-intellectual-disability-learning.md" => {
    primary_query: "지적장애인 힌트 줄이기",
    bridge_queries: ["발달장애 학습 힌트", "발달장애 프롬프트 페이딩"],
    related_urls: %w[
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
      /archive/adult-respectful-learning-materials-for-intellectual-disabilities/
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
    ],
    updated: Date.new(2026, 8, 14)
  },
  "_posts/2026-08-11-adult-respectful-learning-materials-for-intellectual-disabilities.md" => {
    primary_query: "성인 지적장애인 학습자료",
    bridge_queries: ["발달장애인 학습자료", "성인 발달장애 학습", "발달장애 평생교육 자료"],
    related_urls: %w[
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
      /archive/easy-information-and-reading-comprehension/
    ],
    updated: Date.new(2026, 8, 11)
  },
  "_posts/2026-08-07-what-adults-with-developmental-disabilities-want-to-learn.md" => {
    primary_query: "성인 발달장애인 평생교육 수요",
    bridge_queries: ["발달장애인 평생교육", "성인 발달장애 학습", "발달장애인 교육 수요"],
    related_urls: %w[
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
      /archive/learning-rights-and-literacy-support-for-intellectual-disabilities/
    ],
    updated: Date.new(2026, 8, 7)
  },
  "_posts/2026-08-04-safety-literacy-against-counterfeit-friendship.md" => {
    primary_query: "지적장애인 안전 문해력",
    bridge_queries: ["발달장애 안전 교육", "발달장애인 관계 교육"],
    related_urls: %w[
      /archive/when-yes-is-not-informed-agreement/
      /archive/analogy-learning-and-transfer-to-daily-life/
      /archive/why-quality-of-life-matters-more-than-correct-answer-rate/
    ],
    updated: Date.new(2026, 8, 4)
  },
  "_posts/2026-08-01-how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities.md" => {
    primary_query: "성인 지적장애인 평생교육 프로그램",
    bridge_queries: ["발달장애인 평생교육", "성인 발달장애 학습", "발달장애 평생교육 프로그램"],
    related_urls: %w[
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
      /archive/why-analogy-matters/
      /archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/
    ]
  },
  "_posts/2026-07-14-why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults.md" => {
    primary_query: "경도 지적장애 문해력 교육",
    bridge_queries: ["발달장애 문해력 교육", "발달장애 학습", "성인 발달장애 학습"],
    related_urls: %w[
      /archive/easy-information-and-reading-comprehension/
      /archive/learning-rights-and-literacy-support-for-intellectual-disabilities/
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
    ]
  },
  "_posts/2026-06-15-why-analogy-matters.md" => {
    primary_query: "지적장애인 유추 학습",
    bridge_queries: ["발달장애 학습", "발달장애 성장", "발달장애 유추 학습"],
    related_urls: %w[
      /archive/analogy-learning-and-transfer-to-daily-life/
      /archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
    ]
  },
  "_posts/2026-06-23-easy-information-and-reading-comprehension.md" => {
    primary_query: "지적장애인 쉬운 정보",
    bridge_queries: ["발달장애인 쉬운 정보", "발달장애 읽기 자료", "발달장애 문해력"],
    related_urls: %w[
      /archive/why-easy-text-alone-is-not-enough/
      /archive/why-literacy-support-is-needed-for-mild-intellectual-disability-youth-and-adults/
      /archive/reading-rights-and-literacy-support-for-intellectual-disabilities/
    ]
  },
  "_posts/2026-07-03-how-ai-can-support-learning-for-people-with-intellectual-disabilities.md" => {
    primary_query: "특수교육 AI",
    bridge_queries: ["발달장애 AI 교육", "발달장애 AI 학습", "발달장애 특수교육 AI"],
    related_urls: %w[
      /archive/why-human-review-is-needed-for-ai-learning-materials/
      /archive/why-naljakkurumi-uses-ai-and-paper-learning-materials-together/
      /archive/ai-era-transition-and-intellectual-disability-open-research/
    ]
  }
}.freeze

errors = []

SEO_PILLARS.each do |relative_path, expected|
  source = ROOT.join(relative_path)
  unless source.file?
    errors << "#{relative_path}: missing SEO pillar source"
    next
  end

  raw = source.read
  front_matter = raw[/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m, 1].to_s
  body = raw.sub(/\A---\s*\n.*?\n---\s*(?:\n|\z)/m, "")
  data = YAML.safe_load(front_matter, permitted_classes: [Date], aliases: true) || {}
  seo = data.fetch("seo", {})
  primary_query = expected.fetch(:primary_query)
  bridge_queries = expected.fetch(:bridge_queries)
  intro = body.split(/^##\s/, 2).first.to_s

  errors << "#{relative_path}: seo.primary_query must be #{primary_query.inspect}" unless seo["primary_query"] == primary_query
  if seo["search_intent"].to_s.strip.empty?
    errors << "#{relative_path}: missing seo.search_intent"
  end
  unless seo["secondary_queries"].is_a?(Array) && seo["secondary_queries"].length >= 2
    errors << "#{relative_path}: seo.secondary_queries must include at least two queries"
  end
  unless seo["bridge_queries"] == bridge_queries
    errors << "#{relative_path}: seo.bridge_queries must be #{bridge_queries.inspect}"
  end

  {
    "title" => data["title"].to_s,
    "description" => data["description"].to_s,
    "tags" => Array(data["tags"]).join(" "),
    "intro" => intro
  }.each do |field, value|
    errors << "#{relative_path}: #{field} must include primary query #{primary_query.inspect}" unless value.include?(primary_query)
  end

  bridge_queries.each do |query|
    errors << "#{relative_path}: tags must include bridge query #{query.inspect}" unless Array(data["tags"]).include?(query)
    errors << "#{relative_path}: intro must include bridge query #{query.inspect}" unless intro.include?(query)
  end
  errors << "#{relative_path}: description must connect the developmental-disability bridge" unless data["description"].to_s.include?("발달장애")
  unless intro.include?("지적장애인과 자폐성장애인") && intro.include?("넓은")
    errors << "#{relative_path}: intro must explain that 발달장애 is broader than the article's 지적장애 scope"
  end

  related_slugs = Array(data["related"])
  expected.fetch(:related_urls).each do |url|
    slug = url.split("/").reject(&:empty?).last
    errors << "#{relative_path}: missing related post #{slug}" unless related_slugs.include?(slug)
  end
  expected_updated = expected.fetch(:updated, Date.new(2026, 8, 1))
  unless data["updated"] == expected_updated
    errors << "#{relative_path}: updated must be #{expected_updated} for this SEO revision"
  end
  unless data["last_modified_at"] == expected_updated
    errors << "#{relative_path}: last_modified_at must be #{expected_updated} for search metadata"
  end

  slug = File.basename(relative_path, ".md").sub(/^\d{4}-\d{2}-\d{2}-/, "")
  built_post = SITE.join("archive", slug, "index.html")
  if built_post.file?
    html = built_post.read
    errors << "#{built_post.relative_path_from(SITE)}: rendered h1 must include #{primary_query.inspect}" unless html.match?(%r{<h1>[^<]*#{Regexp.escape(primary_query)}[^<]*</h1>})
    errors << "#{built_post.relative_path_from(SITE)}: missing related-reading navigation" unless html.include?('class="related-reading"')
    expected_modified = expected_updated.strftime("%Y-%m-%d")
    errors << "#{built_post.relative_path_from(SITE)}: revised JSON-LD dateModified must be #{expected_modified}" unless html.include?(%("dateModified":"#{expected_modified}T00:00:00+09:00"))
    bridge_queries.each do |query|
      errors << "#{built_post.relative_path_from(SITE)}: missing rendered bridge query #{query.inspect}" unless html.include?(query)
    end
    expected.fetch(:related_urls).each do |url|
      rendered_url = "#{BASEURL}#{url}"
      errors << "#{built_post.relative_path_from(SITE)}: missing rendered related link #{rendered_url}" unless html.include?(%(href="#{rendered_url}"))
    end
  end
end

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

post_count = Dir.glob(ROOT.join("_posts/*.md")).length
english_collection_count = Dir.glob(ROOT.join("_english/*.md")).length
legacy_english_count = Dir.glob(ROOT.join("_posts/*.md")).count do |path|
  File.read(path)[/^lang:\s*en\s*$/, 0]
end
english_count = english_collection_count + legacy_english_count
korean_count = post_count - legacy_english_count
all_content_count = post_count + english_collection_count

llms = SITE.join("llms.txt")
if llms.file?
  llms_text = llms.read
  indexed_posts = llms_text.scan(/^### /).length
  errors << "llms.txt: expected #{all_content_count} articles, found #{indexed_posts}" unless indexed_posts == all_content_count
  errors << "llms.txt: missing full-text corpus link" unless llms_text.include?("/llms-full.txt")
  errors << "llms.txt: missing content index link" unless llms_text.include?("/content/index.json")
end

llms_full = SITE.join("llms-full.txt")
if llms_full.file?
  full_text = llms_full.read
  indexed_posts = full_text.scan(/^## /).length
  errors << "llms-full.txt: expected #{all_content_count} articles, found #{indexed_posts}" unless indexed_posts == all_content_count
  errors << "llms-full.txt: missing article sources" unless full_text.include?("### 출처")
end

llms_en = SITE.join("llms-en.txt")
if llms_en.file?
  english_text = llms_en.read
  indexed_posts = english_text.scan(/^### /).length
  errors << "llms-en.txt: expected #{english_count} articles, found #{indexed_posts}" unless indexed_posts == english_count
  errors << "llms-en.txt: missing Korean-original links" unless english_text.include?("Korean original:")
end

{
  "content/index.json" => all_content_count,
  "feed.json" => korean_count,
  "content/en/index.json" => english_count,
  "en/feed.json" => english_count
}.each do |path, expected_count|
  file = SITE.join(path)
  next unless file.file?

  begin
    payload = JSON.parse(file.read)
    item_count = Array(payload["items"]).length
    errors << "#{path}: expected #{expected_count} items, found #{item_count}" unless item_count == expected_count
  rescue JSON::ParserError => error
    errors << "#{path}: invalid JSON (#{error.message})"
  end
end

english_home = SITE.join("en/index.html")
if english_home.file?
  html = english_home.read
  errors << "en/index.html: document language must be English" unless html.include?('<html lang="en">')
  errors << "en/index.html: missing English archive identity" unless html.include?("Nalja Archive in English")
  errors << "en/index.html: missing Korean language switch" unless html.include?('lang="ko">한국어</a>')
  errors << "en/index.html: English author metadata is missing" unless html.include?('"name":"Nalja Books and Nalkku Editorial Team"')
  errors << "en/index.html: English publisher metadata is missing" unless html.include?('"publisher":{"@type":"Organization"') && html.include?('"name":"Nalja Books and Nalkku Editorial Team"')
  errors << "en/index.html: English organization description is missing" unless html.include?("The editorial team behind Nalja Archive")
  errors << "en/index.html: Korean organization metadata remains" if html.include?('"name":"도서출판 날자 · 날자꾸러미 편집부"')
  article_count = html.scan(%r{<article class="archive-list-item">}).length
  errors << "en/index.html: expected #{english_count} English articles, found #{article_count}" unless article_count == english_count
end

Dir.glob(SITE.join("en/**/*.html")).each do |path|
  html = File.read(path)
  relative = Pathname.new(path).relative_path_from(SITE)
  errors << "#{relative}: missing English organization entity" unless html.include?('"@id": "https://yunycho.github.io/naljabooks-blog/en/about/#organization"')
  errors << "#{relative}: Korean organization metadata remains" if html.include?('"name":"도서출판 날자 · 날자꾸러미 편집부"')
end

indexnow_key = SITE.join("d16572b6a4c3cec49332e841d46eb2f2.txt")
if indexnow_key.file?
  expected_key = "d16572b6a4c3cec49332e841d46eb2f2"
  errors << "IndexNow key file: unexpected content" unless indexnow_key.read.strip == expected_key
end

ENGLISH_TRANSLATIONS = {
  "ai-must-benefit-people-with-intellectual-disabilities" => "ai-must-benefit-people-with-intellectual-disabilities",
  "why-analogy-matters" => "why-analogy-matters",
  "how-ai-can-support-learning-for-people-with-intellectual-disabilities" => "how-ai-can-support-learning-for-people-with-intellectual-disabilities",
  "how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities" => "how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities"
}.freeze

ENGLISH_TRANSLATIONS.each do |english_slug, korean_slug|
  path = SITE.join("en/archive", english_slug, "index.html")
  unless path.file?
    errors << "missing en/archive/#{english_slug}/index.html"
    next
  end

  html = path.read
  korean_url = "#{BASEURL}/archive/#{korean_slug}/"
  english_url = "#{BASEURL}/en/archive/#{english_slug}/"
  errors << "#{path.relative_path_from(SITE)}: document language must be English" unless html.include?('<html lang="en">')
  errors << "#{path.relative_path_from(SITE)}: missing Korean alternate" unless html.include?(%(hreflang="ko-KR" href="https://yunycho.github.io#{korean_url}"))
  errors << "#{path.relative_path_from(SITE)}: missing English alternate" unless html.include?(%(hreflang="en" href="https://yunycho.github.io#{english_url}"))
  errors << "#{path.relative_path_from(SITE)}: missing translation note" unless html.include?("the Korean article</a> is authoritative")
  errors << "#{path.relative_path_from(SITE)}: Korean article URL missing" unless html.include?(%(href="#{korean_url}"))
  errors << "#{path.relative_path_from(SITE)}: missing English editorial policy" unless html.include?("Read the editorial and correction policy")
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

  unless first_regular_story&.include?("지적장애인 학습 동기, 쉬운 성공만 반복하면 될까")
    errors << "index.html: intellectual disability learning motivation article is not the newest regular story"
  end
  if story_list.include?("지적장애인 안전 문해력: 친구라는 이름의 착취를 알아차리는 법")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("성인 발달장애인 평생교육 수요: 무엇을 배우고 싶어 하는가")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("진단 가림 현상이란? 지적장애인의 다른 어려움을 장애 탓으로 돌릴 때")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("지적장애인의 통증과 감각 문제가 지능 탓으로 오인될 때")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("지적장애인의 혼잣말을 문제행동으로만 보면 놓치는 것")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("지적장애인의 “예”는 언제 진짜 동의가 아닌가")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("말로 표현된 것만으로 지적장애인의 이해를 판단하면 안 되는 이유")
    errors << "index.html: story list must show only latest 4 regular posts"
  end
  if story_list.include?("경도 지적장애 문해력 교육, 청소년·성인에게 왜 필요한가")
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
  if story_list.include?("특수교육 AI, 지적장애인의 학습을 어떻게 도울 수 있는가")
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
    "topics heading" => "발달장애 학습과 성장: 지적장애인의 배움과 권리 안내",
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
    "pain-and-sensory literacy link" => "/naljabooks-blog/archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/",
    "diagnostic-overshadowing link" => "/naljabooks-blog/archive/diagnostic-overshadowing-and-intellectual-disability/",
    "safety-literacy link" => "/naljabooks-blog/archive/safety-literacy-against-counterfeit-friendship/",
    "education-demand link" => "/naljabooks-blog/archive/what-adults-with-developmental-disabilities-want-to-learn/",
    "adult-respectful learning materials link" => "/naljabooks-blog/archive/adult-respectful-learning-materials-for-intellectual-disabilities/",
    "prompt-fading link" => "/naljabooks-blog/archive/how-and-when-to-fade-prompts-for-intellectual-disability-learning/",
    "self-determination education link" => "/naljabooks-blog/archive/self-determination-education-beyond-offering-choices/",
    "self-advocate review link" => "/naljabooks-blog/archive/why-self-advocate-review-must-start-at-planning/",
    "adult developmental disability reading program link" => "/naljabooks-blog/archive/adult-developmental-disability-reading-program-beyond-decoding/",
    "learning motivation article link" => "/naljabooks-blog/archive/intellectual-disability-learning-motivation-challenge-and-retry/",
    "Nalkku lifelong-learning pillar link" => "/naljabooks-blog/archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/",
    "developmental learning hub" => "발달장애 학습과 성장",
    "developmental scope" => "지적장애인과 자폐성장애인 등을 포괄하는 넓은 범주",
    "developmental literacy query" => "발달장애 문해력 교육",
    "developmental AI query" => "발달장애 AI 교육"
  }.each do |label, marker|
    errors << "topics/index.html: missing #{label}" unless html.include?(marker)
  end
end

archive = SITE.join("archive/index.html")
if archive.file?
  html = archive.read
  {
    "archive heading" => "전체 글",
    "pinned declaration" => "AI must benefit people with intellectual disabilities",
    "newest learning motivation article" => "지적장애인 학습 동기, 쉬운 성공만 반복하면 될까",
    "latest article" => "지적장애인 힌트 줄이기: 학습에서 언제, 어떻게 줄여야 할까",
    "previous article" => "지적장애인 독서권과 문해력 지원의 차이",
    "old regular article" => "지적장애인 유추 학습, 왜 필요하고 어떻게 가르칠까?",
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
    unless html.include?("확인 가능한 원문을 출처로 연결했습니다") ||
           html.include?("link to verifiable primary sources")
      errors << "#{path}: sourced method note is missing"
    end
  elsif !html.include?("글쓴이의 관점과 경험을 바탕으로 작성했습니다") &&
        !html.include?("reflects the author&#39;s perspective and experience") &&
        !html.include?("reflects the author's perspective and experience")
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
  errors << "#{path}: raw Markdown emphasis syntax is visible" if html.include?("**")
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
self_advocate_review_url = "https://yunycho.github.io/naljabooks-blog/archive/why-self-advocate-review-must-start-at-planning/"
intellectual_disability_safety_education_url = "https://yunycho.github.io/naljabooks-blog/archive/intellectual-disability-safety-education-needs-practice/"
private_speech_path = "archive/private-speech-is-not-just-problem-behavior/index.html"
private_speech_url = "https://yunycho.github.io/naljabooks-blog/archive/private-speech-is-not-just-problem-behavior/"
pain_and_sensory_path = "archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/index.html"
pain_and_sensory_url = "https://yunycho.github.io/naljabooks-blog/archive/pain-and-sensory-needs-mistaken-for-intellectual-disability/"
nalkku_lifelong_path = "archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/index.html"
nalkku_lifelong_url = "https://yunycho.github.io/naljabooks-blog/archive/how-naljakkurumi-designs-lifelong-learning-for-adults-with-intellectual-disabilities/"
diagnostic_overshadowing_url = "https://yunycho.github.io/naljabooks-blog/archive/diagnostic-overshadowing-and-intellectual-disability/"
safety_literacy_url = "https://yunycho.github.io/naljabooks-blog/archive/safety-literacy-against-counterfeit-friendship/"
education_demand_url = "https://yunycho.github.io/naljabooks-blog/archive/what-adults-with-developmental-disabilities-want-to-learn/"
adult_respectful_materials_url = "https://yunycho.github.io/naljabooks-blog/archive/adult-respectful-learning-materials-for-intellectual-disabilities/"
prompt_fading_url = "https://yunycho.github.io/naljabooks-blog/archive/how-and-when-to-fade-prompts-for-intellectual-disability-learning/"
self_determination_education_url = "https://yunycho.github.io/naljabooks-blog/archive/self-determination-education-beyond-offering-choices/"
adult_reading_program_url = "https://yunycho.github.io/naljabooks-blog/archive/adult-developmental-disability-reading-program-beyond-decoding/"
learning_motivation_url = "https://yunycho.github.io/naljabooks-blog/archive/intellectual-disability-learning-motivation-challenge-and-retry/"
prompt_fading_path = "archive/how-and-when-to-fade-prompts-for-intellectual-disability-learning/index.html"
self_determination_education_path = "archive/self-determination-education-beyond-offering-choices/index.html"
ai_learning_support_relative_url = "/naljabooks-blog/archive/how-ai-can-support-learning-for-people-with-intellectual-disabilities/"
self_determination_education_relative_url = "/naljabooks-blog/archive/self-determination-education-beyond-offering-choices/"
learning_motivation_relative_url = "/naljabooks-blog/archive/intellectual-disability-learning-motivation-challenge-and-retry/"

{
  ai_era_research_path => [ai_learning_support_relative_url],
  human_review_ai_path => [ai_learning_support_relative_url],
  ai_paper_path => [ai_learning_support_relative_url],
  informed_agreement_path => [self_determination_education_relative_url],
  prompt_fading_path => [learning_motivation_relative_url],
  self_determination_education_path => [learning_motivation_relative_url],
  quality_of_life_path => [learning_motivation_relative_url]
}.each do |source_path, target_urls|
  source_page = SITE.join(source_path)
  next unless source_page.file?

  html = source_page.read
  target_urls.each do |target_url|
    errors << "#{source_path}: missing discovery link to #{target_url}" unless html.include?(target_url)
  end
end

nalkku_lifelong_post = SITE.join(nalkku_lifelong_path)
if nalkku_lifelong_post.file?
  html = nalkku_lifelong_post.read
  {
    "Open Graph title" => 'property="og:title" content="성인 지적장애인 평생교육 프로그램, 날자꾸러미는 어떻게 설계하는가"',
    "Open Graph description" => 'property="og:description" content="성인 지적장애인 평생교육 프로그램과 발달장애인 평생교육을 찾는 기관과 가족을 위해 문해력·유추·자기표현·일상 전이를 잇는 날자꾸러미의 구성과 운영 원칙을 소개합니다."',
    "Open Graph URL" => %(property="og:url" content="#{nalkku_lifelong_url}"),
    "published time" => 'property="article:published_time" content="2026-08-01T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{nalkku_lifelong_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-08-01T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-08-01T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{nalkku_lifelong_url}")
  }.each do |label, marker|
    errors << "#{nalkku_lifelong_path}: missing #{label}" unless html.include?(marker)
  end
end

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
  errors << "sitemap.xml: missing self-advocate review article" unless sitemap_text.include?(self_advocate_review_url)
  errors << "sitemap.xml: missing safety education practice article" unless sitemap_text.include?(intellectual_disability_safety_education_url)
  errors << "sitemap.xml: missing private-speech article" unless sitemap_text.include?(private_speech_url)
  errors << "sitemap.xml: missing pain-and-sensory article" unless sitemap_text.include?(pain_and_sensory_url)
  errors << "sitemap.xml: missing Nalkku lifelong-learning article" unless sitemap_text.include?(nalkku_lifelong_url)
  errors << "sitemap.xml: missing diagnostic-overshadowing article" unless sitemap_text.include?(diagnostic_overshadowing_url)
  errors << "sitemap.xml: missing safety-literacy article" unless sitemap_text.include?(safety_literacy_url)
  errors << "sitemap.xml: missing education-demand article" unless sitemap_text.include?(education_demand_url)
  errors << "sitemap.xml: missing adult-respectful learning materials article" unless sitemap_text.include?(adult_respectful_materials_url)
  errors << "sitemap.xml: missing prompt-fading article" unless sitemap_text.include?(prompt_fading_url)
  errors << "sitemap.xml: missing self-determination education article" unless sitemap_text.include?(self_determination_education_url)
  errors << "sitemap.xml: missing adult reading program article" unless sitemap_text.include?(adult_reading_program_url)
  errors << "sitemap.xml: missing learning motivation article" unless sitemap_text.include?(learning_motivation_url)
end

feed = SITE.join("feed.xml")
if feed.file?
  feed_text = feed.read
  errors << "feed.xml: missing self-advocate review article" unless feed_text.include?(self_advocate_review_url)
  errors << "feed.xml: missing safety education practice article" unless feed_text.include?(intellectual_disability_safety_education_url)
  errors << "feed.xml: missing adult reading program article" unless feed_text.include?(adult_reading_program_url)
  errors << "feed.xml: missing learning motivation article" unless feed_text.include?(learning_motivation_url)
  errors << "feed.xml: missing diagnostic-overshadowing article" unless feed_text.include?(diagnostic_overshadowing_url)
  errors << "feed.xml: missing safety-literacy article" unless feed_text.include?(safety_literacy_url)
  errors << "feed.xml: missing education-demand article" unless feed_text.include?(education_demand_url)
  errors << "feed.xml: missing adult-respectful learning materials article" unless feed_text.include?(adult_respectful_materials_url)
  errors << "feed.xml: missing prompt-fading article" unless feed_text.include?(prompt_fading_url)
  errors << "feed.xml: missing self-determination education article" unless feed_text.include?(self_determination_education_url)
  if feed_text.include?(literacy_support_url)
    errors << "feed.xml: feed must contain only the latest 10 posts"
  end
  if feed_text.include?(ai_paper_url)
    errors << "feed.xml: feed must contain only the latest 10 posts"
  end
  if feed_text.include?(human_review_ai_url)
    errors << "feed.xml: feed must contain only the latest 10 posts"
  end
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
    "Open Graph title" => 'property="og:title" content="경도 지적장애 문해력 교육, 청소년·성인에게 왜 필요한가"',
    "Open Graph URL" => %(property="og:url" content="#{literacy_support_url}"),
    "published time" => 'property="article:published_time" content="2026-07-14T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{literacy_support_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-08-01T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-14T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{literacy_support_url}")
  }.each do |label, marker|
    errors << "#{literacy_support_path}: missing #{label}" unless html.include?(marker)
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
    "Open Graph title" => 'property="og:title" content="특수교육 AI, 지적장애인의 학습을 어떻게 도울 수 있는가"',
    "Open Graph URL" => %(property="og:url" content="#{ai_learning_support_url}"),
    "published time" => 'property="article:published_time" content="2026-07-03T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{ai_learning_support_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-08-01T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-07-03T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{ai_learning_support_url}")
  }.each do |label, marker|
    errors << "#{ai_learning_support_path}: missing #{label}" unless html.include?(marker)
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
    "English author name" => '"name":"Yunyoung Cho"',
    "English organization entity" => '"@id": "https://yunycho.github.io/naljabooks-blog/en/about/#organization"',
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
  ROOT.join("{*.md,*.html,_posts/*,_english/*,en/*,_includes/*,_layouts/*,robots.txt,llms*.txt,content*.json}")
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
