#!/usr/bin/env ruby

require "pathname"
require_relative "../lib/naver_draft"

root = Pathname(__dir__).join("..").expand_path
abort "Usage: scripts/list_new_posts.rb BEFORE_SHA AFTER_SHA" unless ARGV.length == 2

puts NaverDraft::PostDetector.new(root).added(ARGV.fetch(0), ARGV.fetch(1))
