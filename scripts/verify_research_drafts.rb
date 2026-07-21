#!/usr/bin/env ruby

require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
WHITEPAPER = ROOT.join("docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md")
DRAFT_DIR = ROOT.join("drafts/moderate-intellectual-disability-series")
DRAFTS = %w[
  01-expression-is-not-the-limit-of-understanding.md
  02-when-yes-is-not-informed-agreement.md
  03-private-speech-is-not-just-problem-behavior.md
  04-pain-and-sensory-needs-mistaken-for-intellectual-disability.md
  05-safety-literacy-against-counterfeit-friendship.md
].freeze
REQUIRED_DRAFT_LABELS = [
  "게시 후보 제목", "description", "권장 category", "권장 tags",
  "키워드 연결", "핵심 요약", "출처", "관련 글 연결 제안", "공개 전 확인"
].freeze
FORBIDDEN_ABSOLUTES = ["IQ 50의 세계", "어느 경우에도", "감정 기능은 온전하다", "40~100배", "80%"].freeze

errors = []
config = YAML.safe_load(ROOT.join("_config.yml").read, aliases: true)
errors << "_config.yml: drafts must be excluded" unless Array(config["exclude"]).include?("drafts")

unless WHITEPAPER.file?
  errors << "missing #{WHITEPAPER.relative_path_from(ROOT)}"
else
  text = WHITEPAPER.read
  ["[근거 A]", "[근거 B]", "[근거 C]", "[해석 D]", "설계 시사점", "근거 공백과 추가 검증"].each do |marker|
    errors << "whitepaper: missing #{marker}" unless text.include?(marker)
  end
  FORBIDDEN_ABSOLUTES.each do |phrase|
    errors << "whitepaper: unsafe phrase #{phrase}" if text.include?(phrase)
  end
end

DRAFTS.each do |name|
  path = DRAFT_DIR.join(name)
  unless path.file?
    errors << "missing #{path.relative_path_from(ROOT)}"
    next
  end
  text = path.read
  REQUIRED_DRAFT_LABELS.each do |label|
    errors << "#{name}: missing #{label}" unless text.include?(label)
  end
  errors << "#{name}: publication date must be assigned at publish time" if text.match?(/^date:|^updated:/)
  body_without_sources = text.split(/^## 출처/, 2).first
  errors << "#{name}: public terminology must center 지적장애인" if body_without_sources.match?(/발달장애인|발달장애/)
  FORBIDDEN_ABSOLUTES.each do |phrase|
    errors << "#{name}: unsafe phrase #{phrase}" if text.include?(phrase)
  end
end

site_drafts = ROOT.join("_site/drafts")
errors << "_site: drafts were published" if site_drafts.exist?

abort errors.join("\n") unless errors.empty?
puts "Research draft verification passed"
