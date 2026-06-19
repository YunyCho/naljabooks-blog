#!/usr/bin/env ruby

require "optparse"
require "pathname"
require "time"
require_relative "../lib/naver_draft"

begin
options = {}
OptionParser.new do |parser|
  parser.on("--paths-file PATH") { |value| options[:paths_file] = value }
  parser.on("--source-commit SHA") { |value| options[:source_commit] = value }
  parser.on("--generated-at TIME") { |value| options[:generated_at] = value }
end.parse!

abort "--paths-file is required" unless options[:paths_file]
abort "--source-commit is required" unless options[:source_commit]

root = Pathname(__dir__).join("..").expand_path
paths = Pathname(options[:paths_file]).read.lines(chomp: true).reject(&:empty?)
generated_at = options[:generated_at] ? Time.iso8601(options[:generated_at]) : Time.now.utc
result = NaverDraft::Generator.new(
  root, source_commit: options[:source_commit], generated_at: generated_at
).generate(paths)

result.created.each { |path| puts "created: #{path}" }
result.skipped_language.each { |path| puts "skipped-language: #{path}" }
result.skipped_existing.each { |path| puts "skipped-existing: #{path}" }
rescue NaverDraft::Error, OptionParser::ParseError, ArgumentError => error
  warn error.message
  exit 1
end
