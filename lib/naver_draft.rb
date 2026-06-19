module NaverDraft
  class Error < StandardError; end
end

require_relative "naver_draft/post_detector"
require_relative "naver_draft/post"
require_relative "naver_draft/formatter"
require_relative "naver_draft/generator"
