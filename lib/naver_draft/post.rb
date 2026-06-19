require "date"
require "pathname"
require "yaml"

module NaverDraft
  class Post
    FRONT_MATTER = /\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m
    FILENAME = /\A\d{4}-\d{2}-\d{2}-(.+)\.md\z/

    attr_reader :relative_path, :title, :tags, :body, :slug, :language

    def self.load(root, relative_path)
      root = Pathname(root).expand_path
      relative = Pathname(relative_path.to_s)
      posts_root = root.join("_posts").expand_path
      candidate = root.join(relative).expand_path
      allowed_prefix = "#{posts_root}#{File::SEPARATOR}"
      unless !relative.absolute? && candidate.to_s.start_with?(allowed_prefix) && candidate.dirname == posts_root
        raise Error, "post path must stay directly under _posts: #{relative_path}"
      end

      filename_match = FILENAME.match(candidate.basename.to_s)
      raise Error, "invalid post filename: #{relative_path}" unless filename_match

      document_match = FRONT_MATTER.match(candidate.read)
      raise Error, "invalid front matter delimiters: #{relative_path}" unless document_match

      metadata = YAML.safe_load(
        document_match[1], permitted_classes: [Date, Time], permitted_symbols: [], aliases: false
      )
      raise Error, "front matter must be a mapping: #{relative_path}" unless metadata.is_a?(Hash)

      title = metadata["title"].to_s.strip
      raise Error, "missing title: #{relative_path}" if title.empty?

      new(
        relative_path: relative.to_s,
        title: title,
        tags: Array(metadata["tags"]),
        body: document_match[2],
        slug: filename_match[1],
        language: metadata["lang"]&.to_s
      )
    rescue Errno::ENOENT => error
      raise Error, "post not found: #{error.message}"
    rescue Psych::Exception => error
      raise Error, "invalid YAML in #{relative_path}: #{error.message}"
    end

    def initialize(relative_path:, title:, tags:, body:, slug:, language:)
      @relative_path = relative_path
      @title = title
      @tags = tags
      @body = body
      @slug = slug
      @language = language
    end

    def korean?
      language.nil? || %w[ko ko-KR].include?(language)
    end
  end
end
