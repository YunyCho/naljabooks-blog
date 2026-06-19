require "fileutils"
require "pathname"
require "uri"
require "yaml"

module NaverDraft
  class Generator
    Result = Struct.new(:created, :skipped_language, :skipped_existing, keyword_init: true)
    SHA = /\A[0-9a-f]{7,40}\z/i

    def initialize(root, source_commit:, generated_at:)
      @root = Pathname(root).expand_path
      raise Error, "invalid source commit" unless SHA.match?(source_commit)

      @source_commit = source_commit
      @generated_at = generated_at
    end

    def generate(paths)
      formatter = formatter_from_config
      result = Result.new(created: [], skipped_language: [], skipped_existing: [])
      planned = {}

      paths.each do |path|
        post = Post.load(@root, path)
        unless post.korean?
          result.skipped_language << path
          next
        end

        relative_output = "naver-drafts/#{post.slug}.md"
        output = @root.join(relative_output)
        if output.exist?
          result.skipped_existing << relative_output
          next
        end
        raise Error, "duplicate draft slug: #{post.slug}" if planned.key?(output)

        planned[output] = formatter.render(
          post, source_commit: @source_commit, generated_at: @generated_at
        )
      end

      write_all(planned, result)
      result
    end

    private

    def write_all(planned, result)
      written = []
      begin
        @root.join("naver-drafts").mkpath unless planned.empty?
        planned.each do |output, content|
          File.open(output, File::CREAT | File::EXCL | File::WRONLY) { |file| file.write(content) }
          written << output
          result.created << output.relative_path_from(@root).to_s
        end
      rescue SystemCallError => error
        written.each { |path| FileUtils.rm_f(path) }
        raise Error, "draft write failed: #{error.message}"
      end
    end

    def formatter_from_config
      config = YAML.safe_load(@root.join("_config.yml").read, aliases: false)
      raise Error, "_config.yml must be a mapping" unless config.is_a?(Hash)

      url = config["url"].to_s.sub(%r{/+\z}, "")
      base_url = config["baseurl"].to_s
      uri = URI.parse(url)
      raise Error, "site url must use HTTPS" unless uri.is_a?(URI::HTTPS) && uri.host
      raise Error, "invalid baseurl" unless base_url.empty? || base_url.start_with?("/")
      raise Error, "unsupported permalink" unless config["permalink"] == "/archive/:title/"

      Formatter.new(site_url: url, base_url: base_url)
    rescue Errno::ENOENT, Psych::Exception, URI::InvalidURIError => error
      raise Error, "invalid site config: #{error.message}"
    end
  end
end
